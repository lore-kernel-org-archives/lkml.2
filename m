Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab1HTCee (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 22:34:34 -0400
Received: from netrider.rowland.org ([192.131.102.5]:37360 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751332Ab1HTCea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 22:34:30 -0400
Date: Fri, 19 Aug 2011 22:34:29 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Felipe Balbi <balbi@ti.com>
cc: Michal Nazarewicz <mnazarewicz@google.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Yang Rui Rui <ruirui.r.yang@tieto.com>,
        Dave Young <hidave.darkstar@gmail.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv3 3/4] usb: gadget: rename usb_gadget_driver::speed to
 max_speed
In-Reply-To: <20110819233133.GD13317@legolas.emea.dhcp.ti.com>
Message-ID: <Pine.LNX.4.44L0.1108192225120.18944-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Aug 2011, Felipe Balbi wrote:

> On Sat, Aug 20, 2011 at 12:33:01AM +0200, Michal Nazarewicz wrote:
> > From: Michal Nazarewicz <mina86@mina86.com>
> > 
> > This commit renames the “speed”	field of the usb_gadget_driver
> > structure to “max_speed”.  This is so that to make it more
> > apparent that the field represents the maximum speed gadget
> > driver can support.
> > 
> > This also make the field look more like fields with the same
> > name in usb_gadget and usb_composite_driver structures.  All
> > of those represent the *maximal* speed given entity supports.
> > 
> > After this commit, there are the following fields in various
> > structures:
> > * usb_gadget::speed - the current connection speed,
> > * usb_gadget::max_speed - maximal speed UDC supports,
> 
> this will be handled inside the UDC itself, so why do you need to expose
> it ?

I wondered about this too.  It turns out that sometimes the gadget
driver really does need to know about the maximum speed supported by
the UDC hardware and driver.

For example, suppose the gadget driver and the UDC both support high
speed, but the gadget is currently plugged into a USB-1.1 controller
and therefore running only at full speed.  Then the gadget driver has
to respond to the Get-Device-Qualifier and Get-Other-Speed-Config
requests by sending the appropriate descriptors.  But if the UDC
doesn't support high speed operation then the gadget driver has to
respond to those requests with a STALL.

Alan Stern

