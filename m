Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497Ab0DZOmG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 10:42:06 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:8575 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab0DZOmE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 10:42:04 -0400
Date: Mon, 26 Apr 2010 16:42:17 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: USB gadget with drivers "on board"
In-reply-to: <20100426141605.GO30801@buzzloop.caiaq.de>
To: Daniel Mack <daniel@caiaq.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <op.vbrxsrw07p4s8u@pikus>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.10 (Linux)
References: <op.vbrfqdznfxrvh1@pikus> <20100426141605.GO30801@buzzloop.caiaq.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Apr 26, 2010 at 10:29:05AM +0200, Michał Nazarewicz wrote:
>> I need to create an USB gadget with drivers for Windows included
>> "on board".  In particular, when the gadget is connected to Windows
>> host it is detected as mass storage and mounted drive include the
>> drivers.  However, when the drivers are installed, it is detected
>> as some other device.
>>
>> Now, it seems that a simple composite device with two configurations
>> is enough -- the first containing mass storage and the second other
>> functions.  My tests show that Windows manages to set the first
>> configuration and detect the mass storage interface.

On Mon, 26 Apr 2010 16:16:05 +0200, Daniel Mack <daniel@caiaq.de> wrote:
> Why are you using two configurations on this device instead of one
> configuration with two interfaces? Interfaces are not allowed to share
> endpoints within one configuration, so they can be used simultaniously.

Ideally, I would like to use two configurations on its own just like
g_ether that is one configuration with RNDIS and some other functionality
and another with CDC ECM and some other functionality.

It seems however that such gadgets are not properly detected by Windows
as composite devices and thus require a driver (I imagined a single INF
should be enough but now I'm not even sure of that) and so I tried adding
another configuration with just the mass storage function and this seems
to be handled correctly.

Now, even if I were to ignore the other RNDIS/ECM multiple personality
disorder and sticking to a single configuration with RNDIS there's still
an issue (or challenge if you will) of a "Found new driver" dialog
popping up like crazy when the device is inserted but the drivers from
mass storage didn't have time to install.  This is especially true since
it was my experience that RDNIS is able to freeze Windows if it's not
the first interface.

So in the end, I'm looking for a method to get a device that can be
plugged in and report as mass storage with drivers but when drivers
are installed report as something else.  I know it is possible since
I encountered several devices that do exactly that.


PS. There seem to be some mass with the To and Cc headers in my
original message.  Sorry about that.

-- 
Best regards,                                           _     _
  .o. | Liege of Serenely Enlightened Majesty of       o' \,=./ `o
  ..o | Computer Science,  Michał "mina86" Nazarewicz     (o o)
  ooo +---[mina86@mina86.com]---[mina86@jabber.org]---ooO--(_)--Ooo--
