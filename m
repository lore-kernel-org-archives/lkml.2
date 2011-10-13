Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab1JMWgq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 18:36:46 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36577 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836Ab1JMWgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 18:36:45 -0400
Date: Thu, 13 Oct 2011 16:36:42 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Hartmut Knaack <knaack.h@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Patch V2 2/2] gpio-pca953x: fix gpio_base and add verbosity
Message-ID: <20111013223642.GB28726@ponder.secretlab.ca>
References: <4E941054.8090608@gmx.de>
 <20111013193538.GD18574@ponder.secretlab.ca>
 <4E975C30.80407@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E975C30.80407@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 11:46:24PM +0200, Hartmut Knaack wrote:
> Grant Likely schrieb:
> > On Tue, Oct 11, 2011 at 11:45:56AM +0200, Hartmut Knaack wrote:
> >> Sorry, I messed up the porting from my work files to clean git repo.
> >> This should be right now.
> >> Inspired by the gpio-pcf857x driver, this patch will output information
> >> about the instantiated gpio-chip, including gpio start and end, chip
> >> type and if irq is used.
> >>
> >> Signed-off-by: Hartmut Knaack <knaack.h@gmx.de>
> >> -------------------------------------------------------------
> >> diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
> >> index 0721d85..f1a4fad 100644
> >> --- a/drivers/gpio/gpio-pca953x.c
> >> +++ b/drivers/gpio/gpio-pca953x.c
> >> @@ -687,6 +687,12 @@ static int __devinit pca953x_probe(struct
> >> i2c_client *client,
> >>  	if (ret)
> >>  		goto out_failed_irq;
> >>
> >> +	dev_info(&client->dev, "gpios %d..%d added on a %s%s\n",
> >> +		 chip->gpio_chip.base,
> >> +		 chip->gpio_chip.base + chip->gpio_chip.ngpio - 1,
> >> +		 client->name,
> >> +		 client->irq ? " (irq ignored)" : "");
> >> +
> > dev_dbg() for this I think.
> A short look into all other gpio drivers revealed which functions are normally used for that purpose:
> pr_info: gpio-xilinx
> dev_info: gpio-pcf857x, gpio-nomadik, gpio-janz-ttl, gpio-cs5535, gpio-adp5588
> printk: gpio-bt8xx
> I took that one from the pcf857x driver, but personally I also think that info is an appropriate verbosity level.
> Empowered by Ryan Mallon's comment I thought about removing those functions from gpio driver code and move it to gpiochip_add function. This way reducing redundancy and improving uniformity. It's just 7 drivers + gpiolib, which need to be changed. What do you think?
> >>  	if (pdata && pdata->setup) {
> >>  		ret = pdata->setup(client, chip->gpio_chip.base,
> >>  				chip->gpio_chip.ngpio, pdata->context);
> >>

Draft a patch and we'll see what it looks like.

g.

