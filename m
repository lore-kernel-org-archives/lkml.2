Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964905Ab2LFHqA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 02:46:00 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42581 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754147Ab2LFHp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 02:45:57 -0500
Date: Thu, 6 Dec 2012 08:45:51 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Lothar =?iso-8859-15?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: linux-mtd@lists.infradead.org, Shawn Guo <shawn.guo@linaro.org>,
        linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: Re: [PATCH 1/2] mtd: mxc_nand: fix unbalanced clk_disable() in error
 path
Message-ID: <20121206074551.GU10369@pengutronix.de>
References: <1354779748-28869-1-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1354779748-28869-1-git-send-email-LW@KARO-electronics.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:45:25 up 165 days, 22:57, 48 users,  load average: 0.69, 0.70,
 0.76
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2012 at 08:42:27AM +0100, Lothar Waﬂmann wrote:
> If nand_scan_ident() or nand_scan_tail() fails, the NAND chip may have
> been deselected and the clock already disabled. Thus, check 'clk_act'
> in the error path to decide whether the clock still needs to be
> disabled.
> 
> This fixes a:
> |WARNING: at drivers/clk/clk.c:472 __clk_disable+0x3c/0x78()
> 
> Signed-off-by: Lothar Waﬂmann <LW@KARO-electronics.de>

Both: Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

Sascha

> ---
>  drivers/mtd/nand/mxc_nand.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mtd/nand/mxc_nand.c b/drivers/mtd/nand/mxc_nand.c
> index d316324..d965809 100644
> --- a/drivers/mtd/nand/mxc_nand.c
> +++ b/drivers/mtd/nand/mxc_nand.c
> @@ -1556,7 +1556,8 @@ static int mxcnd_probe(struct platform_device *pdev)
>  	return 0;
>  
>  escan:
> -	clk_disable_unprepare(host->clk);
> +	if (host->clk_act)
> +		clk_disable_unprepare(host->clk);
>  
>  	return err;
>  }
> -- 
> 1.7.2.5
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
