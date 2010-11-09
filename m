Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347Ab0KIR6g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 12:58:36 -0500
Received: from kroah.org ([198.145.64.141]:35006 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752437Ab0KIR6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 12:58:34 -0500
Date: Tue, 9 Nov 2010 09:58:28 -0800
From: Greg KH <greg@kroah.com>
To: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>,
        Omar Ramirez Luna <omar.ramirez@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        linux-omap@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [GIT PULL] fixes for tidspbridge 2.6.37-rc1
Message-ID: <20101109175828.GA27627@kroah.com>
References: <AANLkTinZF-47WQyF5k1Nv64NjfMNSQ-+oE0eGycR24NM@mail.gmail.com>
 <AANLkTikB0zhN13u5OtRwviOv-rFDW-vFTmq0t7ALuO7N@mail.gmail.com>
 <201011091729.17679.arnd@arndb.de>
 <20101109165509.GA9698@kroah.com>
 <AANLkTinFW431t9XFqHc=wZAws9gjT0ikrc03J83kH7iF@mail.gmail.com>
 <20101109172511.GA10958@kroah.com>
 <AANLkTi=CKERMcSLXwQa7G55P69DO--UPN9HgOScHP_yO@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=CKERMcSLXwQa7G55P69DO--UPN9HgOScHP_yO@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 11:49:30AM -0600, Guzman Lugo, Fernando wrote:
> On Tue, Nov 9, 2010 at 11:25 AM, Greg KH <greg@kroah.com> wrote:
> > On Tue, Nov 09, 2010 at 11:04:18AM -0600, Guzman Lugo, Fernando wrote:
> >> On Tue, Nov 9, 2010 at 10:55 AM, Greg KH <greg@kroah.com> wrote:
> >> > On Tue, Nov 09, 2010 at 05:29:17PM +0100, Arnd Bergmann wrote:
> >> >> On Tuesday 09 November 2010, Felipe Contreras wrote:
> >> >> > Felipe Contreras (14):
> >> >> >       Revert "staging: tidspbridge - update Kconfig to select IOMMU module"
> >> >> >       Revert "staging: tidspbridge - remove dmm custom module"
> >> >> >       Revert "staging: tidspbridge - deprecate reserve/unreserve_memory funtions"
> >> >> >       Revert "staging: tidspbridge - remove reserved memory clean up"
> >> >> >       Revert "staging: tidspbridge: remove dw_dmmu_base from cfg_hostres struct"
> >> >> >       Revert "staging: tidspbridge - move all iommu related code to a new file"
> >> >> >       Revert "staging: tidspbridge - remove hw directory"
> >> >> >       Revert "staging: tidspbridge - fix mmufault support"
> >> >> >       Revert "staging: tidspbridge - remove custom mmu code from tiomap3430.c"
> >> >> >       Revert "staging: tidspbridge - rename bridge_brd_mem_map/unmap to a proper name"
> >> >> >       Revert "staging: tidspbridge - move shared memory iommu maps to tiomap3430.c"
> >> >> >       Revert "staging: tidspbridge: replace iommu custom for opensource implementation"
> >> >>
> >> >> That adds quite a lot of crap back in that was removed by Fernando earlier:
> >> >>
> >> >>  44 files changed, 3733 insertions(+), 847 deletions(-)
> >> >>
> >> >> It may have been premature to merge the patches as you say, but now that
> >> >> they are in, I'd vote for giving Fernando a chance to fix up any damage
> >> >> that was done in the process rather than just reverting all the useful
> >> >> changes.
> >> >
> >> > In looking at this further, I agree.
> >> >
> >> > Felipe, are all of these really needing to be reverted?  How about
> >> > picking out the functional changes that need to be resolved instead of
> >> > just rolling back everything that has been done here.  Surely not all of
> >> > these are wrong, right?
> >>
> >> Patches are _NOT_ wrong, missing dependencies break the bridge.
> >> Without that dependencies the first patch of the set won't work and
> >> all other patches have dependency on the first one, so all of them
> >> need to be reverted.
> >
> > How about hand-reverting only the wrong patch, so the other work isn't
> > lost?  I'd much prefer that.
> 
> Unfortunately any of the iommu migration patches will work correctly
> without the dependencies on iommu module patches. There are some
> patches which cleanup the code, but thanks to the iommu migrations the
> files can disappear complete other wise I need to check and only clean
> what is not needed and leave what the old custom implementation is
> using, which will need a lot of rework in the patches. According with
> Felipe Contreras it is very easy reverting and pushing after.

If it is easy to revert and push later, then the "revert just this
piece" should be done now.

Seriously, I'm getting very confused here, and am very annoyed by the
whole thing.

Here's what I don't like:
  - the original driver didn't even seem to work properly
  - people sent me patches they never tested and broke things even worse
  - some people have no respect for the omap maintainers and what they
    think about things, or even basic knowledge of the kernel
    development cycle.
  - I do not have this hardware so I can't test anything.

So, from now on, I'm not taking ANYONES patches for this driver unless
it gets an ack from the driver maintainer, Omar Luna.

Actually, no, I'm not going to take any patch unless it _comes from_
Omar.  Omar, please work to queue up patches and test them, and then
send them to me for merging.

Any questions?

If anyone doesn't like this because they feel that the current driver is
broken, well, I can easily solve that by just deleting the whole thing
from the tree right now.  Would that be a better idea?

Ugh, what a mess...

greg k-h
