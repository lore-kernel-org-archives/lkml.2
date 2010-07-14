Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab0GNRLg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 13:11:36 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:60445 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab0GNRLf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 13:11:35 -0400
Date: Wed, 14 Jul 2010 19:12:49 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCHv2] usb: gadget: storage: optional SCSI WRITE FUA bit
In-reply-to: <AANLkTilnIRCgyiSbLVbPubU38CSLwVan17GAHqNMX1Ir@mail.gmail.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
        Denis Karpov <ext-denis.2.karpov@nokia.com>,
        Adrian Hunter <adrian.hunter@nokia.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org
Message-id: <op.vfuffnzb7p4s8u@pikus>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.60 (Linux)
References: <Pine.LNX.4.44L0.1007131003560.1568-100000@iolanthe.rowland.org>
 <1279098331-7872-1-git-send-email-ext-andriy.shevchenko@nokia.com>
 <op.vft2p6do7p4s8u@pikus>
 <AANLkTil1eG5yzBxvryf-TZINYjeGph-rNz8eELQtm5tj@mail.gmail.com>
 <op.vft7mxqm7p4s8u@pikus>
 <AANLkTilnIRCgyiSbLVbPubU38CSLwVan17GAHqNMX1Ir@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 2010/7/14 Michał Nazarewicz <m.nazarewicz@samsung.com>:
>> Ah, OK, I see why this is per LUN.  You want to be able not to ignore
>> FUA if the backing storage is a removable media, right?

On Wed, 14 Jul 2010 17:05:07 +0200, Andy Shevchenko <andy.shevchenko@gmail.com> wrote:
> In instance, or vise versa.

I actually see the most sense in disabling FUA on devices with their
own power supply for logical units which backing file is not (on) a
removable device unless the removable device has some kind of lock
(like CD-ROM's door).

Either way, I now see the point of having this option per-LUN.

>>> Actually fua = 1 means ignorance of that flag.

>> ignore_fua would be better name then I think.  This also stands for
>> module parameter.

Or even “nofua”.  The other solution would be to change the meaning
to the opposite (1 meaning that FUA is not ignored).

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
