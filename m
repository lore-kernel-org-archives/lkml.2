Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896Ab1HXOyF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 10:54:05 -0400
Received: from smtp-out.google.com ([74.125.121.67]:18347 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab1HXOyA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 10:54:00 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:content-type:to:cc:subject:references:
	mime-version:content-transfer-encoding:from:organization:date:message-id:
	in-reply-to:user-agent:x-system-of-record;
	b=eujvae2qjHIuxTswAHeNrSrBb9t1UIiNn7PYnoy5vlgrs/GMzK1CaLPUuZKy9UUre
	9BE4HKAr84Zbx37F8kK9A==
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Alan Stern" <stern@rowland.harvard.edu>
Cc: "Felipe Balbi" <balbi@ti.com>,
        "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
        "Yang Rui Rui" <ruirui.r.yang@tieto.com>,
        "Dave Young" <hidave.darkstar@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 2/4] usb: gadget: replace "is_dualspeed" with
 "max_speed"
References: <Pine.LNX.4.44L0.1108241028370.2010-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mnazarewicz@google.com>
Organization: Google
Date: Wed, 24 Aug 2011 16:53:52 +0200
Message-ID: <op.v0p3n2m9vgw7ix@mnazarewicz-glaptop>
In-Reply-To: <Pine.LNX.4.44L0.1108241028370.2010-100000@iolanthe.rowland.org>
User-Agent: Opera Mail/11.50 (Linux)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 24 Aug 2011, Michal Nazarewicz wrote:
>> I'm actually wondering whether we really need to worry about it.
>> composite_driver has the “max_speed” field and I would just leave it as
>> composite driver's author responsibility to put correct value there.
>>
>> One thing that could be worth doing is iterate over all the  
>> configurations and figure out if at least one supports the speed
>> declared by “max_speed” and if not, lower it.

On Wed, 24 Aug 2011 16:31:27 +0200, Alan Stern <stern@rowland.harvard.edu>  
wrote:
> That's the same as what I said: Use the highest speed supported by any
> function driver.

Right.

>> Like I've said before, as additional functionality, composite.c could
>> check if it's USB_SPEED_UNKWONW in which case it would look for the  
>> lowest speed that all the functions support.

> It's reasonable.  Just be sure to document it properly; otherwise
> nobody will understand or remember it!

I've found where my reasoning was faulty.  The usb_gadget_driver's
max_speed is set before all the functions get added so composite.c has
no way to figure those things in advance.  That's why we need to relay
on usb_composite_driver's max_speed be set to a proper value.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
