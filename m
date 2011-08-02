Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab1HBQzu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 12:55:50 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:49121 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627Ab1HBQzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 12:55:45 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E382DF1.9000206@cam.ac.uk>
Date: Tue, 02 Aug 2011 18:03:45 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110801 Thunderbird/5.0
MIME-Version: 1.0
To: Ben Dooks <bjdooks@googlemail.com>
CC: linux-iio@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: uses of irq_to_gpio() in drivers/staging/iio
References: <4E382924.2050201@googlemail.com>
In-Reply-To: <4E382924.2050201@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/11 17:43, Ben Dooks wrote:
> Whilst looking in drivers/staging/iio/accel/lis3l02dq_core.c, I
> came across the following lines of code
> 
>    708          if (spi->irq && gpio_is_valid(irq_to_gpio(spi->irq)) > 0) {
>    709                  ret = request_threaded_irq(st->us->irq,
>    710                                             &lis3l02dq_th,
>    711 &lis3l02dq_event_handler,
>    712                                             IRQF_TRIGGER_RISING,
>    713                                             "lis3l02dq",
>    714                                             indio_dev);
> 
> Which gives rise to the following questions:
> 
> 1) IRQ0 and GPIO0 are often valid numbers for GPIOs.
Good point - should fix that one.  Any suggestions for a neat way
to do it?
> 
> 2) Not all interrupts are necessarily GPIO interrupts. What happens
>    if the device is attached to a hardware interrupt line which is
>    not a GPIO?
> 
Easy. It doesn't work.  Stupid hardware doesn't necessarily drop
the interrupt line on a read. Hence it sticks high. If one only has
edge triggered interrupt lines that's a pain. Is there an easy way
around this?  When I wrote the relevant code a long time ago I couldn't
get anything else to work.

There may well be a better way but I haven't revisited this recently.
