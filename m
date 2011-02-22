Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024Ab1BVKDG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 05:03:06 -0500
Received: from gir.skynet.ie ([193.1.99.77]:34105 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335Ab1BVKDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 05:03:04 -0500
Date: Tue, 22 Feb 2011 10:02:36 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Petr Holasek <pholasek@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-mm@kvack.org
Subject: Re: [PATCH] hugetlbfs: correct handling of negative input to
	/proc/sys/vm/nr_hugepages
Message-ID: <20110222100235.GA15652@csn.ul.ie>
References: <1298303270-3184-1-git-send-email-pholasek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1298303270-3184-1-git-send-email-pholasek@redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 04:47:49PM +0100, Petr Holasek wrote:
> When user insert negative value into /proc/sys/vm/nr_hugepages it will result
> in the setting a random number of HugePages in system (can be easily showed
> at /proc/meminfo output).

I bet you a shiny penny that the value of HugePages becomes the maximum
number that could be allocated by the system at the time rather than a
random value.

> This patch fixes the wrong behavior so that the
> negative input will result in nr_hugepages value unchanged.
> 

As pointed out elsewhere, nr_overcommit_hugepages also needs fixing but
the fix is essentially the same.

> Signed-off-by: Petr Holasek <pholasek@redhat.com>
> ---
>  mm/hugetlb.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index bb0b7c1..f99d7a8 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1872,8 +1872,7 @@ static int hugetlb_sysctl_handler_common(bool obey_mempolicy,
>  	unsigned long tmp;
>  	int ret;
>  
> -	if (!write)
> -		tmp = h->max_huge_pages;
> +	tmp = h->max_huge_pages;
>  
>  	if (write && h->order >= MAX_ORDER)
>  		return -EINVAL;
> -- 
> 1.7.1
> 

-- 
Mel Gorman
SUSE Labs
