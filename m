Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab1I0Gww (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 02:52:52 -0400
Received: from queue02.mail.zen.net.uk ([212.23.3.27]:53893 "EHLO
	queue02.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab1I0Gwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 02:52:50 -0400
X-Greylist: delayed 1908 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Sep 2011 02:52:49 EDT
Subject: Re: linux-next: manual merge of the arm-soc tree with the arm tree
From: Tixy <tixy@yxit.co.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <rmk@arm.linux.org.uk>
In-Reply-To: <20110927112524.fd0b8f1fe69bc63855ead2d7@canb.auug.org.au>
References: <20110927112524.fd0b8f1fe69bc63855ead2d7@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Sep 2011 07:20:57 +0100
Message-ID: <1317104457.2238.16.camel@computer2>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Originating-Smarthost03-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-27 at 11:25 +1000, Stephen Rothwell wrote:
> Hi Arnd,
> 
> [I have a feeling that I may have reported this previously]
> 
> Today's linux-next merge of the arm-soc tree got a conflict in
> arch/arm/mm/dma-mapping.c between commit e73fc88e19d7 ("ARM: 7059/1:
> LPAE: Use PMD_(SHIFT|SIZE|MASK) instead of PGDIR_*") from the arm tree
> and commit 99d1717dd7fe ("ARM: Add init_consistent_dma_size()") from
> the
> arm-soc tree.
> 
> I fixed it up (I think - see below) and can carry the fix as
> necessary.

The fixup looks correct to me.

-- 
Jon Medhurst (usually known as Tixy)

> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc arch/arm/mm/dma-mapping.c
> index 235eb77,50be842..0000000
> --- a/arch/arm/mm/dma-mapping.c
> +++ b/arch/arm/mm/dma-mapping.c
> @@@ -117,14 -119,10 +119,9 @@@ static void __dma_free_buffer(struct pa
>   }
>   
>   #ifdef CONFIG_MMU
> - /* Sanity check size */
> - #if (CONSISTENT_DMA_SIZE % SZ_2M)
> - #error "CONSISTENT_DMA_SIZE must be multiple of 2MiB"
> - #endif
>   
> - #define CONSISTENT_OFFSET(x)  (((unsigned long)(x) - CONSISTENT_BASE) >> PAGE_SHIFT)
> - #define CONSISTENT_PTE_INDEX(x) (((unsigned long)(x) - CONSISTENT_BASE) >> PMD_SHIFT)
> - #define NUM_CONSISTENT_PTES (CONSISTENT_DMA_SIZE >> PMD_SHIFT)
>  -
> + #define CONSISTENT_OFFSET(x)  (((unsigned long)(x) - consistent_base) >> PAGE_SHIFT)
>  -#define CONSISTENT_PTE_INDEX(x) (((unsigned long)(x) - consistent_base) >> PGDIR_SHIFT)
> ++#define CONSISTENT_PTE_INDEX(x) (((unsigned long)(x) - consistent_base) >> PMD_SHIFT)
>   
>   /*
>    * These are the page tables (2MB each) covering uncached, DMA consistent allocations 

