Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab1HSMRp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 08:17:45 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47828 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab1HSMRn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 08:17:43 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Yang Rui Rui" <ruirui.r.yang@tieto.com>
Cc: "Alan Stern" <stern@rowland.harvard.edu>,
        "Sergei Shtylyov" <sshtylyov@mvista.com>,
        "Felipe Balbi" <balbi@ti.com>,
        "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
        "Yang Ruirui R" <ruirui.r.yang@tietoenator.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] usb: gadget: get rid of USB_GADGET_DUALSPEED and
 USB_GADGET_SUPERSPEED
References: <Pine.LNX.4.44L0.1108181055240.1912-100000@iolanthe.rowland.org>
 <op.v0e5q6pyvgw7ix@mnazarewicz-glaptop> <4E4DC418.8050009@tieto.com>
Date: Fri, 19 Aug 2011 14:17:40 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v0gm3q043l0zgt@mnazarewicz-glaptop>
In-Reply-To: <4E4DC418.8050009@tieto.com>
User-Agent: Opera Mail/11.50 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 08/19/2011 01:05 AM, Michal Nazarewicz wrote:
>> For the most part, usb_composite_probe() is called only once in module's
>> init function.  As far as I know, only g_ffs calls it several times.  So
>> in all cases expect for g_ffs, composite_driver.speed =
>> min(composite_driver.speed,
>> driver->max_speed) should have the same effect as composite_driver.speed
>> = driver->max_speed.

On Fri, 19 Aug 2011 04:02:00 +0200, Yang Rui Rui <ruirui.r.yang@tieto.com>  
wrote:
> For original code, ifndef CONFIG_USB_GADGET_SUPERSPEED and max_speed =  
> USB_SPEED_SUPER then the result will be:
>
> composite_driver.speed = min(USB_SPEED_HIGH, USB_SPEED_SUPER)
>
> For patched code, composite_driver.speed = USB_SPEED_SUPER

OK, I see your point.  This is the issue that we are discussing in another
“branch” of the thread.  It seems either usb_gadget_driver_probe() should
make sure driver->speed is not too high or each UDC need to handle gadgets
which support speed higher then the UDC can handle.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
