Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab0GHUZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 16:25:56 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:34980 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab0GHUZz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 16:25:55 -0400
Date: Thu, 08 Jul 2010 22:27:07 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCHv2 1/2] USB: gadget: mass/file storage: set serial number
In-reply-to: <425855.73532.qm@web180314.mail.gq1.yahoo.com>
To: Greg KH <greg@kroah.com>, David Brownell <david-b@pacbell.net>
Cc: linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org,
       Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>,
       mina86@mina86.com
Message-id: <op.vfjkfho27p4s8u@pikus>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.60 (Linux)
References: <425855.73532.qm@web180314.mail.gq1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Jul 2010 22:20:11 +0200, David Brownell <david-b@pacbell.net> wrote:

>> > Can it be made to do so only when the gadget
>> > hasn't been provided with one already?  Serial
>> > number module options are standard parts of the
>> > composite gadget framework...
>>
>> I don't see a way for the gadget to know whether user gave
>> the iSerialNumber
>> parameter (other then reading the iSerialNumber variable
>> but I consider that  ugly).
>
> Uglier still is the current patch overriding
> that explicitly-given parameter.

How does it override explicitly-given parameter?  I don't follow...

All it does is add a iSerialNumber.  Without this patch the
explicitly-given parameter won't even work:

	if (cdev->desc.iSerialNumber && iSerialNumber)
		string_override(composite->strings,
			cdev->desc.iSerialNumber, iSerialNumber);

Composite checks if iSerialNumber is allocated and overrides the
string only if it is.  Without my patch, the string ID is never
allocated.

Also, the overriding is performed *after* composite device's bind
callback is called so there is no way for the bind callback to
override explicitly-given parameter.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
