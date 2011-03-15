Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166Ab1COO73 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 10:59:29 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63902 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238Ab1COO72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 10:59:28 -0400
Date: Tue, 15 Mar 2011 14:56:52 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: Jamie Iles <jamie@jamieiles.com>
Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        nicolas.ferre@atmel.com, vinod.koul@intel.com
Subject: Re: [PATCH repost 4/4] avr32: at32ap700x: specify DMA src and dst
 masters
Message-ID: <20110315145652.GI2914@pulham.picochip.com>
References: <1295619115-18420-1-git-send-email-jamie@jamieiles.com>
 <1295619115-18420-5-git-send-email-jamie@jamieiles.com>
 <1298295901.24505.68.camel@hcegtvedt>
 <20110221144539.GD2744@pulham.picochip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110221144539.GD2744@pulham.picochip.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 02:45:40PM +0000, Jamie Iles wrote:
> On Mon, Feb 21, 2011 at 02:45:00PM +0100, Hans-Christian Egtvedt wrote:
> > Spotted by Nicolas Ferre, you use the wrong struct here, should be
> > tx_dws, not rx_dws.
> 
> Apologies, here's a patch to fix it up.

Is anyone able to take this for the next merge?

Jamie

> 
> Jamie
> 
> 8<--------
> 
> From 9068d500450ad6f5189b9a71463851349700c505 Mon Sep 17 00:00:00 2001
> From: Jamie Iles <jamie@jamieiles.com>
> Date: Mon, 21 Feb 2011 14:38:32 +0000
> Subject: [PATCH] avr32: at32ap700x: fix typo in DMA master configuration
> 
> Commit 4aa5f366431fe (avr32: at32ap700x: specify DMA src and dst
> masters) specified the masters for the ac97c playback device
> but incorrectly set them in the capture slave information rather
> than playback.
> 
> Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Jamie Iles <jamie@jamieiles.com>
> ---
>  arch/avr32/mach-at32ap/at32ap700x.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
> index 2747cde..4635c7c 100644
> --- a/arch/avr32/mach-at32ap/at32ap700x.c
> +++ b/arch/avr32/mach-at32ap/at32ap700x.c
> @@ -2058,8 +2058,8 @@ at32_add_device_ac97c(unsigned int id, struct ac97c_platform_data *data,
>  		tx_dws->reg_width = DW_DMA_SLAVE_WIDTH_16BIT;
>  		tx_dws->cfg_hi = DWC_CFGH_DST_PER(4);
>  		tx_dws->cfg_lo &= ~(DWC_CFGL_HS_DST_POL | DWC_CFGL_HS_SRC_POL);
> -		rx_dws->src_master = 0;
> -		rx_dws->dst_master = 1;
> +		tx_dws->src_master = 0;
> +		tx_dws->dst_master = 1;
>  	}
>  
>  	if (platform_device_add_data(pdev, data,
> -- 
> 1.7.4
> 
