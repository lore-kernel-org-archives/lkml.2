Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678Ab1HBQne (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 12:43:34 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56312 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646Ab1HBQnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 12:43:21 -0400
Message-ID: <4E382924.2050201@googlemail.com>
Date: Tue, 02 Aug 2011 17:43:16 +0100
From: Ben Dooks <bjdooks@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: linux-iio@vger.kernel.org, jic23@cam.ac.uk,
        LKML <linux-kernel@vger.kernel.org>
Subject: uses of irq_to_gpio() in drivers/staging/iio
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whilst looking in drivers/staging/iio/accel/lis3l02dq_core.c, I
came across the following lines of code

    708          if (spi->irq && gpio_is_valid(irq_to_gpio(spi->irq)) > 0) {
    709                  ret = request_threaded_irq(st->us->irq,
    710                                             &lis3l02dq_th,
    711 
&lis3l02dq_event_handler,
    712                                             IRQF_TRIGGER_RISING,
    713                                             "lis3l02dq",
    714                                             indio_dev);

Which gives rise to the following questions:

1) IRQ0 and GPIO0 are often valid numbers for GPIOs.

2) Not all interrupts are necessarily GPIO interrupts. What happens
    if the device is attached to a hardware interrupt line which is
    not a GPIO?

-- 
Ben Dooks <bjdooks@googlemail.com> http://www.fluff.org/ben/
