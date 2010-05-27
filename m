Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab0E0FzT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 01:55:19 -0400
Received: from mail-pz0-f176.google.com ([209.85.222.176]:61460 "EHLO
	mail-pz0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab0E0FzR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 01:55:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CDFIkP9FMCRSIDPvJvCN/Cs6iHufZjAlkqGit8G2VvtEz2ZA/Q9PY8FyHRbLT+/wkU
         vzI8PWWkL4ZQsG3NEVaUWQ2PHhq25yWj8XBA1R597et/foYvtHU0Mj7vKUsxfbmNz9TT
         s/RfsUU3Vcm0tea967sg7dYn0air1v6x10zD8=
MIME-Version: 1.0
In-Reply-To: <AANLkTindNIXjAcuGKsg_xBL9jaQ96wxD54xoZe2iPD5v@mail.gmail.com>
References: <AANLkTindNIXjAcuGKsg_xBL9jaQ96wxD54xoZe2iPD5v@mail.gmail.com>
Date: Thu, 27 May 2010 13:55:15 +0800
Message-ID: <AANLkTimuTTH4C-O1CJHLK2XhBHWqx9pZg_aWF0jple0H@mail.gmail.com>
Subject: Re: mylinux.list@gmail.com
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: linux_newbie good <mylinux.list@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 1:05 PM, linux_newbie good
<mylinux.list@gmail.com> wrote:
> Hi,
>
> My board has a MIPS based Processor and a micro-controller.  The
> communication between these two interfaces is through an I2C bus. The
> Linux driver for my I2C controller (i mean the one in MIPS processor)
> has support for master transmitter and master receiver whereas I could
> not find support for slave TX and slave RX modes. Do I need to write
> my own functions for slave support? If so, what kind of changes need
> to be done, for slave mode support? Is there any other sample driver
> which can help ?
>
>

Maybe you needn't write a slave I2C driver on MIPS side. It should
based on your system requirement.

I suggest the solution in below may be easier.

++++++++++++++                             ++++++++++++
+ MIPS (Master)  + -----> I2C -----------> + MCU (Slave)  +
+                        +<----GPIO INT <----- +                     +
++++++++++++++                             ++++++++++++

Since MIPS is master, it can read/write data from slave directly.
While MCU want to contact with MIPS, it can trigger INT first. Then
MIPS can query MCU and feed its required.

Perhaps you may not choice this solution. You have to write slave
driver on MIPS side and both master/slave driver on MCU side. You can
refer to $LINUX/drivers/i2c/busses/i2c-pxa.c for reference. i2c-pxa
driver supports both master and slave mode.

Thanks
Haojian
