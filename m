Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab1BXIQr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 03:16:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38058 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754635Ab1BXIQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 03:16:46 -0500
Date: Thu, 24 Feb 2011 09:16:15 +0100
From: Anton Arapov <anton@redhat.com>
To: Petr Holasek <pholasek@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-mm@kvack.org
Subject: Re: [PATCH v2] hugetlbfs: correct handling of negative input to
 /proc/sys/vm/nr_hugepages
Message-ID: <20110224081615.GE2511@bandura.usersys.redhat.com>
References: <4D6419C0.8080804@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6419C0.8080804@redhat.com>
X-PGP-Key: http://people.redhat.com/aarapov/gpg
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 09:17:04PM +0100, Petr Holasek wrote:
> When user insert negative value into /proc/sys/vm/nr_hugepages it
> will result
> in the setting a random number of HugePages in system (can be easily showed
> at /proc/meminfo output). This patch fixes the wrong behavior so that the
> negative input will result in nr_hugepages value unchanged.
> 
> v2: same fix was also done in hugetlb_overcommit_handler function
>     as suggested by reviewers.
> 
> Signed-off-by: Petr Holasek <pholasek@redhat.com>
> Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> ---
>  mm/hugetlb.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index bb0b7c1..06de5aa 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1872,8 +1872,7 @@ static int hugetlb_sysctl_handler_common(bool
> obey_mempolicy,
>      unsigned long tmp;
>      int ret;
> 
> -    if (!write)
> -        tmp = h->max_huge_pages;
> +    tmp = h->max_huge_pages;
> 
>      if (write && h->order >= MAX_ORDER)
>          return -EINVAL;
> @@ -1938,8 +1937,7 @@ int hugetlb_overcommit_handler(struct
> ctl_table *table, int write,
>      unsigned long tmp;
>      int ret;
> 
> -    if (!write)
> -        tmp = h->nr_overcommit_huge_pages;
> +    tmp = h->nr_overcommit_huge_pages;
> 
>      if (write && h->order >= MAX_ORDER)
>          return -EINVAL;
> -- 
> 1.7.1
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
 
Signed-off-by: Anton Arapov <anton@redhat.com>

-- 
Anton
