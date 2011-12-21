Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470Ab1LUH1P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 02:27:15 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:50173 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab1LUH1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 02:27:12 -0500
Message-ID: <20209.35406.958883.977664@ipc1.ka-ro>
Date: Wed, 21 Dec 2011 08:27:10 +0100
From: =?utf-8?Q?Lothar_Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [BUGFIX] video/mxsfb: fix crash when unblanking the display
In-Reply-To: <1323174425-24038-1-git-send-email-LW@KARO-electronics.de>
References: <1323174425-24038-1-git-send-email-LW@KARO-electronics.de>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Lothar Waßmann writes:
> The VDCTRL4 register does not provide the MXS SET/CLR/TOGGLE feature.
> The write in mxsfb_disable_controller() sets the data_cnt for the LCD
> DMA to 0 which obviously means the max. count for the LCD DMA and
> leads to overwriting arbitrary memory when the display is unblanked.
> 
> Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
> ---
>  drivers/video/mxsfb.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/video/mxsfb.c b/drivers/video/mxsfb.c
> index d837d63..03cb95a 100644
> --- a/drivers/video/mxsfb.c
> +++ b/drivers/video/mxsfb.c
> @@ -366,7 +366,8 @@ static void mxsfb_disable_controller(struct fb_info *fb_info)
>  		loop--;
>  	}
>  
> -	writel(VDCTRL4_SYNC_SIGNALS_ON, host->base + LCDC_VDCTRL4 + REG_CLR);
> +	reg = readl(host->base + LCDC_VDCTRL4);
> +	writel(reg & ~VDCTRL4_SYNC_SIGNALS_ON, host->base + LCDC_VDCTRL4);
>  
>  	clk_disable(host->clk);
>  
> -- 
> 1.5.6.5
> 
Ping. Any comments on this?


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
