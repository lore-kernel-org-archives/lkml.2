Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab1BQFzN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 00:55:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58938 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753798Ab1BQFzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 00:55:11 -0500
Date: Thu, 17 Feb 2011 16:55:01 +1100
From: NeilBrown <neilb@suse.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, linux-kernel@vger.kernel.org
Subject: Re: blk_throtl_exit  taking q->queue_lock is problematic
Message-ID: <20110217165501.47f3c26f@notabene.brown>
In-Reply-To: <20110217011029.GA6793@redhat.com>
References: <20110216183114.26a3613b@notabene.brown>
	<20110216155305.GC14653@redhat.com>
	<20110217113536.2bbf308e@notabene.brown>
	<20110217011029.GA6793@redhat.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Feb 2011 20:10:29 -0500 Vivek Goyal <vgoyal@redhat.com> wrote:

> So is it possible to keep the spinlock intact when md is calling up
> blk_cleanup_queue()?
> 

It would be possible, yes - but messy.  I would probably end up just making
->queue_lock always point to __queue_lock, and then only take it at the
places where I call 'block' code which wants to test to see if it is
currently held (like the plugging routines).

The queue lock (and most of the request queue) is simply irrelevant for md.
I would prefer to get away from having to touch it at all...

I'll see how messy it would be to stop using it completely and it can just be
__queue_lock.

Though for me - it would be much easier if you just used __queue_lock .....


NeilBrown
