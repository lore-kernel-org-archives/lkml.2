Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881Ab1ISXXA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 19:23:00 -0400
Received: from relais.videotron.ca ([24.201.245.36]:55417 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756800Ab1ISXW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 19:22:59 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Mon, 19 Sep 2011 19:22:58 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: Add unwinding annotations for 64bit division functions
In-reply-to: <1316470297-5063-1-git-send-email-lauraa@codeaurora.org>
Message-id: <alpine.LFD.2.00.1109191913210.12663@xanadu.home>
References: <1316470297-5063-1-git-send-email-lauraa@codeaurora.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Sep 2011, Laura Abbott wrote:

> The 64bit division functions never had unwinding annotations
> added. This prevents a backtrace from being printed within
> the function and if a division by 0 occurs. Add the annotations.
> 
> Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
> ---
>  arch/arm/lib/div64.S |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/lib/div64.S b/arch/arm/lib/div64.S
> index faa7748..e55c484 100644
> --- a/arch/arm/lib/div64.S
> +++ b/arch/arm/lib/div64.S
> @@ -13,6 +13,7 @@
>   */
>  
>  #include <linux/linkage.h>
> +#include <asm/unwind.h>
>  
>  #ifdef __ARMEB__
>  #define xh r0
> @@ -44,6 +45,7 @@
>   */
>  
>  ENTRY(__do_div64)
> +UNWIND(.fnstart)
>  
>  	@ Test for easy paths first.
>  	subs	ip, r4, #1
> @@ -189,7 +191,12 @@ ENTRY(__do_div64)
>  	moveq	yh, xh
>  	moveq	xh, #0
>  	moveq	pc, lr
> +UNWIND(.fnend)
>  
> +UNWIND(.fnstart)
> +UNWIND(.pad #4)
> +UNWIND(.save {lr})
> +Ldiv0_64:

Why this phony fnend+fnstart here?


Nicolas
