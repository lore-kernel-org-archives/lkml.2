Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670Ab2IKGsJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 02:48:09 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62837 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab2IKGsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 02:48:07 -0400
Message-ID: <504EDEA1.1050108@gmail.com>
Date: Tue, 11 Sep 2012 16:48:01 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: balbi@ti.com, "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Linus Walleij'" <linus.walleij@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio: samsung: use pr_* instead of printk
References: <002f01cd8f4b$b1100a30$13301e90$%han@samsung.com> <20120911063048.GA18072@arwen.pp.htv.fi> <002201cd8fe8$2aafa070$800ee150$%han@samsung.com>
In-Reply-To: <002201cd8fe8$2aafa070$800ee150$%han@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/12 16:39, Jingoo Han wrote:
> On Tuesday, September 11, 2012 3:31 PM Felipe Balbi wrote
> 
>>
>> Hi,
>>
>> On Mon, Sep 10, 2012 at 08:59:11PM +0900, Jingoo Han wrote:
>>> This patch uses pr_* instead of printk.
>>>
>>> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
>>> ---
>>>  drivers/gpio/gpio-samsung.c |    6 +++---
>>>  1 files changed, 3 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/gpio/gpio-samsung.c b/drivers/gpio/gpio-samsung.c
>>> index ba126cc..e38d990 100644
>>> --- a/drivers/gpio/gpio-samsung.c
>>> +++ b/drivers/gpio/gpio-samsung.c
>>> @@ -45,7 +45,7 @@
>>>  #ifndef DEBUG_GPIO
>>>  #define gpio_dbg(x...) do { } while (0)
>>>  #else
>>> -#define gpio_dbg(x...) printk(KERN_DEBUG x)
>>> +#define gpio_dbg(x...) pr_debug(x)
>>>  #endif
>>>
>>>  int samsung_gpio_setpull_updown(struct samsung_gpio_chip *chip,
>>> @@ -926,10 +926,10 @@ static void __init samsung_gpiolib_add(struct samsung_gpio_chip *chip)
>>>  #ifdef CONFIG_PM
>>>  	if (chip->pm != NULL) {
>>>  		if (!chip->pm->save || !chip->pm->resume)
>>> -			printk(KERN_ERR "gpio: %s has missing PM functions\n",
>>> +			pr_err("gpio: %s has missing PM functions\n",
>>>  			       gc->label);
>>
>> I would rather see dev_* conversion instead.
>>
>> my 2 cents
> 
> Hi Felipe Balbi,
> 
> OK, I will replace printk(KERN_ERR...) with dev_err.
> Thank you.

I was going to suggest that also, but I don't think that there is a dev
pointer to use. The gpio_chip structure has an optional one, but from my
quick glance it didn't look like the Samsung driver was using it. I
could be wrong though. If I am, go with dev_err (and dev_dbg for
replacing the gpio_dbg statements).

~Ryan





