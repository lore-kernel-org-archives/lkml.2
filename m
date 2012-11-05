Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196Ab2KEK6Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 05:58:24 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:41476 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092Ab2KEK6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 05:58:22 -0500
Date: Mon, 5 Nov 2012 10:58:17 +0000
From: Dave Martin <dave.martin@linaro.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "Tim (Xen.org)" <tim@xen.org>, Ian Campbell <Ian.Campbell@citrix.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "arnd@arndb.de" <arnd@arndb.de>
Subject: Re: [PATCH RESEND] xen/arm: use the __HVC macro
Message-ID: <20121105105817.GC2005@linaro.org>
References: <alpine.DEB.2.02.1208161618550.4850@kaball.uk.xensource.com>
 <alpine.DEB.2.02.1210241624400.2689@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1210241624400.2689@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 04:26:08PM +0100, Stefano Stabellini wrote:
> Use the new __HVC macro in hypercall.S.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

This is correct usage of the __HVC() macro, so

Acked-by: Dave Martin <dave.martin@linaro.org>

> ---
>  arch/arm/xen/hypercall.S |   14 +++++---------
>  1 files changed, 5 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm/xen/hypercall.S b/arch/arm/xen/hypercall.S
> index 074f5ed..71f7239 100644
> --- a/arch/arm/xen/hypercall.S
> +++ b/arch/arm/xen/hypercall.S
> @@ -48,20 +48,16 @@
>  
>  #include <linux/linkage.h>
>  #include <asm/assembler.h>
> +#include <asm/opcodes-virt.h>
>  #include <xen/interface/xen.h>
>  
>  
> -/* HVC 0xEA1 */
> -#ifdef CONFIG_THUMB2_KERNEL
> -#define xen_hvc .word 0xf7e08ea1
> -#else
> -#define xen_hvc .word 0xe140ea71
> -#endif
> +#define XEN_IMM 0xEA1
>  
>  #define HYPERCALL_SIMPLE(hypercall)		\
>  ENTRY(HYPERVISOR_##hypercall)			\
>  	mov r12, #__HYPERVISOR_##hypercall;	\
> -	xen_hvc;							\
> +	__HVC(XEN_IMM);						\
>  	mov pc, lr;							\
>  ENDPROC(HYPERVISOR_##hypercall)
>  
> @@ -76,7 +72,7 @@ ENTRY(HYPERVISOR_##hypercall)			\
>  	stmdb sp!, {r4}						\
>  	ldr r4, [sp, #4]					\
>  	mov r12, #__HYPERVISOR_##hypercall;	\
> -	xen_hvc								\
> +	__HVC(XEN_IMM);						\
>  	ldm sp!, {r4}						\
>  	mov pc, lr							\
>  ENDPROC(HYPERVISOR_##hypercall)
> @@ -100,7 +96,7 @@ ENTRY(privcmd_call)
>  	mov r2, r3
>  	ldr r3, [sp, #8]
>  	ldr r4, [sp, #4]
> -	xen_hvc
> +	__HVC(XEN_IMM)
>  	ldm sp!, {r4}
>  	mov pc, lr
>  ENDPROC(privcmd_call);
> -- 
> 1.7.2.5
