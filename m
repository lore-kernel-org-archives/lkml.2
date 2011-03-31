Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382Ab1CaEDe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 00:03:34 -0400
Received: from mail.bluewatersys.com ([202.124.120.130]:60215 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750706Ab1CaEDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 00:03:33 -0400
Message-ID: <4D93FD29.4020104@bluewatersys.com>
Date: Thu, 31 Mar 2011 17:03:53 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux kernel <linux-kernel@vger.kernel.org>,
        hartleys <hartleys@visionengravers.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] EP93xx: Remove ep93xx_gpio_dbg_show function
References: <4D9113AA.20404@bluewatersys.com> <20110331040147.GG21226@ponder.secretlab.ca>
In-Reply-To: <20110331040147.GG21226@ponder.secretlab.ca>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2011 05:01 PM, Grant Likely wrote:
> On Tue, Mar 29, 2011 at 12:03:06PM +1300, Ryan Mallon wrote:
>> Hartley pointed out that the patch I posted to remove the irq internals
>> fiddling from ep93xx_gpio_dbg_show does not function as expected. It
>> will print [interrupt] beside all pins which are capable of being
>> interrupts, not just those which are currently configured as interrupts.
>>
>> The best solution is just to remove the custom ep93xx gpio debugfs
>> function all together. The generic gpiolib one is good enough.
>>
>> Signed-off-by: Ryan Mallon <ryan@bluewatersys.com>
> 
> Applied, thanks.
> 
> g.

This is presently sitting in rmk's patch tracking system. I take it I
should drop it from there?

~Ryan

>> ---
>>
>> diff --git a/arch/arm/mach-ep93xx/gpio.c b/arch/arm/mach-ep93xx/gpio.c
>> index 34e071d..c74adf9 100644
>> --- a/arch/arm/mach-ep93xx/gpio.c
>> +++ b/arch/arm/mach-ep93xx/gpio.c
>> @@ -348,29 +348,6 @@ static int ep93xx_gpio_set_debounce(struct gpio_chip *chip,
>>  	return 0;
>>  }
>>  
>> -static void ep93xx_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
>> -{
>> -	struct ep93xx_gpio_chip *ep93xx_chip = to_ep93xx_gpio_chip(chip);
>> -	u8 data_reg, data_dir_reg;
>> -	int gpio, i;
>> -
>> -	data_reg = __raw_readb(ep93xx_chip->data_reg);
>> -	data_dir_reg = __raw_readb(ep93xx_chip->data_dir_reg);
>> -
>> -	gpio = ep93xx_chip->chip.base;
>> -	for (i = 0; i < chip->ngpio; i++, gpio++) {
>> -		int is_out = data_dir_reg & (1 << i);
>> -		int irq = gpio_to_irq(gpio);
>> -
>> -		seq_printf(s, " %s%d gpio-%-3d (%-12s) %s %s %s\n",
>> -				chip->label, i, gpio,
>> -				gpiochip_is_requested(chip, i) ? : "",
>> -				is_out ? "out" : "in ",
>> -				(data_reg & (1<<  i)) ? "hi" : "lo",
>> -				(!is_out && irq>= 0) ? "(interrupt)" : "");
>> -	}
>> -}
>> -
>>  #define EP93XX_GPIO_BANK(name, dr, ddr, base_gpio)			\
>>  	{								\
>>  		.chip = {						\
>> @@ -379,7 +356,6 @@ static void ep93xx_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
>>  			.direction_output = ep93xx_gpio_direction_output, \
>>  			.get		  = ep93xx_gpio_get,		\
>>  			.set		  = ep93xx_gpio_set,		\
>> -			.dbg_show	  = ep93xx_gpio_dbg_show,	\
>>  			.base		  = base_gpio,			\
>>  			.ngpio		  = 8,				\
>>  		},							\
>>


-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
