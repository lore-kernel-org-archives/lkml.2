Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab1HXNDw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 09:03:52 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58145 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226Ab1HXNDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 09:03:50 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Felipe Balbi" <balbi@ti.com>
Cc: "Alan Stern" <stern@rowland.harvard.edu>,
        "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
        "Yang Rui Rui" <ruirui.r.yang@tieto.com>,
        "Dave Young" <hidave.darkstar@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 1/4] usb: Provide usb_speed_string() function
References: <Pine.LNX.4.44L0.1108221705040.2192-100000@iolanthe.rowland.org>
 <op.v0mv05vu3l0zgt@mnazarewicz-glaptop>
 <20110824085738.GE12549@legolas.emea.dhcp.ti.com>
Date: Wed, 24 Aug 2011 14:59:33 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v0pydjk33l0zgt@mnazarewicz-glaptop>
In-Reply-To: <20110824085738.GE12549@legolas.emea.dhcp.ti.com>
User-Agent: Opera Mail/11.50 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Aug 2011 10:57:39 +0200, Felipe Balbi <balbi@ti.com> wrote:

> Hi,
>
> On Mon, Aug 22, 2011 at 11:16:07PM +0200, Michal Nazarewicz wrote:
>> >>>>+obj-$(CONFIG_USB)		+= common.o
>> >>>>+obj-$(CONFIG_USB_GADGET)	+= common.o
>>
>> >>>Will this cause problems?  For example, what if CONFIG_USB is Y and
>> >>>CONFIG_USB_GADGET is M?
>>
>> >>>Also, it seems a little silly to have an entire kernel module devoted
>> >>>to a single, little function.
>>
>> On Mon, 22 Aug 2011 23:06:43 +0200, Alan Stern
>> <stern@rowland.harvard.edu> wrote:
>> >You could do:
>> >
>> >	obj-$(CONFIG_USB_SUPPORT)  += common.o
>> >
>> >which would build that subroutine into the main kernel whenever either
>> >side of the USB stack is enabled.
>>
>> OK.  I'll wait for any more possible comments and post changed version
>> by the end of the week.
>
> if it's only for one single function, wouldn't a static inline in a
> common header do ?

That would defeat the purpose a little.  The code would not get duplicated
in many source files but the actual compiled code would end up in several
places.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
