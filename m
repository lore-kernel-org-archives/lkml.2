Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306Ab1HYMrE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 08:47:04 -0400
Received: from smtp-out.google.com ([216.239.44.51]:51374 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902Ab1HYMrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 08:47:00 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:content-type:to:cc:subject:references:date:
	mime-version:content-transfer-encoding:from:organization:message-id:
	in-reply-to:user-agent:x-system-of-record;
	b=CVGzp7jPBXkSa+Yo7knUoGjYjCMr1LhbUz+2tFjocgBDyeQYvIOywmWGcY4azBLsp
	8By9gUqxHCI1kHjW+OW5A==
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Felipe Balbi" <balbi@ti.com>
Cc: "Alan Stern" <stern@rowland.harvard.edu>,
        "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
        "Yang Rui Rui" <ruirui.r.yang@tieto.com>,
        "Dave Young" <hidave.darkstar@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 2/4] usb: gadget: replace "is_dualspeed" with
 "max_speed"
References: <Pine.LNX.4.44L0.1108241114270.2010-100000@iolanthe.rowland.org>
 <op.v0p439txvgw7ix@mnazarewicz-glaptop>
 <20110824230418.GA19890@legolas.emea.dhcp.ti.com>
Date: Thu, 25 Aug 2011 14:46:55 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mnazarewicz@google.com>
Organization: Google
Message-ID: <op.v0rsghexvgw7ix@mnazarewicz-glaptop>
In-Reply-To: <20110824230418.GA19890@legolas.emea.dhcp.ti.com>
User-Agent: Opera Mail/11.50 (Linux)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Aug 2011 01:04:19 +0200, Felipe Balbi <balbi@ti.com> wrote:
> there's one catch. As of today, we always start UDCs with data pullups
> connected, which means that we could connect to a host even before a
> gadget driver is loaded. My point in moving to udc_start/udc_stop is
> that the above would be take care of. See udc-core.c: [...]

Honestly I'm not quite sure why udc_start/udc_stop is needed here.  Even
without those the UDC driver can start with all hw disabled and turn it
on only after the gadget driver's bind callback finishes.

> If all UDCs are converted to udc_start()/udc_stop() we get the guarantee
> that they will only conect to host after gadget driver is fully loaded
> for free.

> We can also, finally, properly use the usb_function_deactivate/
> usb_function_activate properly. So for each registered function,
> composite.c calls usb_function_deactivate() and function is _required_
> to call usb_function_activate when it's ready.

I'm not really sure why that would be beneficial.  Also, it would still
require disconnect-connect cycle if some function decides to (de)activate
itself while gadget is connected.

> Then, when on gadget driver's bind() we can take this kind of speed
> decision and pass that on to UDC driver.

So can we leave things as they are for now and wait for UDCs to be  
converted
and once this is done, do all kinds of magic we want in copomiset's bind
callback?

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
