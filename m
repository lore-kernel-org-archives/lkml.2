Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750Ab3AJLEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 06:04:16 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17258 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518Ab3AJLEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 06:04:15 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 10 Jan 2013 03:03:39 -0800
Message-ID: <50EE9FFB.4040807@nvidia.com>
Date: Thu, 10 Jan 2013 16:33:23 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>
Subject: Re: [PATCH 3/4] gpio: palmas: Add support for Palams GPIO
References: <1357210020-19876-1-git-send-email-ldewangan@nvidia.com> <1357210020-19876-4-git-send-email-ldewangan@nvidia.com> <CACRpkdbSW+aj9RSedsAMyF3UtSL+w=0KM+pxc2bGdceSy+rXaw@mail.gmail.com>
In-Reply-To: <CACRpkdbSW+aj9RSedsAMyF3UtSL+w=0KM+pxc2bGdceSy+rXaw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 January 2013 04:27 PM, Linus Walleij wrote:
> On Thu, Jan 3, 2013 at 11:46 AM, Laxman Dewangan <ldewangan@nvidia.com> wrote:
>
>> Add gpio driver for TI Palmas series PMIC. This has 8 gpio which can
>> work as input/output.
>>
>> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> This driver seems unnecessary. Can't you just use
> drivers/gpio/gpio-generic.c ?
The gpio-generic driver is for the MMIO based interface. This is for the 
PMIC-Palma which is in i2c interface and so need to have register access 
through the i2c call exposed by palma mfd driver.



>
>> +static int palmas_gpio_to_irq(struct gpio_chip *gc, unsigned offset)
>> +{
>> +       struct palmas_gpio *pg = to_palmas_gpio(gc);
>> +       struct palmas *palmas = pg->palmas;
>> +
>> +       return palmas_irq_get_virq(palmas, PALMAS_GPIO_0_IRQ + offset);
>> +}
> Why are you implementing this for a driver which does not even expose
> the ability to trigger IRQs? If it's supposed to support IRQs it should
> register a struct irq_chip.

The interrupts are registered in mfd core via the regmap-irq_chip.
This api converts the gpio number to corresponding irq.

