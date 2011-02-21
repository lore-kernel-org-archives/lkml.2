Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014Ab1BUHYb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 02:24:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46482 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752228Ab1BUHYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 02:24:30 -0500
Date: Mon, 21 Feb 2011 18:24:19 +1100
From: NeilBrown <neilb@suse.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Jens Axboe <jaxboe@fusionio.com>,
        linux-kernel@vger.kernel.org
Subject: Re: blk_throtl_exit taking q->queue_lock is problematic
Message-ID: <20110221182419.3545cdbb@notabene.brown>
In-Reply-To: <20110218150429.GB26654@redhat.com>
References: <20110216183114.26a3613b@notabene.brown>
	<20110216155305.GC14653@redhat.com>
	<20110217113536.2bbf308e@notabene.brown>
	<20110217011029.GA6793@redhat.com>
	<20110217165501.47f3c26f@notabene.brown>
	<20110217165906.GE9075@redhat.com>
	<20110218134025.2a2e5bbb@notabene.brown>
	<AANLkTi=t0vFTTDr9jBZ70UmJ9YYzziA0cRP8t0T9wswW@mail.gmail.com>
	<20110218143325.5738e127@notabene.brown>
	<20110218150429.GB26654@redhat.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Feb 2011 10:04:29 -0500 Vivek Goyal <vgoyal@redhat.com> wrote:

> On Fri, Feb 18, 2011 at 02:33:25PM +1100, NeilBrown wrote:
> > On Thu, 17 Feb 2011 22:19:52 -0500 Mike Snitzer <snitzer@redhat.com> wrote:

> > > Noticed an inconsistency, raid10.c's additional locking also protects
> > > the bio_list_add() whereas raid1.c's doesn't.  Seems the additional
> > > protection in raid10 isn't needed?
> > 
> > Correct - not needed at all.
> > I put it there because it felt a little cleaner keeping the two 'lock's
> > together like the two 'unlock's.  Probably confusing though...
> 
> I guess you could use blk_plug_device_unlocked() to get rid of ugliness
> and this routine will take care of taking queue lock.
> 

Yep, that gets rid of some ugliness.
I've made that change and will submit it in due course.
So blk_throtl doesn't need any change to avoid the problem with md - that
changes are made in md instead.

Thanks,
NeilBrown

