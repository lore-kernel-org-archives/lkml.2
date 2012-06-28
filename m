Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226Ab2F1UIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 16:08:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34225 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769Ab2F1UIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 16:08:15 -0400
Message-ID: <4FECB95D.7010200@zytor.com>
Date: Thu, 28 Jun 2012 13:06:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Alessandro Rubini <rubini@gnudd.com>
CC: linux-kernel@vger.kernel.org, Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>, Russell King <linux@arm.linux.org.uk>,
        x86@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH V2 5/6] x86: add CONFIG_ARM_AMBA, selected by STA2X11
References: <cover.1338222460.git.rubini@gnudd.com> <f85fefb10b7a7407b77180be65b18bf0426145b9.1338222461.git.rubini@gnudd.com>
In-Reply-To: <f85fefb10b7a7407b77180be65b18bf0426145b9.1338222461.git.rubini@gnudd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2012 09:37 AM, Alessandro Rubini wrote:
> The sta2x11 I/O Hub is a bridge from PCIe to AMBA. It reuses a number
> of amba drivers and needs to activate core bus support.
>
> Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
> Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
> ---
>   arch/x86/Kconfig |    4 ++++
>   1 files changed, 4 insertions(+), 0 deletions(-)

> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 91dea918..112718f 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -500,6 +500,7 @@ config STA2X11
>  	select SWIOTLB
>  	select MFD_STA2X11
>  	select ARCH_REQUIRE_GPIOLIB
> +	select ARM_AMBA
>  	default n
>  	---help---
>  	  This adds support for boards based on the STA2X11 IO-Hub,
> @@ -2173,6 +2174,9 @@ config GEOS
>
>  endif # X86_32
>
> +config ARM_AMBA
> +        bool
> +
>  config AMD_NB
>  	def_bool y
>  	depends on CPU_SUP_AMD && PCI


Nacked-by: H. Peter Anvin <hpa@zytor.com>

This brings in tons of code into the x86 all{yes,mod}config builds, and 
as perhaps one could expect some of it doesn't compile.  For example:


/home/hpa/kernel/tip.x86-platform/drivers/dma/pl330.c: In function 
‘dmac_alloc_resources’:
/home/hpa/kernel/tip.x86-platform/drivers/dma/pl330.c:2056:2: warning: 
passing argument 3 of ‘dma_alloc_attrs’ from incompatible
  pointer type [enabled by default]
In file included from 
/home/hpa/kernel/tip.x86-platform/include/linux/dma-mapping.h:73:0,
                  from 
/home/hpa/kernel/tip.x86-platform/drivers/dma/pl330.c:22:
/home/hpa/kernel/tip.x86-platform/arch/x86/include/asm/dma-mapping.h:130:1: 
note: expected ‘dma_addr_t *’ but argument is of typ
e ‘u32 *’
   CC      sound/pci/au88x0/au8830.o
/home/hpa/kernel/tip.x86-platform/drivers/dma/pl330.c:73:0: warning: 
"DS" redefined [enabled by default]
In file included from 
/home/hpa/kernel/tip.x86-platform/arch/x86/include/asm/ptrace.h:5:0,
                  from 
/home/hpa/kernel/tip.x86-platform/arch/x86/include/asm/vm86.h:130,
                  from 
/home/hpa/kernel/tip.x86-platform/arch/x86/include/asm/processor.h:10,
                  from 
/home/hpa/kernel/tip.x86-platform/arch/x86/include/asm/thread_info.h:22,
                  from 
/home/hpa/kernel/tip.x86-platform/include/linux/thread_info.h:54,
                  from 
/home/hpa/kernel/tip.x86-platform/include/linux/preempt.h:9,
                  from 
/home/hpa/kernel/tip.x86-platform/include/linux/spinlock.h:50,
                  from 
/home/hpa/kernel/tip.x86-platform/include/linux/vmalloc.h:4,
                  from 
