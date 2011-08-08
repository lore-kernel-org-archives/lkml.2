Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028Ab1HHJec (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 05:34:32 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:45073 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab1HHJe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 05:34:29 -0400
Date: Mon, 8 Aug 2011 11:34:23 +0200
From: Tejun Heo <tj@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] memblock: add memblock_start_of_DRAM()
Message-ID: <20110808093423.GF23937@htj.dyndns.org>
References: <20110806185923.GA8494@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110806185923.GA8494@merkur.ravnborg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing hpa and quoting whole body)

On Sat, Aug 06, 2011 at 08:59:23PM +0200, Sam Ravnborg wrote:
> SPARC32 require access to the start address.
> Add a new helper memblock_start_of_DRAM() to give
> access to the address of the first memblock - which
> contains the lowest address.
> 
> The ackward name was chosen to match the already present
> memblock_end_of_DRAM().
> 
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Yinghai Lu <yinghai@kernel.org>
> ---
> Hi Tejun.
> 
> I have started to replace bootmem with memblock for sparc32.
> This is so far the only general functionality missing.
> 
> But conversion is not finished yet - more may come.
> 
> This is on top of the memblock branch of your misc tree

Yes, this looks good to me.

 Acked-by: Tejun Heo <tj@kernel.org>

hpa, how do you want to proceed with the patchset?

Thanks.

> diff --git a/include/linux/memblock.h b/include/linux/memblock.h
> index 7c59804..a6bb102 100644
> --- a/include/linux/memblock.h
> +++ b/include/linux/memblock.h
> @@ -157,6 +157,7 @@ phys_addr_t memblock_alloc_base(phys_addr_t size, phys_addr_t align,
>  phys_addr_t __memblock_alloc_base(phys_addr_t size, phys_addr_t align,
>  				  phys_addr_t max_addr);
>  phys_addr_t memblock_phys_mem_size(void);
> +phys_addr_t memblock_start_of_DRAM(void);
>  phys_addr_t memblock_end_of_DRAM(void);
>  void memblock_enforce_memory_limit(phys_addr_t memory_limit);
>  int memblock_is_memory(phys_addr_t addr);
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 07cb3ae..2f55f19 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -782,6 +782,12 @@ phys_addr_t __init memblock_phys_mem_size(void)
>  	return memblock.memory.total_size;
>  }
>  
> +/* lowest address */
> +phys_addr_t __init_memblock memblock_start_of_DRAM(void)
> +{
> +	return memblock.memory.regions[0].base;
> +}
> +
>  phys_addr_t __init_memblock memblock_end_of_DRAM(void)
>  {
>  	int idx = memblock.memory.cnt - 1;

-- 
tejun
