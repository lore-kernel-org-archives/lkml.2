Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752Ab1GDIz4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 04:55:56 -0400
Received: from smtp.nokia.com ([147.243.1.47]:56566 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756205Ab1GDIzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 04:55:53 -0400
Date: Mon, 4 Jul 2011 11:51:26 +0300
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: ext Dave Chinner <david@fromorbit.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH 3/7] xfs: there is no CONFIG_KDB_MODULES
Message-ID: <20110704085126.GI19426@pcarmody2.research.nokia.com>
References: <1309643272-364-1-git-send-email-ext-phil.2.carmody@nokia.com>
 <1309643272-364-2-git-send-email-ext-phil.2.carmody@nokia.com>
 <1309643272-364-3-git-send-email-ext-phil.2.carmody@nokia.com>
 <1309643272-364-4-git-send-email-ext-phil.2.carmody@nokia.com>
 <20110704045820.GE1026@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110704045820.GE1026@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/11 14:58 +1000, ext Dave Chinner wrote:
> On Sun, Jul 03, 2011 at 12:47:48AM +0300, Phil Carmody wrote:
> 
> Hi Phil,
> 
> You should probably cc the relevant lists with such patchsets so the
> developers actually see the patches go by....

Yeah, I was wondering how to do that. The idea of cc:ing about 30
people for the whole set seemed a bit too spammy, and wasn't sure if
individually-selected cc:lists for eack of the patches made sense.
The alternative was to make it 7 (or more...) independent patchsets, 
but that turned the task into too much of a game of chess. I chickened 
out of thinking more, and cowardly went for the 'trivial' route.

I realised after sending that a truly trivial patch still hadn't 
been done - there are a whole bunch of comments or printk strings
that refer to the wrong options that I forgot to fix. So there
will be a v2.

> > Seems like there was a decade ago, but no longer, so this block
> > is dead code. The list being returned disappeared back in commit
> > ff57ab21995a8636cfc72efeebb09cc6034d756f.
> 
> When you quote a commit, short form followed by the name (i.e.
> one-line form) is preferable because it gives context to the commit
> without needing to go look it up in a git tree. Commit IDs are not
> human readable, while commit log should be.

Yup, good point, I can clean that up.
 
> The commit in question - ff57ab2 ("xfs: convert xfsbud shrinker to a
> per-buftarg shrinker.") - removed the list but the code being
> removed was already long dead. FWIW, I know just by reading the
> commit description when the list went away and who was responsible
> for missing that. i.e. me. ;)
> 
> > Part of a shotgun patchset; found by greps, seds, and diffs
> > rather than actual understanding.
> 
> Not necessary in a commit description - the zero patch of a series,
> yes, to describe how the issues were found, but it doesn't need to
> be recorded forever in the commit log. ;)

Sure. Thanks for the feedback, and look forward to v2!

Phil

> > Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
> > ---
> >  fs/xfs/linux-2.6/xfs_buf.c |    8 --------
> >  fs/xfs/linux-2.6/xfs_buf.h |    4 ----
> >  2 files changed, 0 insertions(+), 12 deletions(-)
> > 
> > diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
> > index 5e68099..5bccae0 100644
> > --- a/fs/xfs/linux-2.6/xfs_buf.c
> > +++ b/fs/xfs/linux-2.6/xfs_buf.c
> > @@ -1889,11 +1889,3 @@ xfs_buf_terminate(void)
> >  	destroy_workqueue(xfslogd_workqueue);
> >  	kmem_zone_destroy(xfs_buf_zone);
> >  }
> > -
> > -#ifdef CONFIG_KDB_MODULES
> > -struct list_head *
> > -xfs_get_buftarg_list(void)
> > -{
> > -	return &xfs_buftarg_list;
> > -}
> > -#endif
> > diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
> > index 50a7d5f..6881321 100644
> > --- a/fs/xfs/linux-2.6/xfs_buf.h
> > +++ b/fs/xfs/linux-2.6/xfs_buf.h
> > @@ -339,10 +339,6 @@ extern void xfs_wait_buftarg(xfs_buftarg_t *);
> >  extern int xfs_setsize_buftarg(xfs_buftarg_t *, unsigned int, unsigned int);
> >  extern int xfs_flush_buftarg(xfs_buftarg_t *, int);
> >  
> > -#ifdef CONFIG_KDB_MODULES
> > -extern struct list_head *xfs_get_buftarg_list(void);
> > -#endif
> > -
> >  #define xfs_getsize_buftarg(buftarg)	block_size((buftarg)->bt_bdev)
> >  #define xfs_readonly_buftarg(buftarg)	bdev_read_only((buftarg)->bt_bdev)
> 
> Code changes look good. Can you fix the commit description and
> resend to xfs@oss.sgi.com?
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
