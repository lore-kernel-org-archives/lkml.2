Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964816Ab2LFHmW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 02:42:22 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46721 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964784Ab2LFHmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 02:42:21 -0500
Date: Thu, 6 Dec 2012 08:42:15 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Lothar =?iso-8859-15?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pwm: i.MX: eliminate build warning
Message-ID: <20121206074215.GS10369@pengutronix.de>
References: <1354721681-31843-1-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1354721681-31843-1-git-send-email-LW@KARO-electronics.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:41:49 up 165 days, 22:53, 48 users,  load average: 0.74, 0.69,
 0.77
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2012 at 04:34:41PM +0100, Lothar Waﬂmann wrote:
> compiling the i.MX pwm driver produces the following warning:
> |drivers/pwm/pwm-imx.c: In function 'imx_pwm_probe':
> |drivers/pwm/pwm-imx.c:281:7: warning: assignment discards qualifiers from pointer target type
> 
> Apply a 'const' attribute to the affected variable declaration.
> 
> Signed-off-by: Lothar Waﬂmann <LW@KARO-electronics.de>

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

Sascha

> ---
>  drivers/pwm/pwm-imx.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/pwm/pwm-imx.c b/drivers/pwm/pwm-imx.c
> index 8f26e9f..65a86bd 100644
> --- a/drivers/pwm/pwm-imx.c
> +++ b/drivers/pwm/pwm-imx.c
> @@ -235,7 +235,7 @@ static int imx_pwm_probe(struct platform_device *pdev)
>  {
>  	const struct of_device_id *of_id =
>  			of_match_device(imx_pwm_dt_ids, &pdev->dev);
> -	struct imx_pwm_data *data;
> +	const struct imx_pwm_data *data;
>  	struct imx_chip *imx;
>  	struct resource *r;
>  	int ret = 0;
> -- 
> 1.7.2.5
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
