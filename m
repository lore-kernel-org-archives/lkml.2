Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221Ab0CQGEY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 02:04:24 -0400
Received: from smtp138.mail.ukl.yahoo.com ([77.238.184.69]:34715 "HELO
	smtp138.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753132Ab0CQGEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 02:04:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.es;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=U1bSyIstOy+FFyEZcNxxjpNhnzFT2XE+B+nCOSinuIZNnU6q6ZdkthNC/s0o++SzyKXWjkY01q70UfsAe/EMHLkihEYlGAxkeZTPg4+SoF/o3z+u+MbIVovI5usG5TvvRtxloOVnr3C5xHCZzCxumW7jyJaJXJfzLpQ/gJPqW/4=  ;
X-Yahoo-SMTP: czee06uswBAtfIYshc.kP27UlfEXaxwWNSjJ
X-YMail-OSG: OyLwFdEVM1mHq7I2HbQLINuSc8wv.qG0Wd1L5H7hNVL5Lo1XhgiRPggFw4TLQ3ZuEf4wVgllR2uoFEpmZvk0mQJKFmMjePVZ.sHXoQcRvGy_OXQSfusYiOimTHISLC_W3QD93Oe92m4FRlkbln72qA.MRad.pnyvzgASmKhcBEAaiDq7h.JeBGdWfjYG0VK8XFZ_0PiLBdB69n3h_W3fXVeYqLy3PHVOzk9y3b4MWJLPsSpeTWs0JkklqSFqABRD8uJdyyE7v_l3qC3MBNWMP_P6SSr3qq.LgHz6
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4BA070BF.9000409@yahoo.es>
Date: Wed, 17 Mar 2010 07:03:43 +0100
From: Albert Herranz <albert_herranz@yahoo.es>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: linuxppc-dev@ozlabs.org, benh@kernel.crashing.org,
       beckyb@kernel.crashing.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc: fix swiotlb to respect the boot option
References: <20100317081540C.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100317081540C.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> powerpc initializes swiotlb before parsing the kernel boot options so
> swiotlb options (e.g. specifying the swiotlb buffer size) are ignored.
> 
> Any time before freeing bootmem works for swiotlb so this patch moves
> powerpc's swiotlb initialization after parsing the kernel boot
> options, mem_init (as x86 does).
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Tested-by: Becky Bruce <beckyb@kernel.crashing.org>

Thanks!

Tested-by: Albert Herranz <albert_herranz@yahoo.es>

> ---
>  arch/powerpc/kernel/setup_32.c |    6 ------
>  arch/powerpc/kernel/setup_64.c |    6 ------
>  arch/powerpc/mm/mem.c          |    6 ++++++
>  3 files changed, 6 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/setup_32.c b/arch/powerpc/kernel/setup_32.c
> index b152de3..8f58986 100644
> --- a/arch/powerpc/kernel/setup_32.c
> +++ b/arch/powerpc/kernel/setup_32.c
> @@ -39,7 +39,6 @@
>  #include <asm/serial.h>
>  #include <asm/udbg.h>
>  #include <asm/mmu_context.h>
> -#include <asm/swiotlb.h>
>  
>  #include "setup.h"
>  
> @@ -343,11 +342,6 @@ void __init setup_arch(char **cmdline_p)
>  		ppc_md.setup_arch();
>  	if ( ppc_md.progress ) ppc_md.progress("arch: exit", 0x3eab);
>  
> -#ifdef CONFIG_SWIOTLB
> -	if (ppc_swiotlb_enable)
> -		swiotlb_init(1);
> -#endif
> -
>  	paging_init();
>  
>  	/* Initialize the MMU context management stuff */
> diff --git a/arch/powerpc/kernel/setup_64.c b/arch/powerpc/kernel/setup_64.c
> index 6354739..9143891 100644
> --- a/arch/powerpc/kernel/setup_64.c
> +++ b/arch/powerpc/kernel/setup_64.c
> @@ -61,7 +61,6 @@
>  #include <asm/xmon.h>
>  #include <asm/udbg.h>
>  #include <asm/kexec.h>
> -#include <asm/swiotlb.h>
>  #include <asm/mmu_context.h>
>  
>  #include "setup.h"
> @@ -541,11 +540,6 @@ void __init setup_arch(char **cmdline_p)
>  	if (ppc_md.setup_arch)
>  		ppc_md.setup_arch();
>  
> -#ifdef CONFIG_SWIOTLB
> -	if (ppc_swiotlb_enable)
> -		swiotlb_init(1);
> -#endif
> -
>  	paging_init();
>  
>  	/* Initialize the MMU context management stuff */
> diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
> index 311224c..448f972 100644
> --- a/arch/powerpc/mm/mem.c
> +++ b/arch/powerpc/mm/mem.c
> @@ -48,6 +48,7 @@
>  #include <asm/sparsemem.h>
>  #include <asm/vdso.h>
>  #include <asm/fixmap.h>
> +#include <asm/swiotlb.h>
>  
>  #include "mmu_decl.h"
>  
> @@ -320,6 +321,11 @@ void __init mem_init(void)
>  	struct page *page;
>  	unsigned long reservedpages = 0, codesize, initsize, datasize, bsssize;
>  
> +#ifdef CONFIG_SWIOTLB
> +	if (ppc_swiotlb_enable)
> +		swiotlb_init(1);
> +#endif
> +
>  	num_physpages = lmb.memory.size >> PAGE_SHIFT;
>  	high_memory = (void *) __va(max_low_pfn * PAGE_SIZE);
>  

