Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898Ab0D1LbU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 07:31:20 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:52114 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab0D1LbT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 07:31:19 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Wed, 28 Apr 2010 13:31:35 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: USB gadget with drivers "on board"
In-reply-to: <op.vbu6nahq7p4s8u@pikus>
To: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>,
       Josua Dietze <digidietze@draisberghof.de>,
       Alan Stern <stern@rowland.harvard.edu>
Cc: Daniel Mack <daniel@caiaq.de>, Marek Szyprowski <m.szyprowski@samsung.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <op.vbveaxnm7p4s8u@pikus>
Organization: Samsung Electronics
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.10 (Linux)
References: <Pine.LNX.4.44L0.1004261531480.1764-100000@iolanthe.rowland.org>
 <4BD5F43E.4090404@draisberghof.de> <op.vbu6nahq7p4s8u@pikus>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Mon, 26 Apr 2010, Josua Dietze wrote:
>>>> These are the notorious mode switching devices. In Windows, they
>>>> obviously install a special storage driver doing one specific action
>>>> on each following plugging.
>>>> This action - some storage or control command - will "flip" the
>>>> device, making it "disconnect" and returning as a completely different
>>>> composite device.

>> Alan Stern schrieb:
>>> I was going to say the same thing.  For ease of use, I recommend using
>>> a "SCSI eject" to trigger the mode change.  That way, Linux users who
>>> don't have the usb-modeswitch program installed can get the same effect
>>> by running eject.

On Wed, 28 Apr 2010 10:46:12 +0200, Michał Nazarewicz <m.nazarewicz@samsung.com> wrote:
> Also, I think that it might be a good idea to make some "standardised"
> mechanism for all such devices so that a generic udev code could be
> written.  Adding things to the descriptors may be difficult in a way,
> but maybe adding "[NoCD]" to the interface name would be enough.

It got me thinking that maybe, it would be cool to do things in a generic
way in Linux by using the iConfiguration.  A, let's call it' NoCD-capable
device would have the first configuration named "Foo Installation Disc
[NoCD]" end while enumerating Linux would prefer configurations which
don't have the tag over the ones that have it.  At the same time, for
older kernels an udev rule would be provided.  And of course, non
NoCD-capable devices (or Linux-unaware if you will) devices would be
handled the way they are handled now.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
