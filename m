Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334Ab1KHTJF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 14:09:05 -0500
Received: from relais.videotron.ca ([24.201.245.36]:21901 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920Ab1KHTJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 14:09:04 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Tue, 08 Nov 2011 14:08:58 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv3 2/2] msm: Support DEBUG_LL on MSM8660 and MSM8960
In-reply-to: <1320777184-22446-3-git-send-email-sboyd@codeaurora.org>
Message-id: <alpine.LFD.2.02.1111081406220.3307@xanadu.home>
References: <1320777184-22446-1-git-send-email-sboyd@codeaurora.org>
 <1320777184-22446-3-git-send-email-sboyd@codeaurora.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Nov 2011, Stephen Boyd wrote:

> Add support for DEBUG_LL on the 8660 and 8960 development boards.
> While we're here cleanup the uncompress.h code a bit. Avoid
> the use of readl/writel as those are Linux specific APIs that
> aren't guaranteed to work in the decompressor.
> 
> Cc: Nicolas Pitre <nico@fluxnic.net>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Acked-by: Nicolas Pitre <nico@linaro.org>

Independently from this patch, I was wondering about this code:

> +	.macro	senduart, rd, rx
> +#ifdef CONFIG_MSM_HAS_DEBUG_UART_HS
> +	@ Write the 1 character to UARTDM_TF
> +	str	\rd, [\rx, #0x70]
> +#else
>  	teq	\rx, #0
>  	strne	\rd, [\rx, #0x0C]
> +#endif
>  	.endm

Why testing for zero in the #else part?  The upper level code should 
never call this macro with a null byte.


Nicolas
