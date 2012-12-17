Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab2LQRrY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 12:47:24 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:54582 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab2LQRrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 12:47:23 -0500
Date: Mon, 17 Dec 2012 09:47:17 -0800
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Jeff Moyer <jmoyer@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] core block IO bits for 3.8
Message-ID: <20121217174717.GC2592@htj.dyndns.org>
References: <50CF3B82.9000904@kernel.dk>
 <x49licwwtm8.fsf@segfault.boston.devel.redhat.com>
 <20121217170016.GA2592@htj.dyndns.org>
 <50CF50AA.7080600@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50CF50AA.7080600@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jens.

On Mon, Dec 17, 2012 at 06:04:42PM +0100, Jens Axboe wrote:
> OK, if you have something generic for threadpools in mind, we can wait
> with this one. I just thought that a "real" interface was nicer than
> manual setting, especially since the flusher threads come and go. Then
> you'd need some udev hook to get it set, not even sure how easy that
> would be with the weird linkage.

I've been thinking about this and I think what we really need is a
generic interface for thread pools where the user can specify various
attributes - priority, affinity and probably cgroup association, so
that those attributes are exposed in generic manner while backend
creates and manages worker pools identified by actual attriutes so
that we don't end up with gazillion pools.  crypto and writeback would
be the obvious users and probably the virtio too.  I'll write more
when things get more concrete.

Thanks.

-- 
tejun
