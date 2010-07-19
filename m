Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760652Ab0GSMGP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 08:06:15 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:65042 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760598Ab0GSMGN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 08:06:13 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Mon, 19 Jul 2010 14:07:31 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCHv3 1/3] USB: gadget: mass/file storage: set serial number
In-reply-to: <590491.14987.qm@web180309.mail.gq1.yahoo.com>
To: Greg KH <greg@kroah.com>, David Brownell <david-b@pacbell.net>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-kernel@vger.kernel.org,
        Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>,
        stable <stable@kernel.org>
Message-id: <op.vf3amtx27p4s8u@pikus>
Organization: Samsung Electronics
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.60 (Linux)
References: <590491.14987.qm@web180309.mail.gq1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jul 2010 12:08:36 +0200, David Brownell <david-b@pacbell.net> wrote:
>> It in no way duplicates functionality of the composite layer.

> Beyond the obvious "Set serial number" ...

In that case, should all the composite gadgets stop setting
the iManufacturer, iProduct and iSerialNumber?  My understanding
is that the composite module parameters are only meant as a way
to override what the module uses as default.  Using your
rationale, modules should not only stop setting those fields but
also the idVendor and idProduct.

>> As a matter of fact, without this patch, the
>> iSerialNumber module parameter won't work

> So submit a bugfix for that alone, making it
> work everywhere...

iSerialNumber not working is not the main issue.  The main issue
is that the serial number is not set by default which makes
Windows sad (Windows uses serial number to distinguish different
devices with the same vendor and product ID).  The serial number
has to be set by default without the need for user to give a
module parameter.

So even if composite.c were to be modified the code in mass
storage gadget would have to stay anyway.

> Do you know when it broke?  That code has been
> tested in the past, and observed to work.  So if
> it's not working now, someone broke it and that
> should just be fixed.

It never broke.  It was "broken" from the beginning.  Here's part of
composite.c that handles the iSerialNumber:

	if (cdev->desc.iSerialNumber && iSerialNumber)
		string_override(composite->strings,
			cdev->desc.iSerialNumber, iSerialNumber);

As you see, the iSerialNumber module parameter is ignored unless the
gadget driver sets the iSerialNumber field of the device descriptor.
This patch makes mass storage gadget and g_multi set it.  As said
above, this is orthogonal to changing the behaviour of the
iSerialNumber module parameter.


>> The second patch (by Yann Cantin) adds a serial module
>> parameter to
>> the File Storage Gadget.  FSG is not a composite
>> gadget

> OK, so it should add a module param with the same
> name as used elsewhere ...

I was going to propose that but file storage gadget uses names
different from composite anyway (ie. vendor and product instead of
idVendor and idProduct) so I dunno if it's worth it.  As a matter
of fact, "serial" seems to match the other names better.

> makes sense to me.  I Alan Acks that patch, go for it.

I believe Alan already agreed on this patch.  I'm merely updating
it to use the changes introduced by my patch to mass storage and
g_multi.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
