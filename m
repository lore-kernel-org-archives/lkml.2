Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934485Ab1ETAjP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 20:39:15 -0400
Received: from gate.crashing.org ([63.228.1.57]:60783 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933220Ab1ETAjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 20:39:14 -0400
Subject: Re: [PATCH 6/7] [RFC] enable early TLBs for BG/P
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        bg-linux@lists.anl-external.org
In-Reply-To: <1305753895-24845-6-git-send-email-ericvh@gmail.com>
References: <1305753895-24845-1-git-send-email-ericvh@gmail.com>
	 <1305753895-24845-6-git-send-email-ericvh@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 May 2011 10:39:01 +1000
Message-ID: <1305851941.7481.92.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-18 at 16:24 -0500, Eric Van Hensbergen wrote:
> BG/P maps firmware with an early TLB

That's a bit gross. How often do you call that firmware in practice ?
Aren't you better off instead inserting a TLB entry for it when you call
it instead ? A simple tlbsx. + tlbwe sequence would do. That would free
up a TLB entry for normal use.

Cheers,
Ben.

> Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>
> ---
>  arch/powerpc/include/asm/mmu-44x.h |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/mmu-44x.h b/arch/powerpc/include/asm/mmu-44x.h
> index ca1b90c..2807d6e 100644
> --- a/arch/powerpc/include/asm/mmu-44x.h
> +++ b/arch/powerpc/include/asm/mmu-44x.h
> @@ -115,8 +115,12 @@ typedef struct {
>  #endif /* !__ASSEMBLY__ */
>  
>  #ifndef CONFIG_PPC_EARLY_DEBUG_44x
> +#ifndef CONFIG_BGP
>  #define PPC44x_EARLY_TLBS	1
> -#else
> +#else /* CONFIG_BGP */
> +#define PPC44x_EARLY_TLBS	2
> +#endif /* CONFIG_BGP */
> +#else /* CONFIG_PPC_EARLY_DEBUG_44x */
>  #define PPC44x_EARLY_TLBS	2
>  #define PPC44x_EARLY_DEBUG_VIRTADDR	(ASM_CONST(0xf0000000) \
>  	| (ASM_CONST(CONFIG_PPC_EARLY_DEBUG_44x_PHYSLOW) & 0xffff))


