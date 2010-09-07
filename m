Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388Ab0IGKQw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 06:16:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53926 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756299Ab0IGKQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 06:16:46 -0400
Date: Tue, 7 Sep 2010 12:16:43 +0200
From: Jan Sembera <jsembera@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        ink@jurassic.park.msu.ru, stable@kernel.org,
        linux-ia64@vger.kernel.org, "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [PATCH] binfmt_misc: Fix binfmt_misc priority
Message-ID: <20100907101642.GE8606@alaris.suse.cz>
References: <20100823141520.GB17894@alaris.suse.cz>
 <20100903142003.b6f02a0c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100903142003.b6f02a0c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 03, 2010 at 02:20:03PM -0700, Andrew Morton wrote:
> (cc stable@kernel.org and the ia64 d00ds)

Note that this isn't actually ia64 specific, ia32el is just where we
(actually our customer) noticed this first. It happens on any architectures,
if by any chance you would need to match something with binfmt_misc that
would be accepted by another binfmt...

> > Commit 74641f584da introduced a regression - binfmt_misc is now consulted
> > after binfmt_elf, which will unfortunately break ia32el. ia32 ELF binaries
> > on ia64 used to be matched using binfmt_misc and executed using wrapper. As
> > 32bit binaries are now matched by binfmt_elf before bindmt_misc kicks in,
> > the wrapper is ignored.
> > 
> > The fix increases precedence of binfmt_misc to the original state.
> > 
> > Signed-off-by: Jan Sembera <jsembera@suse.cz>
> > ---
> >  fs/binfmt_misc.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
> > index a7528b9..fd0cc0b 100644
> > --- a/fs/binfmt_misc.c
> > +++ b/fs/binfmt_misc.c
> > @@ -724,7 +724,7 @@ static int __init init_misc_binfmt(void)
> >  {
> >  	int err = register_filesystem(&bm_fs_type);
> >  	if (!err) {
> > -		err = register_binfmt(&misc_format);
> > +		err = insert_binfmt(&misc_format);
> >  		if (err)
> >  			unregister_filesystem(&bm_fs_type);
> >  	}
>
> Yikes, 74641f584da was merged in May 2009.  I wonder why this problem
> wasn't noticed before now?

Not sure, probably not very common use case and it slipped through our
testing before release.

Thanks,

Jan
