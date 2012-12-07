Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424032Ab2LGCUf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 21:20:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60445 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754436Ab2LGCUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 21:20:34 -0500
Date: Thu, 6 Dec 2012 18:20:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi.kleen@intel.com>, Tony Luck <tony.luck@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 1/3] HWPOISON, hugetlbfs: fix warning on freeing
 hwpoisoned hugepage
Message-Id: <20121206182024.5f3b47be.akpm@linux-foundation.org>
In-Reply-To: <1354845824-5734-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <20121206143652.29c4922f.akpm@linux-foundation.org>
	<1354845824-5734-1-git-send-email-n-horiguchi@ah.jp.nec.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  6 Dec 2012 21:03:44 -0500 Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:

> This patch fixes the warning from __list_del_entry() which is triggered
> when a process tries to do free_huge_page() for a hwpoisoned hugepage.
> 
> ChangeLog v2:
>  - simply use list_del_init instead of introducing new hugepage list
> 
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> ---
>  mm/hugetlb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 59a0059..9308752 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -3170,7 +3170,7 @@ int dequeue_hwpoisoned_huge_page(struct page *hpage)
>  
>  	spin_lock(&hugetlb_lock);
>  	if (is_hugepage_on_freelist(hpage)) {
> -		list_del(&hpage->lru);
> +		list_del_init(&hpage->lru);

Can we please have a code comment in here explaining why
list_del_init() is used?

>  		set_page_refcounted(hpage);
>  		h->free_huge_pages--;
>  		h->free_huge_pages_node[nid]--;
