Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832Ab1F3OGd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 10:06:33 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:13332 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab1F3OG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 10:06:28 -0400
Date: Thu, 30 Jun 2011 16:06:15 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Riku Voipio <riku.voipio@iki.fi>, Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH] leds: pca9532: change driver name to be unique
Message-ID: <20110630160615.516c456a@endymion.delvare>
In-Reply-To: <1309440981-18861-1-git-send-email-w.sang@pengutronix.de>
References: <1309440981-18861-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jun 2011 15:36:21 +0200, Wolfram Sang wrote:
> This driver handles the variants pca9530-pca9533, so it chose the name
> "pca953x". However, there is a gpio driver which decided on the same
> name. As a result, those two can't be loaded at the same time. Add a
> subsystem prefix to make the driver name unique. Device matching will
> not suffer, because both are I2C drivers which match using a
> i2c_device_id-table which is not altered.
> 
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>

Which is (one of the reasons) why I hate "x" in driver names.

Acked-by: Jean Delvare <khali@linux-fr.org>

> ---
>  drivers/leds/leds-pca9532.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/leds/leds-pca9532.c b/drivers/leds/leds-pca9532.c
> index d8d3a1e..a2c8746 100644
> --- a/drivers/leds/leds-pca9532.c
> +++ b/drivers/leds/leds-pca9532.c
> @@ -88,7 +88,7 @@ static const struct pca9532_chip_info pca9532_chip_info_tbl[] = {
>  
>  static struct i2c_driver pca9532_driver = {
>  	.driver = {
> -		.name = "pca953x",
> +		.name = "leds-pca953x",
>  	},
>  	.probe = pca9532_probe,
>  	.remove = pca9532_remove,


-- 
Jean Delvare
