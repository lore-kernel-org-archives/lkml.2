Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab0D1Iq0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 04:46:26 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:11444 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab0D1IqY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 04:46:24 -0400
Date: Wed, 28 Apr 2010 10:46:12 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: USB gadget with drivers "on board"
In-reply-to: <4BD5F43E.4090404@draisberghof.de>
To: Josua Dietze <digidietze@draisberghof.de>,
       Alan Stern <stern@rowland.harvard.edu>
Cc: Daniel Mack <daniel@caiaq.de>, Marek Szyprowski <m.szyprowski@samsung.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <op.vbu6nahq7p4s8u@pikus>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.10 (Linux)
References: <Pine.LNX.4.44L0.1004261531480.1764-100000@iolanthe.rowland.org>
 <4BD5F43E.4090404@draisberghof.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> On Mon, 26 Apr 2010, Josua Dietze wrote:
>>> These are the notorious mode switching devices. In Windows, they
>>> obviously install a special storage driver doing one specific action
>>> on each following plugging.
>>> This action - some storage or control command - will "flip" the
>>> device, making it "disconnect" and returning as a completely different
>>> composite device.
>>>
>>> Storage commands used for this procedure range from "SCSI rezero" over
>>> "passthrough" to "SCSI eject", or involve vendor specific stuff.

> Alan Stern schrieb:
>> I was going to say the same thing.  For ease of use, I recommend using
>> a "SCSI eject" to trigger the mode change.  That way, Linux users who
>> don't have the usb-modeswitch program installed can get the same effect
>> by running eject.

On Mon, 26 Apr 2010 22:14:54 +0200, Josua Dietze <digidietze@draisberghof.de> wrote:

> Important for the Linux handling is that "mode 1" is clearly
> distinguishable from "mode 2", either by using a different product ID
> or by setting a different class for the device or interface 0 (will
> most likely be "8" for the install mode).

So it will be enough to change the USB device class for the zeroth
interface for udev to recognise the mass storage to be ejected?  Note
that I will use mass storage in the second mode as well.

Also, I think that it might be a good idea to make some "standardised"
mechanism for all such devices so that a generic udev code could be
written.  Adding things to the descriptors may be difficult in a way,
but maybe adding "[NoCD]" to the interface name would be enough.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
