Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab1BUNp0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 08:45:26 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:52808 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756019Ab1BUNpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 08:45:25 -0500
Subject: Re: [PATCH repost 4/4] avr32: at32ap700x: specify DMA src and dst
 masters
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
In-Reply-To: <1295619115-18420-5-git-send-email-jamie@jamieiles.com>
References: <1295619115-18420-1-git-send-email-jamie@jamieiles.com>
	 <1295619115-18420-5-git-send-email-jamie@jamieiles.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Atmel Corporation
Date: Mon, 21 Feb 2011 14:45:00 +0100
Message-ID: <1298295901.24505.68.camel@hcegtvedt>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Feb 2011 13:45:04.0199 (UTC) FILETIME=[8B134D70:01CBD1CD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-21 at 14:11 +0000, Jamie Iles wrote: 
> Now that the dw_dmac DMA driver supports configurable source and
> destination masters we need to specify which ones to use. This was
> previously hardcoded to 0 and 1 respectively in the driver.
> 
> Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Jamie Iles <jamie@jamieiles.com>
> ---
>  arch/avr32/mach-at32ap/at32ap700x.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
> index e67c999..2747cde 100644
> --- a/arch/avr32/mach-at32ap/at32ap700x.c
> +++ b/arch/avr32/mach-at32ap/at32ap700x.c
> @@ -2048,6 +2048,8 @@ at32_add_device_ac97c(unsigned int id, struct ac97c_platform_data *data,
>  		rx_dws->reg_width = DW_DMA_SLAVE_WIDTH_16BIT;
>  		rx_dws->cfg_hi = DWC_CFGH_SRC_PER(3);
>  		rx_dws->cfg_lo &= ~(DWC_CFGL_HS_DST_POL | DWC_CFGL_HS_SRC_POL);
> +		rx_dws->src_master = 0;
> +		rx_dws->dst_master = 1;
>  	}
>  
>  	/* Check if DMA slave interface for playback should be configured. */
> @@ -2056,6 +2058,8 @@ at32_add_device_ac97c(unsigned int id, struct ac97c_platform_data *data,
>  		tx_dws->reg_width = DW_DMA_SLAVE_WIDTH_16BIT;
>  		tx_dws->cfg_hi = DWC_CFGH_DST_PER(4);
>  		tx_dws->cfg_lo &= ~(DWC_CFGL_HS_DST_POL | DWC_CFGL_HS_SRC_POL);
> +		rx_dws->src_master = 0;
> +		rx_dws->dst_master = 1;

Spotted by Nicolas Ferre, you use the wrong struct here, should be
tx_dws, not rx_dws.

<snipp>

-- 
Hans-Christian Egtvedt

