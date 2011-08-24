Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751137Ab1HXNLH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 09:11:07 -0400
Received: from smtp-out.google.com ([216.239.44.51]:34900 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab1HXNLE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 09:11:04 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:content-type:to:cc:subject:references:date:
	mime-version:content-transfer-encoding:from:organization:message-id:
	in-reply-to:user-agent:x-system-of-record;
	b=Dg5h/cHRctb461WB0ogPU32lrIro+GcLPeVqivO5dqRnGSmxsxbNqskOGlvUyz4eK
	SRrcqdkK5TYi3xNASjgww==
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Alan Stern" <stern@rowland.harvard.edu>
Cc: "Felipe Balbi" <balbi@ti.com>,
        "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
        "Yang Rui Rui" <ruirui.r.yang@tieto.com>,
        "Dave Young" <hidave.darkstar@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 2/4] usb: gadget: replace "is_dualspeed" with
 "max_speed"
References: <Pine.LNX.4.44L0.1108231636000.2069-100000@iolanthe.rowland.org>
Date: Wed, 24 Aug 2011 15:10:56 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mnazarewicz@google.com>
Organization: Google
Message-ID: <op.v0pywi0nvgw7ix@mnazarewicz-glaptop>
In-Reply-To: <Pine.LNX.4.44L0.1108231636000.2069-100000@iolanthe.rowland.org>
User-Agent: Opera Mail/11.50 (Linux)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Aug 2011 22:49:37 +0200, Alan Stern <stern@rowland.harvard.edu>  
wrote:
> Still, maybe I was wrong.  Maybe it would be better to use the fastest
> speed supported by at least one of the function drivers.  The user can
> always force a SuperSpeed-capable device to run at high speed by using
> a USB-2 cable to plug it in.  I'm not sure whether the user could force
> such a device to run at full speed, however.

I'm actually wondering whether we really need to worry about it.
composite_driver has the “max_speed” field and I would just leave it as
composite driver's author responsibility to put correct value there.

One thing that could be worth doing is iterate over all the configurations
and figure out if at least one supports the speed declared by “max_speed”
and if not, lower it.

Like I've said before, as additional functionality, composite.c could
check if it's USB_SPEED_UNKWONW in which case it would look for the lowest
speed that all the functions support.

Such configuration would allow composite driver authors set the speed to
USB_SPEED_SUPER when they mean “choose maximum speed at least one function
supports” and to “USB_SPEED_UNKWONW” when they mean “choose maximum speed
all the functions support”.

Does that make sense?

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
