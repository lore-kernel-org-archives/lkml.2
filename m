Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab1C0PEJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 11:04:09 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64005 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659Ab1C0PEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 11:04:07 -0400
Message-ID: <4D8F5186.5030109@ru.mvista.com>
Date: Sun, 27 Mar 2011 19:02:30 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: [patch 17/23] arm: at91: Cleanup irq chip
References: <20110325131617.258789658@linutronix.de>	<20110325132048.996818347@linutronix.de> <alpine.LFD.2.00.1103252202440.31464@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1103252202440.31464@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 26-03-2011 0:03, Thomas Gleixner wrote:

>> Avoid the whole lazy disable dance in the demux handler by providing a
>> irq_disable() callback.

>> Use the proper accessor functions and tidy up gpio_irq_handler()

>> Signed-off-by: Thomas Gleixner<tglx@linutronix.de>
[...]

>> Index: linux-2.6-tip/arch/arm/mach-at91/gpio.c
>> ===================================================================
>> --- linux-2.6-tip.orig/arch/arm/mach-at91/gpio.c
>> +++ linux-2.6-tip/arch/arm/mach-at91/gpio.c
[...]
>> @@ -384,16 +385,14 @@ static struct irq_chip gpio_irqchip = {
>>   static void gpio_irq_handler(unsigned irq, struct irq_desc *desc)
>>   {
>>   	unsigned	pin;
>> -	struct irq_desc	*gpio;
>> -	struct at91_gpio_chip *at91_gpio;
>> -	void __iomem	*pio;
>> +	struct irq_data *idata = irq_desc_get_irq_data(desc);
>> +	struct irq_chip *chip = irq_data_get_chip(data);
>> +	struct at91_gpio_chip *at91_gpio = irq_data_get_chip_data(data);

> Sorry, needs to be

> +	struct at91_gpio_chip *at91_gpio = irq_data_get_irq_chip_data(data);

> Will fix and resend.

    You also don't have 'data' defined anywhere, maybe you meant 'ídata'?

WBR, Sergei
