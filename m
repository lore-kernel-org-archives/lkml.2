Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268Ab2IONiv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 09:38:51 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:55306 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab2IONis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 09:38:48 -0400
Date: Sat, 15 Sep 2012 15:38:33 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.cz,
        Catalin Marinas <catalin.marinas@arm.com>,
        Steve Capper <steve.capper@arm.com>
Subject: Re: [PATCH 2/3] mm: thp: Fix the update_mmu_cache() last argument
 passing in mm/huge_memory.c
Message-ID: <20120915133833.GA32398@linux-mips.org>
References: <1347382036-18455-1-git-send-email-will.deacon@arm.com>
 <1347382036-18455-3-git-send-email-will.deacon@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347382036-18455-3-git-send-email-will.deacon@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2012 at 05:47:15PM +0100, Will Deacon wrote:

> The update_mmu_cache() takes a pointer (to pte_t by default) as the last
> argument but the huge_memory.c passes a pmd_t value. The patch changes
> the argument to the pmd_t * pointer.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Steve Capper <steve.capper@arm.com>
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> ---
>  mm/huge_memory.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 57c4b93..4aa6d02 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -934,7 +934,7 @@ int do_huge_pmd_wp_page(struct mm_struct *mm, struct vm_area_struct *vma,
>  		entry = pmd_mkyoung(orig_pmd);
>  		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
>  		if (pmdp_set_access_flags(vma, haddr, pmd, entry,  1))
> -			update_mmu_cache(vma, address, entry);
> +			update_mmu_cache(vma, address, pmd);

Documentation/cachetlb.txt will need an update as well.  Currently it says:

5) void update_mmu_cache(struct vm_area_struct *vma,
                         unsigned long address, pte_t *ptep)

I would prefer we introduce something like update_mmu_cache_huge_page(vma,
address, pmd) and leave the classic update_mmu_cache() unchanged.

  Ralf
