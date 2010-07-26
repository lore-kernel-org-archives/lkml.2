Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638Ab0GZHHH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 03:07:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49637 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753573Ab0GZHHE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 03:07:04 -0400
References: <1280112118.14256.1.camel@mola> (sfid-20100726_034140_195818_204F7320)
Message-Id: <B518CF98-BD06-466C-AD40-BBC4C485C3F4@opensource.wolfsonmicro.com>
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
In-Reply-To: <1280112118.14256.1.camel@mola> (sfid-20100726_034140_195818_204F7320)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Mailer: iPad Mail (7B405)
Mime-Version: 1.0 (iPad Mail 7B405)
Subject: Re: [PATCH] wm8350-regulator: fix wm8350_register_regulator error handling
Date: Mon, 26 Jul 2010 00:07:20 -0700
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 Jul 2010, at 19:41, Axel Lin <axel.lin@gmail.com> wrote:

> In the case of platform_device_add() fail, we should call
> platform_device_put() instead of platform_device_del()
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

> ---
> drivers/regulator/wm8350-regulator.c |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/regulator/wm8350-regulator.c b/drivers/regulator/wm8350-regulator.c
> index 723cd1f..0e6ed7d 100644
> --- a/drivers/regulator/wm8350-regulator.c
> +++ b/drivers/regulator/wm8350-regulator.c
> @@ -1495,7 +1495,7 @@ int wm8350_register_regulator(struct wm8350 *wm8350, int reg,
>  	if (ret != 0) {
>  		dev_err(wm8350->dev, "Failed to register regulator %d: %d\n",
>  			reg, ret);
> -		platform_device_del(pdev);
> +		platform_device_put(pdev);
>  		wm8350->pmic.pdev[reg] = NULL;
>  	}
> 
> -- 
> 1.5.4.3
> 
> 
> 
