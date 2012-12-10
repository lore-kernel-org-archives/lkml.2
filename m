Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab2LJLZh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 06:25:37 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:54760 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122Ab2LJLZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 06:25:36 -0500
Message-ID: <1355138235.1821.0.camel@kernel.cn.ibm.com>
Subject: Re: [PATCH 3/3] HWPOISON, hugetlbfs: fix RSS-counter warning
From: Simon Jeons <simon.jeons@gmail.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi.kleen@intel.com>, Tony Luck <tony.luck@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Date: Mon, 10 Dec 2012 05:17:15 -0600
In-Reply-To: <1354744058-26373-4-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1354744058-26373-1-git-send-email-n-horiguchi@ah.jp.nec.com>
	 <1354744058-26373-4-git-send-email-n-horiguchi@ah.jp.nec.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.1 (3.4.1-2.fc17) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-12-05 at 16:47 -0500, Naoya Horiguchi wrote:
> Memory error handling on hugepages can break a RSS counter, which emits
> a message like "Bad rss-counter state mm:ffff88040abecac0 idx:1 val:-1".
> This is because PageAnon returns true for hugepage (this behavior is

Could you explain why PageAnon returns true for hugepage?

> necessary for reverse mapping to work on hugetlbfs).
> 
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> ---
>  mm/rmap.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git v3.7-rc8.orig/mm/rmap.c v3.7-rc8/mm/rmap.c
> index 2ee1ef0..df54ef0 100644
> --- v3.7-rc8.orig/mm/rmap.c
> +++ v3.7-rc8/mm/rmap.c
> @@ -1235,7 +1235,9 @@ int try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
>  	update_hiwater_rss(mm);
>  
>  	if (PageHWPoison(page) && !(flags & TTU_IGNORE_HWPOISON)) {
> -		if (PageAnon(page))
> +		if (PageHuge(page))
> +			;
> +		else if (PageAnon(page))
>  			dec_mm_counter(mm, MM_ANONPAGES);
>  		else
>  			dec_mm_counter(mm, MM_FILEPAGES);


