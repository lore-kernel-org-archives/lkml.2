Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284Ab2KSVji (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 16:39:38 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35445 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab2KSVjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 16:39:37 -0500
Date: Mon, 19 Nov 2012 13:39:34 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Josh Triplett <josh@joshtriplett.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 25/58] mm: include/linux/huge_mm.h: Declare handle_pte_fault
 unconditionally
In-Reply-To: <1353302917-13995-26-git-send-email-josh@joshtriplett.org>
Message-ID: <alpine.DEB.2.00.1211191337420.12532@chino.kir.corp.google.com>
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org> <1353302917-13995-26-git-send-email-josh@joshtriplett.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Nov 2012, Josh Triplett wrote:

> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 3f39803..8ed2187 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -55,6 +55,10 @@ extern pmd_t *page_check_address_pmd(struct page *page,
>  
>  extern bool is_vma_temporary_stack(struct vm_area_struct *vma);
>  
> +extern int handle_pte_fault(struct mm_struct *mm,
> +			    struct vm_area_struct *vma, unsigned long address,
> +			    pte_t *pte, pmd_t *pmd, unsigned int flags);
> +
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>  #define HPAGE_PMD_SHIFT HPAGE_SHIFT
>  #define HPAGE_PMD_MASK HPAGE_MASK
> @@ -87,9 +91,6 @@ extern int copy_pte_range(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>  			  pmd_t *dst_pmd, pmd_t *src_pmd,
>  			  struct vm_area_struct *vma,
>  			  unsigned long addr, unsigned long end);
> -extern int handle_pte_fault(struct mm_struct *mm,
> -			    struct vm_area_struct *vma, unsigned long address,
> -			    pte_t *pte, pmd_t *pmd, unsigned int flags);
>  extern int split_huge_page(struct page *page);
>  extern void __split_huge_page_pmd(struct mm_struct *mm, pmd_t *pmd);
>  #define split_huge_page_pmd(__mm, __pmd)				\

huge_mm.h is the last place someone would expect to see the prototype for 
this function and it only exists because the thp code needs to use it and 
it was the easy place to put it.  Perhaps declare this in mm.h instead 
where the declaration of handle_mm_fault() is?