/home/hpa/kernel/tip.x86-platform/arch/x86/include/asm/io.h:195,
                  from 
/home/hpa/kernel/tip.x86-platform/include/linux/io.h:22,
                  from 
/home/hpa/kernel/tip.x86-platform/drivers/dma/pl330.c:15:
/home/hpa/kernel/tip.x86-platform/arch/x86/include/asm/ptrace-abi.h:13:0: note: 
this is the location of the previous definition
/home/hpa/kernel/tip.x86-platform/drivers/dma/pl330.c:89:0: warning: 
"ES" redefined [enabled by default]
In file included from 
/home/hpa/kernel/tip.x86-platform/arch/x86/include/asm/ptrace.h:5:0,
                  from 
/home/hpa/kernel/tip.x86-platform/arch/x86/include/asm/vm86.h:130,
                  from 
/home/hpa/kernel/tip.x86-platform/arch/x86/include/asm/processor.h:10,
                  from 
/home/hpa/kernel/tip.x86-platform/arch/x86/include/asm/thread_info.h:22,
                  from 
/home/hpa/kernel/tip.x86-platform/include/linux/thread_info.h:54,
                  from 
/home/hpa/kernel/tip.x86-platform/include/linux/preempt.h:9,
                  from 
/home/hpa/kernel/tip.x86-platform/include/linux/spinlock.h:50,
                  from 
/home/hpa/kernel/tip.x86-platform/include/linux/vmalloc.h:4,
                  from 
/home/hpa/kernel/tip.x86-platform/arch/x86/include/asm/io.h:195,
                  from 
/home/hpa/kernel/tip.x86-platform/include/linux/io.h:22,
                  from 
/home/hpa/kernel/tip.x86-platform/drivers/dma/pl330.c:15:
/home/hpa/kernel/tip.x86-platform/arch/x86/include/asm/ptrace-abi.h:14:0: note: 
this is the location of the previous definition
/home/hpa/kernel/tip.x86-platform/drivers/dma/pl330.c:100:0: warning: 
"CS" redefined [enabled by default]
In file included from 
/home/hpa/kernel/tip.x86-platform/arch/x86/include/asm/ptrace.h:5:0,
                  from 
/home/hpa/kernel/tip.x86-platform/arch/x86/include/asm/vm86.h:130,
                  from 
/home/hpa/kernel/tip.x86-platform/arch/x86/include/asm/processor.h:10,
                  from 
/home/hpa/kernel/tip.x86-platform/arch/x86/include/asm/thread_info.h:22,
                  from 
/home/hpa/kernel/tip.x86-platform/include/linux/thread_info.h:54,
                  from 
/home/hpa/kernel/tip.x86-platform/include/linux/preempt.h:9,
                  from 
/home/hpa/kernel/tip.x86-platform/include/linux/spinlock.h:50,
                  from 
/home/hpa/kernel/tip.x86-platform/include/linux/vmalloc.h:4,
                  from 
/home/hpa/kernel/tip.x86-platform/arch/x86/include/asm/io.h:195,
                  from 
/home/hpa/kernel/tip.x86-platform/include/linux/io.h:22,
                  from 
/home/hpa/kernel/tip.x86-platform/drivers/dma/pl330.c:15:
/home/hpa/kernel/tip.x86-platform/arch/x86/include/asm/ptrace-abi.h:19:0: note: 
this is the location of the previous definition
   CC      drivers/dma/pch_dma.o
   CC      drivers/dma/amba-pl08x.o
/home/hpa/kernel/tip.x86-platform/drivers/dma/amba-pl08x.c:86:32: fatal 
error: asm/hardware/pl080.h: No such file or directory
compilation terminated.
make[4]: *** [drivers/dma/amba-pl08x.o] Error 1
make[3]: *** [drivers/dma] Error 2
make[2]: *** [drivers] Error 2
make[2]: *** Waiting for unfinished jobs....



-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.



