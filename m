Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515Ab0FJGSJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 02:18:09 -0400
Received: from gate.crashing.org ([63.228.1.57]:38516 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733Ab0FJGSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 02:18:07 -0400
Subject: Re: [PATCH 1/5] Removing dead BOOK3E_MMU_TLB_STATS
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Christoph Egger <siccegge@cs.fau.de>
Cc: Paul Mackerras <paulus@samba.org>, Kumar Gala <galak@kernel.crashing.org>,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       Huang Weiyi <weiyi.huang@gmail.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, vamos@i4.informatik.uni-erlangen.de
In-Reply-To: <20aa4815e07e1be0b073bcf4f63331a68b8f74be.1275925219.git.siccegge@cs.fau.de>
References: <cover.1275925219.git.siccegge@cs.fau.de>
	 <20aa4815e07e1be0b073bcf4f63331a68b8f74be.1275925219.git.siccegge@cs.fau.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Jun 2010 15:20:19 +1000
Message-ID: <1276147219.1962.41.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-09 at 11:59 +0200, Christoph Egger wrote:
> BOOK3E_MMU_TLB_STATS doesn't exist in Kconfig, therefore removing all
> references for it from the source code.

Heh, thanks but no :-)

I want to keep that code here, until we hook it up again. It was hooked
up properly in some internal stuff that didn't go upstream for some
reason and I need to fix that.

Cheers,
Ben.

> Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
> ---
>  arch/powerpc/include/asm/exception-64e.h |   38 ------------------------------
>  arch/powerpc/mm/tlb_low_64e.S            |    9 -------
>  2 files changed, 0 insertions(+), 47 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/exception-64e.h b/arch/powerpc/include/asm/exception-64e.h
> index 6d53f31..db74814 100644
> --- a/arch/powerpc/include/asm/exception-64e.h
> +++ b/arch/powerpc/include/asm/exception-64e.h
> @@ -65,14 +65,7 @@
>  #define EX_TLB_MMUCR0	(12 * 8) /* Level 0 */
>  #define EX_TLB_MAS1	(12 * 8) /* Level 0 */
>  #define EX_TLB_MAS2	(13 * 8) /* Level 0 */
> -#ifdef CONFIG_BOOK3E_MMU_TLB_STATS
> -#define EX_TLB_R8	(14 * 8)
> -#define EX_TLB_R9	(15 * 8)
> -#define EX_TLB_LR	(16 * 8)
> -#define EX_TLB_SIZE	(17 * 8)
> -#else
>  #define EX_TLB_SIZE	(14 * 8)
> -#endif
>  
>  #define	START_EXCEPTION(label)						\
>  	.globl exc_##label##_book3e;					\
> @@ -157,36 +150,6 @@ exc_##label##_book3e:
>  	addi	r11,r13,PACA_EXTLB;					    \
>  	TLB_MISS_RESTORE(r11)
>  
> -#ifdef CONFIG_BOOK3E_MMU_TLB_STATS
> -#define TLB_MISS_PROLOG_STATS						    \
> -	mflr	r10;							    \
> -	std	r8,EX_TLB_R8(r12);					    \
> -	std	r9,EX_TLB_R9(r12);					    \
> -	std	r10,EX_TLB_LR(r12);
> -#define TLB_MISS_RESTORE_STATS					            \
> -	ld	r16,EX_TLB_LR(r12);					    \
> -	ld	r9,EX_TLB_R9(r12);					    \
> -	ld	r8,EX_TLB_R8(r12);					    \
> -	mtlr	r16;
> -#define TLB_MISS_STATS_D(name)						    \
> -	addi	r9,r13,MMSTAT_DSTATS+name;				    \
> -	bl	.tlb_stat_inc;
> -#define TLB_MISS_STATS_I(name)						    \
> -	addi	r9,r13,MMSTAT_ISTATS+name;				    \
> -	bl	.tlb_stat_inc;
> -#define TLB_MISS_STATS_X(name)						    \
> -	ld	r8,PACA_EXTLB+EX_TLB_ESR(r13);				    \
> -	cmpdi	cr2,r8,-1;						    \
> -	beq	cr2,61f;						    \
> -	addi	r9,r13,MMSTAT_DSTATS+name;				    \
> -	b	62f;							    \
> -61:	addi	r9,r13,MMSTAT_ISTATS+name;				    \
> -62:	bl	.tlb_stat_inc;
> -#define TLB_MISS_STATS_SAVE_INFO					    \
> -	std	r14,EX_TLB_ESR(r12);	/* save ESR */			    \
> -
> -
> -#else
>  #define TLB_MISS_PROLOG_STATS
>  #define TLB_MISS_RESTORE_STATS
>  #define TLB_MISS_STATS_D(name)
> @@ -194,7 +157,6 @@ exc_##label##_book3e:
>  #define TLB_MISS_STATS_X(name)
>  #define TLB_MISS_STATS_Y(name)
>  #define TLB_MISS_STATS_SAVE_INFO
> -#endif
>  
>  #define SET_IVOR(vector_number, vector_offset)	\
>  	li	r3,vector_offset@l; 		\
> diff --git a/arch/powerpc/mm/tlb_low_64e.S b/arch/powerpc/mm/tlb_low_64e.S
> index 8b04c54..4d7d059 100644
> --- a/arch/powerpc/mm/tlb_low_64e.S
> +++ b/arch/powerpc/mm/tlb_low_64e.S
> @@ -758,12 +758,3 @@ tlb_load_linear_fault:
>  1:	TLB_MISS_EPILOG_ERROR_SPECIAL
>  	b	exc_instruction_storage_book3e
>  
> -
> -#ifdef CONFIG_BOOK3E_MMU_TLB_STATS
> -.tlb_stat_inc:
> -1:	ldarx	r8,0,r9
> -	addi	r8,r8,1
> -	stdcx.	r8,0,r9
> -	bne-	1b
> -	blr
> -#endif


