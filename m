Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab0IOU5o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 16:57:44 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51016 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131Ab0IOU5m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 16:57:42 -0400
MIME-Version: 1.0
X-Originating-IP: [192.94.94.106]
In-Reply-To: <AANLkTi=CNdDYVGNmx17miVBXfPgnWY0X59Ao1pRQDN=S@mail.gmail.com>
References: <AANLkTikTBdr4U1bPtfXWhgLgdvWDMPJrFjBCktPL40dg@mail.gmail.com>
	<20100910143813.4af0a3ce@lxorguk.ukuu.org.uk>
	<AANLkTikXFmaZs+XzrOWjWoLPhyUy0CEXfOQMqP=Xp1cO@mail.gmail.com>
	<AANLkTinctyN3d4o8vq-8pAH67FaoAXOiX3=kobWkNTms@mail.gmail.com>
	<AANLkTi=CNdDYVGNmx17miVBXfPgnWY0X59Ao1pRQDN=S@mail.gmail.com>
Date: Wed, 15 Sep 2010 15:57:40 -0500
Message-ID: <AANLkTikrfwTaa5h1QoATs2kcdySWiy1XXQXcY+Bj+tf6@mail.gmail.com>
Subject: Re: Request for input regarding new driver in MFD for
 GPS_Bluetooth_FM controller CG2900
From: Pavan Savoy <pavan_savoy@sify.com>
To: pghatwork@gmail.com
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linus.walleij@stericsson.com,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Sep 15, 2010 at 5:14 AM, Par-Gunnar Hjalmdahl
<par-gunnar.p.hjalmdahl@stericsson.com> wrote:
> Hi Pavan,
>
> Thanks for your comments and sorry for me taking time to answer your mail.
> See below for answers.
>
>>
>> ok bit more of information ....
>> We don;t use the hciattach, instead we have our own daemon which opens
>> up the UART and installs the line discipline (not N_HCI, but similar
>> one called N_SHARED) when the hciconfig hci0 up happens or even when
>> /dev/radio0 (FM V4L2 device) happens or when generic GPS character
>> device (/dev/tigps) happens...
>
> :-) We also have our own user space application for opening the UART
> and setting the line disc since we don't  want to depend completely on
> hciattach, which contains more than we need, and also misses stuff
> that we want to do towards our specific controller. I just used it as
> an example since that is the common BlueZ way to open the Bluetooth
> transport.

Ok, yes currently we communicate with user-space daemon over rfkill,
we can probably use UDEV events to communicate opening/installation of
ldisc or closing of UART.

>>
>> There is non-mailine driver which gets modified to get into mainline @
>> http://git.omapzoom.org/?p=kernel/omap.git;a=tree;f=drivers/misc/ti-
>> st;h=028ff4a739d7b59b94d0c613b5ef510ff338b65d;hb=refs/heads/p-android-
>> omap-2.6.32
>>
>> feel free to have a look at it...
>> Yes our solution too works with BlueZ and non-exactly a MFD driver but
>> it is a simple platform device driver .. by looks of things the driver
>> can run as is for your chip too .. (except for the firmware search and
>> download part .. may be...).
>
> Your code is in a lot of ways similar to ours (which is not so strange
> since you address the same market with your chip as we do with ours),
> but there are several differences that would at least for now make it
> impossible for us to use your driver. When we post our first patches
> (which will hopefully be in a few days) you can see for yourself. But
> I don't think there is a simple way for us to re-use your driver.

Humn, I kind of thought may be we can have a same driver for 2
different types of chips.

>>
>> and note when we would want to support SPI transport for the same, we
>> plan a SPI-TTY driver ('ala usb-serial) where-in we can install this
>> N_TI_WL line discipline on that /dev/ttySPI0 device, and the SPI
>> related stuff to be handled by the spi-tty.c which registers itself as
>> a tty_device and a tty_driver ....
>
> Our SPI usage will be a bit different, where we don't use TTY for our
> driver. We will use the SPI directly instead.
>

Ok, I was intending towards the SPI usage of our driver when we move to SPI.

>> regards,
>> Pavan
>>
>> On Fri, Sep 10, 2010 at 2:07 PM, Pavan Savoy <pavan_savoy@sify.com>
>> wrote:
>> > Can you directly make use of the ti-st driver which is currently
>> staged?
>> > It has _EXACTLY_ the same thing.... which is REALLY REALLY surprising
>> !!!
>
> :-) As I said earlier this is quite natural since both TI and
> ST-Ericsson address the same market segments.

yes...

> /P-G
>
