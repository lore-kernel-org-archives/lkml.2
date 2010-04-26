Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab0DZPpG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 11:45:06 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:12626 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785Ab0DZPpD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 11:45:03 -0400
Date: Mon, 26 Apr 2010 17:45:17 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: USB gadget with drivers "on board"
In-reply-to: <20100426145700.GP30801@buzzloop.caiaq.de>
To: Daniel Mack <daniel@caiaq.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <op.vbr0prfb7p4s8u@pikus>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.10 (Linux)
References: <op.vbrfqdznfxrvh1@pikus>
 <20100426141605.GO30801@buzzloop.caiaq.de> <op.vbrxsrw07p4s8u@pikus>
 <20100426145700.GP30801@buzzloop.caiaq.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Apr 26, 2010 at 04:42:17PM +0200, Michał Nazarewicz wrote:
>> Ideally, I would like to use two configurations on its own just like
>> g_ether that is one configuration with RNDIS and some other functionality
>> and another with CDC ECM and some other functionality.

On Mon, 26 Apr 2010 16:16:05 +0200, Daniel Mack <daniel@caiaq.de> wrote:
> If you do that, the configuration which is chosen eventually purely
> relies on the driver stack and/or user setting.

Granted, but since RDNIS needs an INF anyway there should be little or no
problems in specifying which configuration we are interested in.  And Linux
has a special case for RNDIS so there should be no problems here.

>> It seems however that such gadgets are not properly detected by Windows
>> as composite devices and thus require a driver (I imagined a single INF
>> should be enough but now I'm not even sure of that) and so I tried adding
>> another configuration with just the mass storage function and this seems
>> to be handled correctly.

> Maybe Windows just selects the interface it has a driver for already?

No.  Windows has a driver for composite gadget which acts as a bus for
other USB drivers connected to interfaces.  However, in order for Windows
to treat a gadget as composite several rules need to be adhered to.  Those
include specific class, subclass and protocol as well as requirement that
the gadget can have only one configuration.  The rules are described at
<URL:http://msdn.microsoft.com/en-us/library/ff537109.aspx>.

> On the other hand, that would be giving a hint of some sort of
> intelligence, which I can't believe either as their USB stack is totally
> screwed. Not a single detail in its implementation seems to make any
> sense.

Yes, I think we all agree on that. ;)

>> Now, even if I were to ignore the other RNDIS/ECM multiple personality
>> disorder and sticking to a single configuration with RNDIS there's still
>> an issue (or challenge if you will) of a "Found new driver" dialog
>> popping up like crazy when the device is inserted but the drivers from
>> mass storage didn't have time to install.

> Yeah, great technology. Even if you install the driver (which you have
> to do even for USB sticks), you'll be prompted for the same action again
> once you dare to plug in the device in some other port.

Hopefully, then the drivers are installed Windows will be able to find them
on its own, but this goes even beyond that.  When the device is connected
for the first time there will be no drivers and the full blown "Found
New Hardware" dialog will be shown.

On the other hand, if I ware able to make Windows treat me as a mass
storage gadget when drivers are not installed, this will solve (some of)
my problems.

>> So in the end, I'm looking for a method to get a device that can be
>> plugged in and report as mass storage with drivers but when drivers
>> are installed report as something else.  I know it is possible since
>> I encountered several devices that do exactly that.

> Are you sure they don't do exactly that by running two interfaces in
> the same configuration?

Yes, I'm sure.  I've investigated an USB GSM modem which, when plugged
for the first time reports as mass storage (single configuration, single
interface) and when drivers are installed as a full blown composite
gadget.  I still haven't figured out how it does that.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
