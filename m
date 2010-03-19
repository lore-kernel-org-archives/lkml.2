Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939Ab0CSGdZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 02:33:25 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:50633 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab0CSGdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 02:33:24 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 19 Mar 2010 15:29:34 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, andi.kleen@intel.com, fengguang.wu@intel.com
Subject: Re: [PATCH 1/2] pagemap: add #ifdefs CONFIG_HUGETLB_PAGE on code
 walking hugetlb vma
Message-Id: <20100319152934.c4243698.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1268979996-12297-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1268979996-12297-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Mar 2010 15:26:35 +0900
Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:

> If !CONFIG_HUGETLB_PAGE, pagemap_hugetlb_range() is never called.
> So put it (and its calling function) into #ifdef block.
> 
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

Hmm? What is benefit ? Is this broken now ?

Thanks,
-Kame

> ---
>  fs/proc/task_mmu.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 183f8ff..2a3ef17 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -652,6 +652,7 @@ static int pagemap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>  	return err;
>  }
>  
> +#ifdef CONFIG_HUGETLB_PAGE
>  static u64 huge_pte_to_pagemap_entry(pte_t pte, int offset)
>  {
>  	u64 pme = 0;
> @@ -695,6 +696,7 @@ static int pagemap_hugetlb_range(pte_t *pte, unsigned long addr,
>  
>  	return err;
>  }
> +#endif /* HUGETLB_PAGE */
>  
>  /*
>   * /proc/pid/pagemap - an array mapping virtual pages to pfns
> @@ -788,7 +790,9 @@ static ssize_t pagemap_read(struct file *file, char __user *buf,
>  
>  	pagemap_walk.pmd_entry = pagemap_pte_range;
>  	pagemap_walk.pte_hole = pagemap_pte_hole;
> +#ifdef CONFIG_HUGETLB_PAGE
>  	pagemap_walk.hugetlb_entry = pagemap_hugetlb_range;
> +#endif
>  	pagemap_walk.mm = mm;
>  	pagemap_walk.private = &pm;
>  
> -- 
> 1.7.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

