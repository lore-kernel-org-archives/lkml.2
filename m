Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786Ab1HWPat (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 11:30:49 -0400
Received: from smtp-out.google.com ([74.125.121.67]:39690 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736Ab1HWPal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 11:30:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:content-type:cc:references:subject:to:date:
	mime-version:content-transfer-encoding:from:organization:message-id:
	in-reply-to:user-agent:x-system-of-record;
	b=I01nFNgGRZujusUSty76Fp9cYVY0lXeNEj6novkEAM5kq1v2AVVstB4egvor4LlLo
	S7SJbqMCMaPaqEpQTfm5Q==
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Cc: "Alan Stern" <stern@rowland.harvard.edu>,
        "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
        "Yang Rui Rui" <ruirui.r.yang@tieto.com>,
        "Dave Young" <hidave.darkstar@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1313791722.git.mina86@mina86.com>
 <accba3196fa1fe04f6110b350c03488acb785abe.1313791722.git.mina86@mina86.com>
 <20110819232805.GC13317@legolas.emea.dhcp.ti.com>
 <op.v0n5y4o0vgw7ix@mnazarewicz-glaptop>
 <20110823135817.GJ1341@legolas.emea.dhcp.ti.com>
 <op.v0n67imkvgw7ix@mnazarewicz-glaptop>
 <20110823150547.GN1341@legolas.emea.dhcp.ti.com>
Subject: Re: [PATCHv3 2/4] usb: gadget: replace "is_dualspeed" with
 "max_speed"
To: "Felipe Balbi" <balbi@ti.com>
Date: Tue, 23 Aug 2011 17:30:36 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mnazarewicz@google.com>
Organization: Google
Message-ID: <op.v0oapawkvgw7ix@mnazarewicz-glaptop>
In-Reply-To: <20110823150547.GN1341@legolas.emea.dhcp.ti.com>
User-Agent: Opera Mail/11.50 (Linux)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> On Tue, 23 Aug 2011 15:58:17 +0200, Felipe Balbi <balbi@ti.com> wrote:
>>> All of the speed negotiation between composite.c and f_*.c should  
>>> happen before even connecting to host

> On Tue, Aug 23, 2011 at 04:15:08PM +0200, Michal Nazarewicz wrote:
>> Yep, obviously.  The usb_gadget_probe_driver() is called at the very and
>> once all the functions and everything is added so composite.c can do all
>> the analysis it wants and figure out the maximum speed.
>>
>> >(before attaching data pullups, enabling IRQs, etc), that's exactly why
>> >me and Sebastian have decided (at that time off list) to add
>> >udc_start()/udc_stop() methods.
>>
>> I don't really follow why those would be needed...

On Tue, 23 Aug 2011 17:05:48 +0200, Felipe Balbi <balbi@ti.com> wrote:
> Ok, I guess I need to give the full picture here, my bad.
>
> Let's say you have a SuperSpeed controller, but you know that this
> particular gadget driver can only support fullspeed, so why do you need
> to go through RX detection, HS chirp sequence and whatnot if you can
> decide the maximum_speed before kickstarting the UDC's state machine ?

But isn't that what's happening right now?  The gadget_driver structure
has a speed field which is set to the maximum speed the gadget driver
can handle.  Only after this is set, usb_gadget_probe_driver() is
called so at this point a SS UDC can figure out whether it needs to
turn pieces needed for SS support or not.


>>> you already maximum_speed (below) and speed alone looses some extra
>>> hint of what kind of information will be there. I think it's better to
>>> change this to current_speed and make a symbolic link called 'speed'
>>> which we can keep for the next 5 years and remove it in e.g. Linux v5.0
>>
>> OK, I'll do that (as soon as I figure out/recall how to make symlinks  
>> that is ;) ).

> yeah, I would have to go through the same re-education ;-)

Adding another attribute with the same show function seems easy, but
that's probably not elegant. ;)

> (please add a note on feature-removal-schedule too)

Yep!

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
