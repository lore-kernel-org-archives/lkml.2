Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757112Ab2IKGjV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 02:39:21 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:46656 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756992Ab2IKGjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 02:39:19 -0400
X-AuditID: cbfee61b-b7f586d000007adc-a1-504edc953a98
From: Jingoo Han <jg1.han@samsung.com>
To: balbi@ti.com
Cc: "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Linus Walleij'" <linus.walleij@linaro.org>,
        linux-kernel@vger.kernel.org, "'Ryan Mallon'" <rmallon@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <002f01cd8f4b$b1100a30$13301e90$%han@samsung.com>
 <20120911063048.GA18072@arwen.pp.htv.fi>
In-reply-to: <20120911063048.GA18072@arwen.pp.htv.fi>
Subject: Re: [PATCH] gpio: samsung: use pr_* instead of printk
Date: Tue, 11 Sep 2012 15:39:17 +0900
Message-id: <002201cd8fe8$2aafa070$800ee150$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2P55+DMdmXQqhdSy+RAEXVMuOttwAADgbA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsVy+t9jAd2pd/wCDGbt1bG4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZ7w4fYS34xFXxY/Fn1gbGAxxdjJwcEgImEjs/HGSCsMUkLtxb
	z9bFyMUhJLCIUWLCnzeMEM5sJonuv89YQarYBNQkvnw5zA5iiwgISKx/cYkdpIhZ4DCjxKcp
	98CKhAQyJH78ncwGYnMKmEr8ufMWzBYWsJNYsqkPrJlFQFXixs1PYKt5BWwlNm4/yw5hC0r8
	mHyPBcRmFtCSWL/zOBOELS+xec1b5i5GDqBT1SUe/dWFuMFI4umav1AlIhL7XrxjnMAoNAvJ
	pFlIJs1CMmkWkpYFjCyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYJD+Zn0DsZVDRaHGAU4
	GJV4eG9E+wUIsSaWFVfmHmKU4GBWEuH1mwUU4k1JrKxKLcqPLyrNSS0+xCjNwaIkzut0zi5A
	SCA9sSQ1OzW1ILUIJsvEwSnVwFg0rXl6vmTRV8/3rYvPfDz8KEWwOkXyKpvorgMB4UfvP/xt
	84r9YnHb+vXnz3+7ci79YFyrIW/EdEGdG6rGSt4ZxrXPv2pZzEy3PJ1scdY3/8v0TX3x/m5v
	9Hq6E6X2HuMq2r+y3cX6Vm1unFpAYF00y8ZA5fQTcY1PD1teeHWtuILhUMg0GSWW4oxEQy3m
	ouJEADx3mQFhAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 11, 2012 3:31 PM Felipe Balbi wrote

> 
> Hi,
> 
> On Mon, Sep 10, 2012 at 08:59:11PM +0900, Jingoo Han wrote:
> > This patch uses pr_* instead of printk.
> >
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> > ---
> >  drivers/gpio/gpio-samsung.c |    6 +++---
> >  1 files changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/gpio/gpio-samsung.c b/drivers/gpio/gpio-samsung.c
> > index ba126cc..e38d990 100644
> > --- a/drivers/gpio/gpio-samsung.c
> > +++ b/drivers/gpio/gpio-samsung.c
> > @@ -45,7 +45,7 @@
> >  #ifndef DEBUG_GPIO
> >  #define gpio_dbg(x...) do { } while (0)
> >  #else
> > -#define gpio_dbg(x...) printk(KERN_DEBUG x)
> > +#define gpio_dbg(x...) pr_debug(x)
> >  #endif
> >
> >  int samsung_gpio_setpull_updown(struct samsung_gpio_chip *chip,
> > @@ -926,10 +926,10 @@ static void __init samsung_gpiolib_add(struct samsung_gpio_chip *chip)
> >  #ifdef CONFIG_PM
> >  	if (chip->pm != NULL) {
> >  		if (!chip->pm->save || !chip->pm->resume)
> > -			printk(KERN_ERR "gpio: %s has missing PM functions\n",
> > +			pr_err("gpio: %s has missing PM functions\n",
> >  			       gc->label);
> 
> I would rather see dev_* conversion instead.
> 
> my 2 cents

Hi Felipe Balbi,

OK, I will replace printk(KERN_ERR...) with dev_err.
Thank you.

Best regards,
Jingoo Han


> 
> --
> balbi

