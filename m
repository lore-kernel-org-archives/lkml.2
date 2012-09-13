Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479Ab2IMANL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 20:13:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45347 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757393Ab2IMANE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 20:13:04 -0400
Date: Thu, 13 Sep 2012 02:12:55 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Will Deacon <will.deacon@arm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 0/3] Minor changes to common hugetlb code for ARM
Message-ID: <20120913001255.GD3404@redhat.com>
References: <1347382036-18455-1-git-send-email-will.deacon@arm.com>
 <20120912152759.GR21579@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120912152759.GR21579@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

On Wed, Sep 12, 2012 at 05:27:59PM +0200, Michal Hocko wrote:
> On Tue 11-09-12 17:47:13, Will Deacon wrote:
> > Hello,
> 
> Hi,
> 
> > A few changes are required to common hugetlb code before the ARM support
> > can be merged. I posted the main one previously, which has been picked up
> > by akpm:
> > 
> >   http://marc.info/?l=linux-mm&m=134573987631394&w=2
> > 
> > The remaining three patches (included here) are all fairly minor but do
> > affect other architectures.
> 
> I am quite confused. Why THP changes are required for hugetlb code for
> ARM?

Some functions are just noops on x86 and with no arch other than x86
building the huge_memory.c file, those x86-noop parts that needed
minor interface adjustments couldn't be noticed until now.

Hopefully we got the brainer part right (i.e. the location of the x86
noop callouts), it's clearly untested.

> Besides that I would suggest adding Andrea to the CC (added now the
> whole series can be found here http://lkml.org/lkml/2012/9/11/322) list
> for all THP changes.
> 
> > 
> > All comments welcome,
> > 
> > Will
> > 
> > Catalin Marinas (2):
> >   mm: thp: Fix the pmd_clear() arguments in pmdp_get_and_clear()
> >   mm: thp: Fix the update_mmu_cache() last argument passing in
> >     mm/huge_memory.c

Both:

Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>

> > 
> > Steve Capper (1):
> >   mm: Introduce HAVE_ARCH_TRANSPARENT_HUGEPAGE

This was already introduced by the s390 THP support which I reviewed a
few days ago, and it's already included in -mm, so it can be dropped.

Thanks!
Andrea
