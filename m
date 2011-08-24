Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892Ab1HXPZV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 11:25:21 -0400
Received: from smtp-out.google.com ([216.239.44.51]:30911 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab1HXPZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 11:25:17 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:content-type:to:cc:subject:references:
	mime-version:content-transfer-encoding:from:organization:date:message-id:
	in-reply-to:user-agent:x-system-of-record;
	b=kr0rDTiQiHKjiW9cUS5CnCwK3FWIMc8zmgkFw2/4pwM2UXn1AKX3NcdhftdNB3QlF
	9wod8LICQcqB+d04IhcmQ==
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Alan Stern" <stern@rowland.harvard.edu>
Cc: "Felipe Balbi" <balbi@ti.com>,
        "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
        "Yang Rui Rui" <ruirui.r.yang@tieto.com>,
        "Dave Young" <hidave.darkstar@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 2/4] usb: gadget: replace "is_dualspeed" with
 "max_speed"
References: <Pine.LNX.4.44L0.1108241114270.2010-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mnazarewicz@google.com>
Organization: Google
Date: Wed, 24 Aug 2011 17:25:11 +0200
Message-ID: <op.v0p439txvgw7ix@mnazarewicz-glaptop>
In-Reply-To: <Pine.LNX.4.44L0.1108241114270.2010-100000@iolanthe.rowland.org>
User-Agent: Opera Mail/11.50 (Linux)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Aug 2011 17:15:29 +0200, Alan Stern <stern@rowland.harvard.edu>  
wrote:

> On Wed, 24 Aug 2011, Michal Nazarewicz wrote:
>
>> I've found where my reasoning was faulty.  The usb_gadget_driver's
>> max_speed is set before all the functions get added so composite.c has
>> no way to figure those things in advance.  That's why we need to relay
>> on usb_composite_driver's max_speed be set to a proper value.
>
> This is what Felipe was complaining about earlier.  We shouldn't set
> max_speed or allow the UDC to connect to the host until all the
> functions have been added.

We're not doing the latter.  The functions are added in bind callback so
(hopefully) UDC will first run the bind callback and then try connecting
to host.

And the former would be fixed if we allowed gadget driver to set max_speed
in bind callback rather then prior to calling usb_gadget_probe_driver().

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
