Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789Ab1DSOaH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 10:30:07 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:49261 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab1DSOaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 10:30:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=B/XSrAasLJ52cajC2NtSaU5PnbSWpfMGlyJNYArSlGKr9F4hQ3F/0wqx5RTWhBdDb8
         ih3T/FobMBdt1jpZfpqkKh8ccUSmhA9XoralNjSHIQwmLaAzl5Vr+VXPPLWAHdrX1T3c
         L7sxbAIPlB0ojPDE+dZVqaqNuQiPsGcKcst1A=
MIME-Version: 1.0
Date: Tue, 19 Apr 2011 23:30:01 +0900
Message-ID: <BANLkTink1Lz4s6D+A7ZPKGTT9a5BUWu6VA@mail.gmail.com>
Subject: SPI problem
From: "Murali K. Vemuri" <vemuri.muralikrishna@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello there,
I have a device which is Written_to/Read_from using SPI Bus.

I initialize the device like this:

static int __init myDEV_init(void)
{
   return spi_register_driver(&myDEV_driver);
}
module_init(myDEV_init);

My myDEV_probe() function looks like this:

static int __devinit myDEV_probe(struct spi_device *spi)
{
.....
.....
/*when my CPU receives a particular IRQ, I have to do a spi_read() and
do couple of spi_write(), I am using like this:*/
err = request_threaded_irq (MY_DEV_IRQ, NULL, myDEV_irq_thread,
           IRQF_TRIGGER_RISING, "MYDEV", NULL);

return 0;
}

When the Interrupt is received by the CPU, myDEV_irq_thread is being called.
However, in the ISR I have to do  spi_read(). This is always returning
"Timed out".

To verify if the device is not at all working, along with registering
for the IRQ, I also created a char device through I did a IOCTL.
The IOCTL command in turn does spi_read(). In this case spi_read() is
successful.

Since it is necessary to do spi_read() in my ISR, I searched around
and found some information that
spi_read() is callable only from contexts that can sleep.

How can I make my ISR sleep? or is there any other way of doing this?

Any help is highly appreciated.
Thanks & regards
Murali
