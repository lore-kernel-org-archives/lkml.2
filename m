Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab2FXTwp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 15:52:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8136 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752506Ab2FXTwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 15:52:44 -0400
Date: Sun, 24 Jun 2012 15:52:36 -0400
From: Dave Jones <davej@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch v2] mm, thp: print useful information when mmap_sem is
 unlocked in zap_pmd_range
Message-ID: <20120624195236.GA2153@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>,
	Sasha Levin <levinsasha928@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
References: <20120606165330.GA27744@redhat.com>
 <alpine.DEB.2.00.1206091904030.7832@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1206110214150.6843@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1206221405430.20954@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1206221405430.20954@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 02:06:40PM -0700, David Rientjes wrote:
 > On Mon, 11 Jun 2012, David Rientjes wrote:
 > 
 > > diff --git a/mm/memory.c b/mm/memory.c
 > > --- a/mm/memory.c
 > > +++ b/mm/memory.c
 > > @@ -1225,7 +1225,15 @@ static inline unsigned long zap_pmd_range(struct mmu_gather *tlb,
 > >  		next = pmd_addr_end(addr, end);
 > >  		if (pmd_trans_huge(*pmd)) {
 > >  			if (next - addr != HPAGE_PMD_SIZE) {
 > > -				VM_BUG_ON(!rwsem_is_locked(&tlb->mm->mmap_sem));
 > > +#ifdef CONFIG_DEBUG_VM
 > > +				if (!rwsem_is_locked(&tlb->mm->mmap_sem)) {
 > > +					pr_err("%s: mmap_sem is unlocked! addr=0x%lx end=0x%lx vma->vm_start=0x%lx vma->vm_end=0x%lx\n",
 > > +						__func__, addr, end,
 > > +						vma->vm_start,
 > > +						vma->vm_end);
 > > +					BUG();
 > > +				}
 > > +#endif
 > >  				split_huge_page_pmd(vma->vm_mm, pmd);
 > >  			} else if (zap_huge_pmd(tlb, vma, pmd, addr))
 > >  				goto next;
 > 
 > This patch is now in Linus' tree so if you are able to hit this issue and 
 > capture it again, we should be able to get much more useful information.

I've had it applied in my local builds for a while, but haven't managed
to hit it again recently.  Though I've not been doing as many overnight runs
this last week or two because temperatures at home have been icky enough
without computers belching out hot air (no ac)

	Dave

