Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069Ab2IXQqY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 12:46:24 -0400
Received: from atlantis.wh2.tu-dresden.de ([141.30.228.39]:54216 "EHLO
	atlantis.wh2.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756995Ab2IXQqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 12:46:21 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Mon, 24 Sep 2012 18:46:19 +0200
From: Lars Poeschel <larsi@wh2.tu-dresden.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: <linux-kernel@vger.kernel.org>, Lars Poeschel <poeschel@lemonage.de>
Subject: Re: [PATCH] mfd: viperboard driver added
In-Reply-To: <20120919152957.GF28670@sortiz-mobl>
References: <1346072918-3982-1-git-send-email-larsi@wh2.tu-dresden.de>
 <20120919152957.GF28670@sortiz-mobl>
Message-ID: <86c9848e77fa42b6c48ba0703ebf637f@atlantis.wh2.tu-dresden.de>
User-Agent: AG DSN Webmail/0.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

Thanks for your review.

Am 19.09.2012 17:29, schrieb Samuel Ortiz:
> Hi Lars,
>
> On Mon, Aug 27, 2012 at 03:08:38PM +0200, larsi@wh2.tu-dresden.de 
> wrote:
>> From: Lars Poeschel <poeschel@lemonage.de>
>>
>> First version of the driver for Nano River Tech's
>> viperboard added.
>> It supports i2c, adc, gpio a and gpio b. spi and pwm on
>> the first gpio a pins is not supported yet.
>>
>> Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
>> ---
>>  drivers/mfd/Kconfig      |   17 +
>>  drivers/mfd/Makefile     |    1 +
>>  drivers/mfd/viperboard.c | 1084 
>> ++++++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 1102 insertions(+)
>>  create mode 100644 drivers/mfd/viperboard.c
> So the MFD driver contains a GPIO one, and an i2c bus driver.
> You should really split this code into at least 3 pieces: 1 for the 
> GPIO
> (drivers/gpio), another one for your i2c bus algorithm 
> (drivers/i2c/busses)
> and a last one for the actual MFD driver. Your Kconfig entries will 
> define the
> dependencies between them.
> Then you can define your SoC subdevices as MFD cells and use the MFD 
> APIs to
> add them as platform devices.

I am not really sure, but maybe you got mislead by the term 
"viperboard". It is NOT an embedded evaluation board or starterkit. It 
is an USB to SPI, I2C, GPIO and ADC interface. You can get a quick 
overview here: http://nanorivertech.com/viperboard.html
The I2C, GPIO or ADC parts of this driver will never be part of a 
"platform device" in terms of the linux kernel definining the 
configuration of different embedded evaluation boards (a platform).
Do you still think I should split up the different parts into their 
respective subsystems in the kernel and have one "core" combining those 
parts in MFD ?
If so, I will do this. As there would be multiple different maintainers 
involved, against which branch has my patch to be ?
Should I simply CC the patch to all involved maintainers ?

Regards,
Lars
