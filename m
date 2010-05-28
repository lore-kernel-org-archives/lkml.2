Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185Ab0E1FBo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 01:01:44 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45086 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872Ab0E1FBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 01:01:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=hrhnjSPWealGqS/WHxO8JD+nW8lhzjnQTr9LP9Y3jIeCUjBOdwtdu5NmDwBdHDW88w
         dHs4JUfCRCcl5ez5gKsC6qMYGTd/ObDzb3VAvgPGuGr+WaY+ZwDxTWHk1cl6cXvWu7Q4
         iSP7sq/ASsH/JWpz3jrrGCen8nEgIxu39wUT8=
MIME-Version: 1.0
In-Reply-To: <AANLkTimuTTH4C-O1CJHLK2XhBHWqx9pZg_aWF0jple0H@mail.gmail.com>
References: <AANLkTindNIXjAcuGKsg_xBL9jaQ96wxD54xoZe2iPD5v@mail.gmail.com>
	<AANLkTimuTTH4C-O1CJHLK2XhBHWqx9pZg_aWF0jple0H@mail.gmail.com>
Date: Fri, 28 May 2010 10:31:41 +0530
Message-ID: <AANLkTilv0sLE_ZO6B_BZiD34kAexkSi_ngawBoIje8jQ@mail.gmail.com>
Subject: Re: mylinux.list@gmail.com
From: Jack <mylinux.list@gmail.com>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Thanks,

First solution needs additional GPIO pins, I have used all the pins.
I'm going with the other solution, writing slave driver on the MIPS side.
The MIPS provides an interrupt vector for the I2C bus.

Regards,
Jack
.


On Thu, May 27, 2010 at 11:25 AM, Haojian Zhuang
<haojian.zhuang@gmail.com> wrote:
> On Thu, May 27, 2010 at 1:05 PM, linux_newbie good
> <mylinux.list@gmail.com> wrote:
>> Hi,
>>
>> My board has a MIPS based Processor and a micro-controller.  The
>> communication between these two interfaces is through an I2C bus. The
>> Linux driver for my I2C controller (i mean the one in MIPS processor)
>> has support for master transmitter and master receiver whereas I could
>> not find support for slave TX and slave RX modes. Do I need to write
>> my own functions for slave support? If so, what kind of changes need
>> to be done, for slave mode support? Is there any other sample driver
>> which can help ?
>>
>>
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
