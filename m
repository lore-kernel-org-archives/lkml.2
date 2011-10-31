Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934775Ab1JaW4e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 18:56:34 -0400
Received: from smtp-out.google.com ([216.239.44.51]:45561 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934719Ab1JaW4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 18:56:33 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=Dt/5aQbn0lcsWgzncb0haJkxFpCzFsHUSU9BVlGv5fv4Cbt3edF9rNTEUCGHcgfa5
	AxWNJUvAoWAk1tLxC6Y0g==
Date: Mon, 31 Oct 2011 15:56:28 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@kernel.org>
cc: x86@kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [RFC/PATCH 6/7] x86, mm: Prepare zone_sizes_init() for
 unification
In-Reply-To: <1319811801-1725-6-git-send-email-penberg@kernel.org>
Message-ID: <alpine.DEB.2.00.1110311554580.22237@chino.kir.corp.google.com>
References: <1319811801-1725-1-git-send-email-penberg@kernel.org> <1319811801-1725-6-git-send-email-penberg@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Oct 2011, Pekka Enberg wrote:

> diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
> index 6101894..12274fb 100644
> --- a/arch/x86/mm/init_32.c
> +++ b/arch/x86/mm/init_32.c
> @@ -677,10 +677,14 @@ void __init initmem_init(void)
>  static void __init zone_sizes_init(void)
>  {
>  	unsigned long max_zone_pfns[MAX_NR_ZONES];
> +
>  	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
>  #ifdef CONFIG_ZONE_DMA
>  	max_zone_pfns[ZONE_DMA] = MAX_DMA_PFN;
>  #endif
> +#ifdef CONFIG_ZONE_DMA32
> +        max_zone_pfns[ZONE_DMA32] = MAX_DMA32_PFN;
> +#endif
>  	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
>  #ifdef CONFIG_HIGHMEM
>  	max_zone_pfns[ZONE_HIGHMEM] = max_pfn;
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index f6b1f08..06c4360 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -624,6 +624,9 @@ static void __init zone_sizes_init(void)
>  	max_zone_pfns[ZONE_DMA32] = MAX_DMA32_PFN;
>  #endif
>  	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
> +#ifdef CONFIG_HIGHMEM
> +	max_zone_pfns[ZONE_HIGHMEM] = max_pfn;
> +#endif
>  
>  	free_area_init_nodes(max_zone_pfns);
>  }

I'd just fold patch 7 into this, it doesn't make much sense to have add 
CONFIG_HIGHMEM code for 64-bit, for example, just to make the next patch 
simpler.
