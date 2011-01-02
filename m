Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750Ab1ABTw4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 14:52:56 -0500
Received: from void.printf.net ([89.145.121.20]:36418 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990Ab1ABTwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 14:52:54 -0500
Date: Sun, 2 Jan 2011 19:52:46 +0000
From: Chris Ball <cjb@laptop.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: zhangfei gao <zhangfei.gao@gmail.com>, Philip Rakity <prakity@marvell.com>,
        Aries Lee <arieslee@jmicron.com>, Qiming Wu <wuqm@marvell.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mmc: Test bus-width for old MMC devices (v2)
Message-ID: <20110102195246.GD24820@void.printf.net>
References: <s5hfwtzbj8v.wl%tiwai@suse.de> <20101216234032.GA17239@void.printf.net> <50D31EC8-BD9E-4920-8CEB-2AD10DF9C5C5@marvell.com> <20101217034342.GA19673@void.printf.net> <s5hy67o95to.wl%tiwai@suse.de> <AANLkTimSt5a998m1oqdppsWjGCVid0-Ub81pKgsPR36f@mail.gmail.com> <E81C83FE-E3AD-49DA-86BE-95631F1B81CD@marvell.com> <AANLkTim6pQW0sDtZRNbXbgbvzuXKCdsju7z_ADBxvXPd@mail.gmail.com> <s5h62umnpxb.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h62umnpxb.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Takashi,

On Wed, Dec 22, 2010 at 09:59:44AM +0100, Takashi Iwai wrote:
> Subject: [PATCH] mmc: fix mmc_set_bus_width_ddr() call without bus-width-test cap
> 
> With the bus-width test patch, mmc_set_bus_width*() isn't called properly
> when the driver doesn't set MMC_CAP_BUS_WIDTH and no DDR mode.
> This patch fixes the regression by moving the call up before the cap test.
> 
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
>  drivers/mmc/core/mmc.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
> index 1d8409f..c86dd73 100644
> --- a/drivers/mmc/core/mmc.c
> +++ b/drivers/mmc/core/mmc.c
> @@ -558,6 +558,8 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
>  					 EXT_CSD_BUS_WIDTH,
>  					 ext_csd_bits[idx][0]);
>  			if (!err) {
> +				mmc_set_bus_width_ddr(card->host,
> +						      bus_width, MMC_SDR_MODE);
>  				/*
>  				 * If controller can't handle bus width test,
>  				 * use the highest bus width to maintain
> @@ -565,8 +567,6 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
>  				 */
>  				if (!(host->caps & MMC_CAP_BUS_WIDTH_TEST))
>  					break;
> -				mmc_set_bus_width_ddr(card->host,
> -						      bus_width, MMC_SDR_MODE);
>  				err = mmc_bus_test(card, bus_width);
>  				if (!err)
>  					break;

Thanks, I've pushed this fix to mmc-next now.

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
