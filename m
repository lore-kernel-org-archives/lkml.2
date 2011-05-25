Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145Ab1EYXhz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 19:37:55 -0400
Received: from smtp-out.google.com ([216.239.44.51]:54391 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754321Ab1EYXhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 19:37:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=TWWZ/TmS3wFG9fN480tEqTBDqKR8kX5bBXT6pKvbJAdGbVsPwCG6QEn1JqayhhauuS
         OY8FDF2BTKgWHwVua5Jg==
Date: Wed, 25 May 2011 16:37:50 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Heiko Carstens <heiko.carstens@de.ibm.com>
cc: Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 6/6] slab: only define SLAB_CACHE_DMA for
 CONFIG_ZONE_DMA
In-Reply-To: <20110525104952.GD2498@osiris.boeblingen.de.ibm.com>
Message-ID: <alpine.DEB.2.00.1105251635550.29729@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1105241650230.29780@chino.kir.corp.google.com> <alpine.DEB.2.00.1105241653180.29780@chino.kir.corp.google.com> <20110525104952.GD2498@osiris.boeblingen.de.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 May 2011, Heiko Carstens wrote:

> Ok, now I see what you want. But please let's don't add an
> #ifdef CONFIG_ZONE_DMA
> to the dasd driver. Instead just re-add ZONE_DMA to 31-bit s390. Everything
> would be in ZONE_DMA again and ZONE_NORMAL would be empty. Doesn't matter
> if we have an additional zone, since 31-bit support isn't important anymore.
> 

Ok, that's fine.  Many other architectures do not allow this to be 
disabled, so we can add s390 to the list.

> So I could add the following patch to the s390 tree, if wanted:
> 

Sure!  Please remove the CONFIG_ZONE_DMA from 
arch/s390/appldata/appldata_mem.c as well and then add my:

	Acked-by: David Rientjes <rientjes@google.com>

once you sign-it-off.

> ---
>  arch/s390/Kconfig   |    2 +-
>  arch/s390/mm/init.c |    2 --
>  2 files changed, 1 insertion(+), 3 deletions(-)
> 
> --- a/arch/s390/Kconfig
> +++ b/arch/s390/Kconfig
> @@ -2,7 +2,7 @@ config MMU
>  	def_bool y
>  
>  config ZONE_DMA
> -	def_bool y if 64BIT
> +	def_bool y
>  
>  config LOCKDEP_SUPPORT
>  	def_bool y
> --- a/arch/s390/mm/init.c
> +++ b/arch/s390/mm/init.c
> @@ -119,9 +119,7 @@ void __init paging_init(void)
>  	sparse_memory_present_with_active_regions(MAX_NUMNODES);
>  	sparse_init();
>  	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
> -#ifdef CONFIG_ZONE_DMA
>  	max_zone_pfns[ZONE_DMA] = PFN_DOWN(MAX_DMA_ADDRESS);
> -#endif
>  	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
>  	free_area_init_nodes(max_zone_pfns);
>  	fault_init();
> 
