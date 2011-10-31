Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934755Ab1JaWw3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 18:52:29 -0400
Received: from smtp-out.google.com ([216.239.44.51]:44848 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934709Ab1JaWw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 18:52:28 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=J2h0TP+EoD0dLmeBowITTX3xAQPqux8VUKPSqFHZeW17D5qcII4dMm2yj8pPwa/6M
	6WfuXt899KQ0UGnMzr6QQ==
Date: Mon, 31 Oct 2011 15:52:21 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@kernel.org>
cc: x86@kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Arun Sharma <asharma@fb.com>
Subject: Re: [RFC/PATCH 4/7] x86, mm: Wrap ZONE_DMA32 with
 CONFIG_ZONE_DMA32
In-Reply-To: <1319811801-1725-4-git-send-email-penberg@kernel.org>
Message-ID: <alpine.DEB.2.00.1110311551290.22237@chino.kir.corp.google.com>
References: <1319811801-1725-1-git-send-email-penberg@kernel.org> <1319811801-1725-4-git-send-email-penberg@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Oct 2011, Pekka Enberg wrote:

> In preparation for unifying 32-bit and 64-bit zone_sizes_init() make sure
> ZONE_DMA32 is wrapped in CONFIG_ZONE_DMA32.
> 
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: H. Peter Anvin <hpa@linux.intel.com>
> Cc: David Rientjes <rientjes@google.com>
> Signed-off-by: Pekka Enberg <penberg@kernel.org>

Acked-by: David Rientjes <rientjes@google.com>

Adding Arun Sharma to the cc, he was interested in disabling 
CONFIG_ZONE_DMA32 and I believe carries this patch internally (as we do).

> ---
>  arch/x86/mm/init_64.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index 3ddda59..a9214e6 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -620,7 +620,9 @@ static void __init zone_sizes_init(void)
>  #ifdef CONFIG_ZONE_DMA
>  	max_zone_pfns[ZONE_DMA] = MAX_DMA_PFN;
>  #endif
> +#ifdef CONFIG_ZONE_DMA32
>  	max_zone_pfns[ZONE_DMA32] = MAX_DMA32_PFN;
> +#endif
>  	max_zone_pfns[ZONE_NORMAL] = max_pfn;
>  
>  	free_area_init_nodes(max_zone_pfns);
