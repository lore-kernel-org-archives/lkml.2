Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162Ab2KWKna (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 05:43:30 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:49652 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246Ab2KWKn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 05:43:28 -0500
MIME-Version: 1.0
In-Reply-To: <20121123103400.GO17471@gmail.com>
References: <912d88b8906ce87cf5459cf3d5798e03bfce34c7.1353649737.git.viresh.kumar@linaro.org>
	<20121123103400.GO17471@gmail.com>
Date: Fri, 23 Nov 2012 16:13:28 +0530
Message-ID: <CAKohponW-Wd+Vrnj8mbdFMmJvwQgPq1jFCZRipBFoEhTknStHQ@mail.gmail.com>
Subject: Re: [PATCH] gpio: stmpe: Add DT support for stmpe gpio
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linus.walleij@linaro.org, grant.likely@secretlab.ca,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Vipul Kumar Samar <vipulkumar.samar@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 November 2012 16:04, Lee Jones <lee.jones@linaro.org> wrote:
> On Fri, 23 Nov 2012, Viresh Kumar wrote:
>> diff --git a/drivers/gpio/gpio-stmpe.c b/drivers/gpio/gpio-stmpe.c

>>  static int __devinit stmpe_gpio_probe(struct platform_device *pdev)
>>  {

>> -     stmpe_gpio->chip.base = pdata ? pdata->gpio_base : -1;
>
> Why have you deleted this?
>
>> +
>> +     if (pdata) {
>> +             stmpe_gpio->norequest_mask = pdata->norequest_mask;
>> +             stmpe_gpio->chip.base = pdata->gpio_base;
>
> Then added this?
>
>> +     } else {
>> +             stmpe_gpio->chip.base = -1;
>
> And this?

To group all non-DT assignments in a single if block, instead of two.

> Just leave the top line in and it saves you lots of complecations.

Sorry, Couldn't get this one.

>> +             if (np)
>> +                     of_property_read_u32(np, "st,norequest-mask",
>> +                                     &pdata->norequest_mask);
>
> Can you explain to me what this does?

You mean pdata->norequest_mask?  It marks few gpios as unusable.
Because these pads might be used by other blocks of stmpe.

>> diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c

>>  static struct mfd_cell stmpe_gpio_cell = {
>>       .name           = "stmpe-gpio",
>> +     .of_compatible  = "st,stmpe-gpio",
>
> There's no need for any of the STMPE to have their own compatible
> string, as they are MFD devices. They are registered as platform
> devices from the MFD subsystem.

This is required by mfd-core.c, mfd_add_device() isn't it?

	if (parent->of_node && cell->of_compatible) {
		for_each_child_of_node(parent->of_node, np) {
			if (of_device_is_compatible(np, cell->of_compatible)) {
				pdev->dev.of_node = np;
				break;
			}
		}
	}

--
viresh
