Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751356Ab1F1Vku (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 17:40:50 -0400
Received: from gate.crashing.org ([63.228.1.57]:54672 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368Ab1F1Vko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 17:40:44 -0400
Subject: Re: [PATCH 2/5] hugetlb: add phys addr to struct huge_bootmem_page
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Becky Bruce <beckyb@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        david@gibson.dropbear.id.au, galak@kernel.crashing.org,
        wli@holomorphy.com
In-Reply-To: <13092910103675-git-send-email-beckyb@kernel.crashing.org>
References: <1309290888309-git-send-email-beckyb@kernel.crashing.org>
	 <13092909493748-git-send-email-beckyb@kernel.crashing.org>
	 <13092910103675-git-send-email-beckyb@kernel.crashing.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Jun 2011 07:39:26 +1000
Message-ID: <1309297166.32158.461.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-28 at 14:54 -0500, Becky Bruce wrote:
>  struct page *alloc_huge_page_node(struct hstate *h, int nid);
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 6402458..2db81ea 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1105,8 +1105,14 @@ static void __init
> gather_bootmem_prealloc(void)
>         struct huge_bootmem_page *m;
>  
>         list_for_each_entry(m, &huge_boot_pages, list) {
> -               struct page *page = virt_to_page(m);
>                 struct hstate *h = m->hstate;
> +#ifdef CONFIG_HIGHMEM
> +               struct page *page = pfn_to_page(m->phys >>
> PAGE_SHIFT);
> +               free_bootmem_late((unsigned long)m,
> +                                 sizeof(struct huge_bootmem_page));
> +#else
> +               struct page *page = virt_to_page(m);
> +#endif
>                 __ClearPageReserved(page);

Why do you add free_bootmem_late() in the highmem case and not the
normal case ?

Cheers,
Ben.

