Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429Ab0IJTZr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 15:25:47 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48690 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178Ab0IJTZp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 15:25:45 -0400
MIME-Version: 1.0
X-Originating-IP: [192.94.94.105]
In-Reply-To: <AANLkTikXFmaZs+XzrOWjWoLPhyUy0CEXfOQMqP=Xp1cO@mail.gmail.com>
References: <AANLkTikTBdr4U1bPtfXWhgLgdvWDMPJrFjBCktPL40dg@mail.gmail.com>
	<20100910143813.4af0a3ce@lxorguk.ukuu.org.uk>
	<AANLkTikXFmaZs+XzrOWjWoLPhyUy0CEXfOQMqP=Xp1cO@mail.gmail.com>
Date: Fri, 10 Sep 2010 14:25:44 -0500
Message-ID: <AANLkTinctyN3d4o8vq-8pAH67FaoAXOiX3=kobWkNTms@mail.gmail.com>
Subject: Re: Request for input regarding new driver in MFD for
 GPS_Bluetooth_FM controller CG2900
From: Pavan Savoy <pavan_savoy@sify.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, linus.walleij@stericsson.com,
        par-gunnar.p.hjalmdahl@stericsson.com
Cc: pghatwork@gmail.com, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ok bit more of information ....
We don;t use the hciattach, instead we have our own daemon which opens
up the UART and installs the line discipline (not N_HCI, but similar
one called N_SHARED) when the hciconfig hci0 up happens or even when
/dev/radio0 (FM V4L2 device) happens or when generic GPS character
device (/dev/tigps) happens...

There is non-mailine driver which gets modified to get into mainline @
http://git.omapzoom.org/?p=kernel/omap.git;a=tree;f=drivers/misc/ti-st;h=028ff4a739d7b59b94d0c613b5ef510ff338b65d;hb=refs/heads/p-android-omap-2.6.32

feel free to have a look at it...
Yes our solution too works with BlueZ and non-exactly a MFD driver but
it is a simple platform device driver .. by looks of things the driver
can run as is for your chip too .. (except for the firmware search and
download part .. may be...).

and note when we would want to support SPI transport for the same, we
plan a SPI-TTY driver ('ala usb-serial) where-in we can install this
N_TI_WL line discipline on that /dev/ttySPI0 device, and the SPI
related stuff to be handled by the spi-tty.c which registers itself as
a tty_device and a tty_driver ....

regards,
Pavan

On Fri, Sep 10, 2010 at 2:07 PM, Pavan Savoy <pavan_savoy@sify.com> wrote:
> Can you directly make use of the ti-st driver which is currently staged?
> It has _EXACTLY_ the same thing.... which is REALLY REALLY surprising !!!
>
> On Fri, Sep 10, 2010 at 8:38 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>>>  - Is it OK to dynamically use the channels either from Kernel or User space?
>>
>> Quite a few devices do this. In most cases it makes no sense to burden
>> the user with channel management so its only natural that opening the tty
>> or direct interfaces should "just work"
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-bluetooth" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
