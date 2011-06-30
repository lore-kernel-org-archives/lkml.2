Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206Ab1F3OLO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 10:11:14 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:16646 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab1F3OLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 10:11:08 -0400
Date: Thu, 30 Jun 2011 16:11:01 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] gpio: pca953x: change driver name to be unique
Message-ID: <20110630161101.4bee9b19@endymion.delvare>
In-Reply-To: <1309440959-18692-1-git-send-email-w.sang@pengutronix.de>
References: <1309440959-18692-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jun 2011 15:35:59 +0200, Wolfram Sang wrote:
> This driver handles the variants pca9534-pca9539, so it chose the name
> "pca953x". However, there is a led driver which decided on the same
> name. As a result, those two can't be loaded at the same time. Add a
> subsystem prefix to make the driver name unique. Device matching will
> not suffer, because both are I2C drivers which match using a
> i2c_device_id-table which is not altered.
> 
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> ---
>  drivers/gpio/pca953x.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/gpio/pca953x.c b/drivers/gpio/pca953x.c
> index 0451d7a..b30dd0b 100644
> --- a/drivers/gpio/pca953x.c
> +++ b/drivers/gpio/pca953x.c
> @@ -742,7 +742,7 @@ static int pca953x_remove(struct i2c_client *client)
>  
>  static struct i2c_driver pca953x_driver = {
>  	.driver = {
> -		.name	= "pca953x",
> +		.name	= "gpio-pca953x",
>  	},
>  	.probe		= pca953x_probe,
>  	.remove		= pca953x_remove,

With the proposed change to the leds-pca9532 driver, you could leave
this one alone, for the sake of simplicity and consistency with the
pca953x, pcf857x and max732x gpio drivers.

But I am not objecting to this change, if you like it.

-- 
Jean Delvare
