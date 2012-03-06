Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030766Ab2CFOfS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 09:35:18 -0500
Received: from mxout1.idt.com ([157.165.5.25]:59976 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030694Ab2CFOfQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 09:35:16 -0500
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: Liu Gang <Gang.Liu@freescale.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "r58472@freescale.com" <r58472@freescale.com>,
        "r61911@freescale.com" <r61911@freescale.com>,
        "scottwood@freescale.com" <scottwood@freescale.com>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>
Subject: RE: [PATCH] powerpc/srio: Fix the relocation errors when building
 with 64bit
Thread-Topic: [PATCH] powerpc/srio: Fix the relocation errors when building
 with 64bit
Thread-Index: AQHM+0VHSbRUBmFt10KARB+sULqn3pZdVYog
Date: Tue, 6 Mar 2012 14:35:02 +0000
Message-ID: <8D983423E7EDF846BB3056827B8CC5D10102FC@corpmail1.na.ads.idt.com>
References: <1331002692-9061-1-git-send-email-Gang.Liu@freescale.com>
In-Reply-To: <1331002692-9061-1-git-send-email-Gang.Liu@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.165.140.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, March 05, 2012 9:58 PM, Liu Gang wrote:
> Subject: [PATCH] powerpc/srio: Fix the relocation errors when building
> with 64bit
> 
> For the file "arch/powerpc/sysdev/fsl_rio.c", there will be some
> relocation errors while using the corenet64_smp_defconfig:
> 
> WARNING: modpost: Found 6 section mismatch(es).
> To see full details build your kernel with:
> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
>   GEN     .version
>   CHK     include/generated/compile.h
>   UPD     include/generated/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> arch/powerpc/sysdev/built-in.o:(__ex_table+0x0):
> 	relocation truncated to fit: R_PPC64_ADDR16 against `.text'+3208
> arch/powerpc/sysdev/built-in.o:(__ex_table+0x2):
> 	relocation truncated to fit: R_PPC64_ADDR16 against `.fixup'
> arch/powerpc/sysdev/built-in.o:(__ex_table+0x4):
> 	relocation truncated to fit: R_PPC64_ADDR16 against `.text'+3230
> arch/powerpc/sysdev/built-in.o:(__ex_table+0x6):
> 	relocation truncated to fit: R_PPC64_ADDR16 against `.fixup'+c
> arch/powerpc/sysdev/built-in.o:(__ex_table+0x8):
> 	relocation truncated to fit: R_PPC64_ADDR16 against `.text'+3250
> arch/powerpc/sysdev/built-in.o:(__ex_table+0xa):
> 	relocation truncated to fit: R_PPC64_ADDR16 against `.fixup'+18
> 
> Rewrote the corresponding code with the support of 64bit building.
> 
> Signed-off-by: Liu Gang <Gang.Liu@freescale.com>
> ---
>  arch/powerpc/sysdev/fsl_rio.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/sysdev/fsl_rio.c
> b/arch/powerpc/sysdev/fsl_rio.c index a4c4f4a..5b6f556 100644
> --- a/arch/powerpc/sysdev/fsl_rio.c
> +++ b/arch/powerpc/sysdev/fsl_rio.c
> @@ -66,8 +66,8 @@
>  		"	li %0,%3\n"			\
>  		"	b 2b\n"				\
>  		".section __ex_table,\"a\"\n"		\
> -		"	.align 2\n"			\
> -		"	.long 1b,3b\n"			\
> +			PPC_LONG_ALIGN "\n"		\
> +			PPC_LONG "1b,3b\n"		\
>  		".text"					\
>  		: "=r" (err), "=r" (x)			\
>  		: "b" (addr), "i" (-EFAULT), "0" (err))
> --
> 1.7.0.4
> 

Looks good to me. Ack-ed.

