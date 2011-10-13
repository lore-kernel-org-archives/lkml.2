Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab1JMTfn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 15:35:43 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:34950 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053Ab1JMTfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 15:35:42 -0400
Date: Thu, 13 Oct 2011 13:35:38 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Hartmut Knaack <knaack.h@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Patch V2 2/2] gpio-pca953x: fix gpio_base and add verbosity
Message-ID: <20111013193538.GD18574@ponder.secretlab.ca>
References: <4E941054.8090608@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E941054.8090608@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 11, 2011 at 11:45:56AM +0200, Hartmut Knaack wrote:
> Sorry, I messed up the porting from my work files to clean git repo.
> This should be right now.
> Inspired by the gpio-pcf857x driver, this patch will output information
> about the instantiated gpio-chip, including gpio start and end, chip
> type and if irq is used.
> 
> Signed-off-by: Hartmut Knaack <knaack.h@gmx.de>
> -------------------------------------------------------------
> diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
> index 0721d85..f1a4fad 100644
> --- a/drivers/gpio/gpio-pca953x.c
> +++ b/drivers/gpio/gpio-pca953x.c
> @@ -687,6 +687,12 @@ static int __devinit pca953x_probe(struct
> i2c_client *client,
>  	if (ret)
>  		goto out_failed_irq;
> 
> +	dev_info(&client->dev, "gpios %d..%d added on a %s%s\n",
> +		 chip->gpio_chip.base,
> +		 chip->gpio_chip.base + chip->gpio_chip.ngpio - 1,
> +		 client->name,
> +		 client->irq ? " (irq ignored)" : "");
> +

dev_dbg() for this I think.

>  	if (pdata && pdata->setup) {
>  		ret = pdata->setup(client, chip->gpio_chip.base,
>  				chip->gpio_chip.ngpio, pdata->context);
> 
