Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab1BUOmp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 09:42:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6212 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755290Ab1BUOmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 09:42:44 -0500
Date: Mon, 21 Feb 2011 09:42:40 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: NeilBrown <neilb@suse.de>
Cc: Mike Snitzer <snitzer@redhat.com>, Jens Axboe <jaxboe@fusionio.com>,
        linux-kernel@vger.kernel.org
Subject: Re: blk_throtl_exit taking q->queue_lock is problematic
Message-ID: <20110221144240.GB6428@redhat.com>
References: <20110216155305.GC14653@redhat.com>
 <20110217113536.2bbf308e@notabene.brown>
 <20110217011029.GA6793@redhat.com>
 <20110217165501.47f3c26f@notabene.brown>
 <20110217165906.GE9075@redhat.com>
 <20110218134025.2a2e5bbb@notabene.brown>
 <AANLkTi=t0vFTTDr9jBZ70UmJ9YYzziA0cRP8t0T9wswW@mail.gmail.com>
 <20110218143325.5738e127@notabene.brown>
 <20110218150429.GB26654@redhat.com>
 <20110221182419.3545cdbb@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110221182419.3545cdbb@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 06:24:19PM +1100, NeilBrown wrote:
> On Fri, 18 Feb 2011 10:04:29 -0500 Vivek Goyal <vgoyal@redhat.com> wrote:
> 
> > On Fri, Feb 18, 2011 at 02:33:25PM +1100, NeilBrown wrote:
> > > On Thu, 17 Feb 2011 22:19:52 -0500 Mike Snitzer <snitzer@redhat.com> wrote:
> 
> > > > Noticed an inconsistency, raid10.c's additional locking also protects
> > > > the bio_list_add() whereas raid1.c's doesn't.  Seems the additional
> > > > protection in raid10 isn't needed?
> > > 
> > > Correct - not needed at all.
> > > I put it there because it felt a little cleaner keeping the two 'lock's
> > > together like the two 'unlock's.  Probably confusing though...
> > 
> > I guess you could use blk_plug_device_unlocked() to get rid of ugliness
> > and this routine will take care of taking queue lock.
> > 
> 
> Yep, that gets rid of some ugliness.
> I've made that change and will submit it in due course.
> So blk_throtl doesn't need any change to avoid the problem with md - that
> changes are made in md instead.

Thanks Neil. I might still end up moving blk_throtl_exit() to
blk_cleanup_queue() once I have sorted out blk_sync_queue(). Because
at the end of blk_cleanup_queue() driver is free to release the spin
lock and there are no gurantees that in blk_release_queue() lock is 
still there.

Thanks
Vivek
