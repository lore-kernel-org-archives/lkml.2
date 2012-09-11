Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757766Ab2IKHD0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 03:03:26 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:51822 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483Ab2IKHDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 03:03:25 -0400
X-AuditID: cbfee61a-b7fba6d000007d5f-97-504ee22481a8
From: Jingoo Han <jg1.han@samsung.com>
To: "'Ryan Mallon'" <rmallon@gmail.com>, balbi@ti.com
Cc: "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Linus Walleij'" <linus.walleij@linaro.org>,
        linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <002f01cd8f4b$b1100a30$13301e90$%han@samsung.com>
 <20120911063048.GA18072@arwen.pp.htv.fi>
 <002201cd8fe8$2aafa070$800ee150$%han@samsung.com> <504EDEA1.1050108@gmail.com>
In-reply-to: <504EDEA1.1050108@gmail.com>
Subject: Re: [PATCH] gpio: samsung: use pr_* instead of printk
Date: Tue, 11 Sep 2012 16:02:59 +0900
Message-id: <002601cd8feb$7aa51c60$6fef5520$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2P6WgV1wDzi+5dSgqLswR4eQveswAAaQ4Q
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t9jAV2VR34BBq/Pillc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mvu/TWQoO8lfMbprH1MDYz9PFyMkhIWAi0T6xiw3CFpO4cG89
	kM3FISSwiFFiSu8XFpCEkMBsJok5T1RBbDYBNYkvXw6zdzFycIgIGEvMnR8PUs8ssIBR4uTs
	F+wQzTsZJQ419oNN5RTQlOjbeYEVxBYWsJNYsqkPrJlFQFXi/h9/kDCvgK3Ek++32SFsQYkf
	k++B7WUW0JJYv/M4E4QtL7F5zVtmkFYJAXWJR391QcIiAkYSDa9WMUOUiEjse/GOcQKj0Cwk
	k2YhmTQLyaRZSFoWMLKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAgO42dSOxhXNlgcYhTg
	YFTi4c1w8QsQYk0sK67MPcQowcGsJMLrNwsoxJuSWFmVWpQfX1Sak1p8iFGag0VJnNfpnF2A
	kEB6YklqdmpqQWoRTJaJg1OqgbHc98PuSTrVP+9wLf7be2pJwLKtc7uusD5on2aWEMMuf3KR
	4bf3lw4Gn3rvuXu3s3T5/t2rDioc5A/KE0ubIhzBs+PR1LefFtd8ZP/mPzc4qW/Xg+vqh19+
	fN16TZCxWmcyU9O7jPurM7u6Jx6sPubm+G2G81cPU4fAjFDh16XXvt8t6+HlTryuxFKckWio
	xVxUnAgAW0KQAF8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 11, 2012 3:48 PM Ryan Mallon wrote
> 
> On 11/09/12 16:39, Jingoo Han wrote:
> > On Tuesday, September 11, 2012 3:31 PM Felipe Balbi wrote
> >
> >>
> >> Hi,
> >>
> >> On Mon, Sep 10, 2012 at 08:59:11PM +0900, Jingoo Han wrote:
> >>> This patch uses pr_* instead of printk.
> >>>
> >>> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> >>> ---
> >>>  drivers/gpio/gpio-samsung.c |    6 +++---
> >>>  1 files changed, 3 insertions(+), 3 deletions(-)
> >>>
> >>> diff --git a/drivers/gpio/gpio-samsung.c b/drivers/gpio/gpio-samsung.c
> >>> index ba126cc..e38d990 100644
> >>> --- a/drivers/gpio/gpio-samsung.c
> >>> +++ b/drivers/gpio/gpio-samsung.c
> >>> @@ -45,7 +45,7 @@
> >>>  #ifndef DEBUG_GPIO
> >>>  #define gpio_dbg(x...) do { } while (0)
> >>>  #else
> >>> -#define gpio_dbg(x...) printk(KERN_DEBUG x)
> >>> +#define gpio_dbg(x...) pr_debug(x)
> >>>  #endif
> >>>
> >>>  int samsung_gpio_setpull_updown(struct samsung_gpio_chip *chip,
> >>> @@ -926,10 +926,10 @@ static void __init samsung_gpiolib_add(struct samsung_gpio_chip *chip)
> >>>  #ifdef CONFIG_PM
> >>>  	if (chip->pm != NULL) {
> >>>  		if (!chip->pm->save || !chip->pm->resume)
> >>> -			printk(KERN_ERR "gpio: %s has missing PM functions\n",
> >>> +			pr_err("gpio: %s has missing PM functions\n",
> >>>  			       gc->label);
> >>
> >> I would rather see dev_* conversion instead.
> >>
> >> my 2 cents
> >
> > Hi Felipe Balbi,
> >
> > OK, I will replace printk(KERN_ERR...) with dev_err.
> > Thank you.
> 
> I was going to suggest that also, but I don't think that there is a dev
> pointer to use. The gpio_chip structure has an optional one, but from my
> quick glance it didn't look like the Samsung driver was using it. I
> could be wrong though. If I am, go with dev_err (and dev_dbg for
> replacing the gpio_dbg statements).

Also, I cannot find dev point to use.
I will use pr_dbg, pr_err.

Thanks.

> 
> ~Ryan
> 
> 
> 


