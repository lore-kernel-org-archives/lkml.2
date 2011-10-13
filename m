Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab1JMVq2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 17:46:28 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:55188 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754618Ab1JMVq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 17:46:27 -0400
X-Authenticated: #1242716
X-Provags-ID: V01U2FsdGVkX1+po/k2hFKp46inMIDlKUKia5kDI3luYKUWf8Hbct
	Ehj85VAC3wTBCH
Message-ID: <4E975C30.80407@gmx.de>
Date: Thu, 13 Oct 2011 23:46:24 +0200
From: Hartmut Knaack <knaack.h@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Firefox/7.0.1 SeaMonkey/2.4.1
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org
Subject: Re: [Patch V2 2/2] gpio-pca953x: fix gpio_base and add verbosity
References: <4E941054.8090608@gmx.de> <20111013193538.GD18574@ponder.secretlab.ca>
In-Reply-To: <20111013193538.GD18574@ponder.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Likely schrieb:
> On Tue, Oct 11, 2011 at 11:45:56AM +0200, Hartmut Knaack wrote:
>> Sorry, I messed up the porting from my work files to clean git repo.
>> This should be right now.
>> Inspired by the gpio-pcf857x driver, this patch will output information
>> about the instantiated gpio-chip, including gpio start and end, chip
>> type and if irq is used.
>>
>> Signed-off-by: Hartmut Knaack <knaack.h@gmx.de>
>> -------------------------------------------------------------
>> diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
>> index 0721d85..f1a4fad 100644
>> --- a/drivers/gpio/gpio-pca953x.c
>> +++ b/drivers/gpio/gpio-pca953x.c
>> @@ -687,6 +687,12 @@ static int __devinit pca953x_probe(struct
>> i2c_client *client,
>>  	if (ret)
>>  		goto out_failed_irq;
>>
>> +	dev_info(&client->dev, "gpios %d..%d added on a %s%s\n",
>> +		 chip->gpio_chip.base,
>> +		 chip->gpio_chip.base + chip->gpio_chip.ngpio - 1,
>> +		 client->name,
>> +		 client->irq ? " (irq ignored)" : "");
>> +
> dev_dbg() for this I think.
A short look into all other gpio drivers revealed which functions are normally used for that purpose:
pr_info: gpio-xilinx
dev_info: gpio-pcf857x, gpio-nomadik, gpio-janz-ttl, gpio-cs5535, gpio-adp5588
printk: gpio-bt8xx
I took that one from the pcf857x driver, but personally I also think that info is an appropriate verbosity level.
Empowered by Ryan Mallon's comment I thought about removing those functions from gpio driver code and move it to gpiochip_add function. This way reducing redundancy and improving uniformity. It's just 7 drivers + gpiolib, which need to be changed. What do you think?
>>  	if (pdata && pdata->setup) {
>>  		ret = pdata->setup(client, chip->gpio_chip.base,
>>  				chip->gpio_chip.ngpio, pdata->context);
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

