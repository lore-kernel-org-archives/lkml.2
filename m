Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819Ab1LESk0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 13:40:26 -0500
Received: from relais.videotron.ca ([24.201.245.36]:15216 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649Ab1LESkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 13:40:24 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Mon, 05 Dec 2011 13:40:23 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        David Brown <davidb@codeaurora.org>
Subject: Re: [PATCHv3 3/2] ARM: msm: Drop useless teq from DEBUG_LL support
In-reply-to: <1323109662-30614-1-git-send-email-sboyd@codeaurora.org>
Message-id: <alpine.LFD.2.02.1112051339370.2357@xanadu.home>
References: <1323109662-30614-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Dec 2011, Stephen Boyd wrote:

> This teq was first introduced in bcc0f6a ([ARM] msm: clean up
> iomap and devices, 2008-09-10). It seems that DEBUG_LL support on
> MSM at the time had to remove the virtual mapping for the uart
> base. Thus when the MMU was enabled the addruart macro returned 0
> and the senduart macro would test for 0 and do nothing. It was a
> simple way to turn off DEBUG_LL when the MMU was enabled.
> 
> The virtual mapping was added back in 6339f66 (msm: make
> debugging UART (for DEBUG_LL) configurable, 2009-11-02) but the
> patch forgot to remove the teq here. So as it stands the teq has
> been useless for two years and DEBUG_LL works fine without it.
> 
> Cc: Nicolas Pitre <nico@fluxnic.net>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Acked-by: Nicolas Pitre <nico@linaro.org>


> ---
>  arch/arm/mach-msm/include/mach/debug-macro.S |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mach-msm/include/mach/debug-macro.S b/arch/arm/mach-msm/include/mach/debug-macro.S
> index 3ffd866..0e05f88 100644
> --- a/arch/arm/mach-msm/include/mach/debug-macro.S
> +++ b/arch/arm/mach-msm/include/mach/debug-macro.S
> @@ -30,8 +30,7 @@
>  	@ Write the 1 character to UARTDM_TF
>  	str	\rd, [\rx, #0x70]
>  #else
> -	teq	\rx, #0
> -	strne	\rd, [\rx, #0x0C]
> +	str	\rd, [\rx, #0x0C]
>  #endif
>  	.endm
>  
> -- 
> Sent by an employee of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
> 
