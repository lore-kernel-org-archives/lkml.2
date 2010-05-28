Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756965Ab0E1IO5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 04:14:57 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58845 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756011Ab0E1IOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 04:14:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=RjPk96sJhKd3NOUxAXtTbub9ZL3OMFpVm2ar5X8GPU1eUsWz9P9SD5G5koeaQCOEHX
         ve5QT4DPUfwTuYDiJFnbGhazU9q2CTNLr8j/4Cp5f+7kR6VRVO3SvxfXx97qSaJYzGYf
         /ymZuN1dAWctLQ3Tg7UvNWSCd0lAc8CVm5DX4=
MIME-Version: 1.0
Date: Fri, 28 May 2010 13:44:51 +0530
Message-ID: <AANLkTikrEE-7RzlhetBrF8RXNtPToGe-girXu4HfoNS4@mail.gmail.com>
Subject: Re: I2c slave support
From: Jack <mylinux.list@gmail.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extremely sorry, May be I left the subject field blank.

On Fri, May 28, 2010 at 10:39 AM, Justin P. Mattock
<justinmattock@gmail.com> wrote:
> On 05/27/2010 10:01 PM, Jack wrote:
>
> Hi,
> Thanks,
>
> First solution needs additional GPIO pins, I have used all the pins.
> I'm going with the other solution, writing slave driver on the MIPS side.
> The MIPS provides an interrupt vector for the I2C bus.
>
> Regards,
> Jack
> .
>
>
> On Thu, May 27, 2010 at 11:25 AM, Haojian Zhuang
> <haojian.zhuang@gmail.com> wrote:
>
>
> On Thu, May 27, 2010 at 1:05 PM, linux_newbie good
> <mylinux.list@gmail.com> wrote:
>
>
> Hi,
>
> My board has a MIPS based Processor and a micro-controller.  The
> communication between these two interfaces is through an I2C bus. The
> Linux driver for my I2C controller (i mean the one in MIPS processor)
> has support for master transmitter and master receiver whereas I could
> not find support for slave TX and slave RX modes. Do I need to write
> my own functions for slave support? If so, what kind of changes need
> to be done, for slave mode support? Is there any other sample driver
> which can help ?
>
>
>
>
> Maybe you needn't write a slave I2C driver on MIPS side. It should
> based on your system requirement.
>
> I suggest the solution in below may be easier.
>
> ++++++++++++++                             ++++++++++++
> + MIPS (Master)  + -----> I2C -----------> + MCU (Slave)  +
> +                        +<----GPIO INT <----- +                     +
> ++++++++++++++                             ++++++++++++
>
> Since MIPS is master, it can read/write data from slave directly.
> While MCU want to contact with MIPS, it can trigger INT first. Then
> MIPS can query MCU and feed its required.
>
> Perhaps you may not choice this solution. You have to write slave
> driver on MIPS side and both master/slave driver on MCU side. You can
> refer to $LINUX/drivers/i2c/busses/i2c-pxa.c for reference. i2c-pxa
> driver supports both master and slave mode.
>
> Thanks
> Haojian
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>
> change of subject: this morning xorg with their list was having
> issues with the subject line showing peoples e-mails
> and now I see something similar here.
> i.g. Re: mylinux.list@gmail.com
> (is it me or am I seeing things?)
>
> Justin P. Mattock
>
