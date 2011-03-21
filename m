Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259Ab1CUNnr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 09:43:47 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34376 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab1CUNnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 09:43:45 -0400
Message-ID: <4D8755AD.3060402@ru.mvista.com>
Date: Mon, 21 Mar 2011 16:42:05 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Carl Vanderlip <carlv@codeaurora.org>
CC: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-fbdev@vger.kernel.org,
        Brian Swetland <swetland@google.com>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Dima Zavin <dima@android.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 18/20] video: msm: Prevent DMA lockups when switching
 bit	depths
References: <1300484846-26393-1-git-send-email-carlv@codeaurora.org> <1300485585-27640-1-git-send-email-carlv@codeaurora.org>
In-Reply-To: <1300485585-27640-1-git-send-email-carlv@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Carl Vanderlip wrote:

> Forces the lcdc off and waits a frame vsync period to prevent the MDP DMA
> engine crashing if the DMA bit depth is changed.  A sleep cannot be used
> because lcdc_dma_start is called in irq context.

    Maybe I'm blind again but I don't see any waiting...

> Authors:
> Dima Zavin <dima@android.com>
> Rebecca Schultz Zavin <rebecca@android.com>
> Colin Cross <ccross@android.com>

> Signed-off-by: Carl Vanderlip <carlv@codeaurora.org>
> ---
>  drivers/video/msm/mdp.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)

> diff --git a/drivers/video/msm/mdp.c b/drivers/video/msm/mdp.c
> index b3f334ad..49d956a 100644
> --- a/drivers/video/msm/mdp.c
> +++ b/drivers/video/msm/mdp.c
> @@ -564,6 +564,13 @@ void mdp_hw_init(struct mdp_info *mdp)
>  	mdp_writel(mdp, 1, 0x60);
>  	mdp_writel(mdp, 1, MDP_EBI2_PORTMAP_MODE);
>  
> +	/* disable lcdc */
> +	mdp_writel(mdp, 0, MDP_LCDC_CTL);
> +	/* enable auto clock gating for all blocks by default */
> +	mdp_writel(mdp, 0xffffffff, MDP_CGC_EN);
> +	/* reset color/gamma correct parms */
> +	mdp_writel(mdp, 0, MDP_DMA_P_COLOR_CORRECT_CONFIG);
> +
>  	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x01f8);
>  	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x01fc);
>  	mdp_writel(mdp, 1, 0x60);

WBR, Sergei
