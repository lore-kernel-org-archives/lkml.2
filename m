Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab2E1TOo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 15:14:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40300 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753534Ab2E1TOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 15:14:43 -0400
Date: Mon, 28 May 2012 21:14:42 +0200
From: Michal Hocko <mhocko@suse.cz>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com,
        akpm@linux-foundation.org, rientjes@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/hugetlb: Use hstate_index instead of open coding it
Message-ID: <20120528191441.GB10071@tiehlicka.suse.cz>
References: <1338218473-30933-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338218473-30933-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 28-05-12 20:51:13, Aneesh Kumar K.V wrote:
> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
> 
> Use hstate_index in hugetlb_init
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Reviewed-by: Michal Hocko <mhocko@suse.cz>

> ---
>  mm/hugetlb.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 4b90dd5..58eead5 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1891,7 +1891,7 @@ static int __init hugetlb_init(void)
>  		if (!size_to_hstate(default_hstate_size))
>  			hugetlb_add_hstate(HUGETLB_PAGE_ORDER);
>  	}
> -	default_hstate_idx = size_to_hstate(default_hstate_size) - hstates;
> +	default_hstate_idx = hstate_index(size_to_hstate(default_hstate_size));
>  	if (default_hstate_max_huge_pages)
>  		default_hstate.max_huge_pages = default_hstate_max_huge_pages;
>  
> -- 
> 1.7.10
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
