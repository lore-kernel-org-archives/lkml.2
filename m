Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832Ab1AERYf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 12:24:35 -0500
Received: from gir.skynet.ie ([193.1.99.77]:55444 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725Ab1AERYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 12:24:34 -0500
Date: Wed, 5 Jan 2011 17:24:13 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Eric B Munson <emunson@mgebm.net>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, caiqian@redhat.com, stable@kernel.org
Subject: Re: [PATCH] Fix handling of parse errors in sysctl
Message-ID: <20110105172412.GA29257@csn.ul.ie>
References: <1294247329-11682-1-git-send-email-emunson@mgebm.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1294247329-11682-1-git-send-email-emunson@mgebm.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 05, 2011 at 10:08:49AM -0700, Eric B Munson wrote:
> This patch is a candidate for stable.
> 
> ==== CUT HERE ====
> 
> When parsing changes to the huge page pool sizes made from userspace
> via the sysctl interface, bogus input values are being covered up
> by nr_hugepages_store_common and nr_overcommit_hugepages_store
> returning 0 when strict_strtoul returns an error. 

Not just that, it can infinite loop so it's a fairly serious problem.

> This patch changes
> the return value for these functions to -EINVAL when strict_strtoul
> returns an error.
> 
> Reported-by: CAI Qian <caiqian@redhat.com>
> 
> Signed-off-by: Eric B Munson <emunson@mgebm.net>

Acked-by: Mel Gorman <mel@csn.ul.ie>

> ---
>  mm/hugetlb.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 8585524..5cb71a9 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1440,7 +1440,7 @@ static ssize_t nr_hugepages_store_common(bool obey_mempolicy,
>  
>  	err = strict_strtoul(buf, 10, &count);
>  	if (err)
> -		return 0;
> +		return -EINVAL;
>  
>  	h = kobj_to_hstate(kobj, &nid);
>  	if (nid == NUMA_NO_NODE) {
> @@ -1519,7 +1519,7 @@ static ssize_t nr_overcommit_hugepages_store(struct kobject *kobj,
>  
>  	err = strict_strtoul(buf, 10, &input);
>  	if (err)
> -		return 0;
> +		return -EINVAL;
>  
>  	spin_lock(&hugetlb_lock);
>  	h->nr_overcommit_huge_pages = input;

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
