Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117Ab2LQPL2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 10:11:28 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:44850 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384Ab2LQPL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 10:11:27 -0500
Message-ID: <50CF361A.1030203@gmail.com>
Date: Mon, 17 Dec 2012 16:11:22 +0100
From: =?ISO-8859-1?Q?Marcos_Lois_Berm=FAdez?= <marcos.discalis@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Question about using new request_threaded_irq
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm downloaded kernel sources 3.2.27, and now I'm writing a device 
driver for a SPI device, i make some kernel drivers in the past, so now 
I'm surfing the source tree to see the new mode to make things.

My driver need handle hardware interrupts, in the past i use 
request_irq, but now there is a request_threaded_irq that makes more 
easy to have a top / bottom processing. But I'm confuse, after read the 
inner implementation of request_threaded_irq and see some drivers that 
use it. For my understand if i call for example:

request_threaded_irq(irqmum, NULL, irq_handle, IRQF_TRIGGER_FALLING, 
DEVICE_NAME, priv);

This seem to make a old Hard IRQ handler, and inside of this handler 
sleep APIs can't be used, but i see some SPI drivers that seem to 
register a IRQ of this form and make API calls that can sleep in the 
handler. Ex: drivers/input/touchscreen/ad7877.c it register the IRQ as:

err = request_threaded_irq(spi->irq, NULL, ad7877_irq,
                    IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
                    spi->dev.driver->name, ts);

And inside of ad7877_irq make a block call:

static irqreturn_t ad7877_irq(int irq, void *handle)
{
..
error = spi_sync(ts->spi, &ts->msg);
..
}

Is this ok?
With the new interface 'request_threaded_irq' all the IRQ are 
implemented on a thread?
Do i need to create a handler for thread and pass it to 
'request_threaded_irq', and if yes, why a lot of drivers, only pass 
quick_check_handler and make hard processing on it?

Excuse my poor English.

Regards.
