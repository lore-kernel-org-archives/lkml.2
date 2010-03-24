Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab0CXK4Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 06:56:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41471 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754280Ab0CXK4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 06:56:24 -0400
Date: Wed, 24 Mar 2010 11:56:20 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
       Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: remove early_res debug output (was Re: Confusing
 bootmem messages on bootup)
In-Reply-To: <alpine.LNX.2.00.1003220931360.18642@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1003241155510.4242@pobox.suse.cz>
References: <alpine.LNX.2.00.1003191526560.18642@pobox.suse.cz> <alpine.LNX.2.00.1003191544010.18642@pobox.suse.cz> <20100322082832.GB19077@elte.hu> <alpine.LNX.2.00.1003220931360.18642@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Mar 2010, Jiri Kosina wrote:

> On Mon, 22 Mar 2010, Ingo Molnar wrote:
> 
> > Please also remove the other KERN_DEBUG leftovers - the #if 0 variants.
> 
> From: Jiri Kosina <jkosina@suse.cz>
> Subject: [PATCH] x86: remove early_res debug output
> 
> Commit 08677214e318297 ("x86: Make 64 bit use early_res instead of bootmem 
> before slab") introduced early_res replacement for bootmem, but left code 
> in __free_pages_memory() which dumps all the ranges that are beeing freed, 
> without any additional information, causing some noise in dmesg during 
> bootup.
> 
> Just remove printing of the ranges, that doesn't provide anything useful 
> anyway.
> 
> While at it, remove other commented-out KERN_DEBUG messages in the 
> NO_BOOTMEM code as well.
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> 
> --- 
>  mm/bootmem.c |   13 -------------
>  1 files changed, 0 insertions(+), 13 deletions(-)
> 
> diff --git a/mm/bootmem.c b/mm/bootmem.c
> index d7c791e..9b13446 100644
> --- a/mm/bootmem.c
> +++ b/mm/bootmem.c
> @@ -180,19 +180,12 @@ static void __init __free_pages_memory(unsigned long start, unsigned long end)
>  	end_aligned = end & ~(BITS_PER_LONG - 1);
>  
>  	if (end_aligned <= start_aligned) {
> -#if 1
> -		printk(KERN_DEBUG " %lx - %lx\n", start, end);
> -#endif
>  		for (i = start; i < end; i++)
>  			__free_pages_bootmem(pfn_to_page(i), 0);
>  
>  		return;
>  	}
>  
> -#if 1
> -	printk(KERN_DEBUG " %lx %lx - %lx %lx\n",
> -		 start, start_aligned, end_aligned, end);
> -#endif
>  	for (i = start; i < start_aligned; i++)
>  		__free_pages_bootmem(pfn_to_page(i), 0);
>  
> @@ -428,9 +421,6 @@ void __init free_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
>  {
>  #ifdef CONFIG_NO_BOOTMEM
>  	free_early(physaddr, physaddr + size);
> -#if 0
> -	printk(KERN_DEBUG "free %lx %lx\n", physaddr, size);
> -#endif
>  #else
>  	unsigned long start, end;
>  
> @@ -456,9 +446,6 @@ void __init free_bootmem(unsigned long addr, unsigned long size)
>  {
>  #ifdef CONFIG_NO_BOOTMEM
>  	free_early(addr, addr + size);
> -#if 0
> -	printk(KERN_DEBUG "free %lx %lx\n", addr, size);
> -#endif
>  #else
>  	unsigned long start, end;
>  

Ingo,

are you going to pick this one up for -rc3 please?

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
