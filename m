Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424Ab1DSLlJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 07:41:09 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63012 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab1DSLlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 07:41:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=ipJmb6Za8C3+7HxS0ZwX3sLR9CT4wfp8vkvjsDAJOZ9bfqeWOwijSiVKkdFJprgoGP
         aGR1rdnapi6029Ubbn2CV5hKeZ0rvGI6ppxIu/KW8x/tMrsNTJqCuJ3YjyZIDea7yzrj
         EQ4FEf1nSIHAUAcTc1jVcFbgkKhAG9i4u8b+A=
MIME-Version: 1.0
Date: Tue, 19 Apr 2011 20:41:07 +0900
Message-ID: <BANLkTi=1svkDQt+HyaHgnann1Vre7CLUNQ@mail.gmail.com>
Subject: SPI read problem
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
