Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406Ab1HSO5f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 10:57:35 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35909 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751832Ab1HSO5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 10:57:33 -0400
Date: Fri, 19 Aug 2011 10:57:32 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Michal Nazarewicz <mina86@mina86.com>
cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Sergei Shtylyov <sshtylyov@mvista.com>, Felipe Balbi <balbi@ti.com>,
        Yang Rui Rui <ruirui.r.yang@tieto.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] usb: gadget: get rid of USB_GADGET_DUALSPEED and
 USB_GADGET_SUPERSPEED
In-Reply-To: <op.v0gtmri13l0zgt@mnazarewicz-glaptop>
Message-ID: <Pine.LNX.4.44L0.1108191051150.2016-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Aug 2011, Michal Nazarewicz wrote:

> > I don't quite understand that sentence.  However, it is definitely true
> > that all UDC drivers _must_ avoid connecting at speeds that are faster
> > than the usb_gadget_driver's .speed field.
> 
> Yang has brought up an issue that musb_gadget_start() checks if  
> driver->speed
> equals USB_SPEED_HIGH.  This means that if a gadget driver supports super  
> speed
> it'll set driver->speed to USB_SPEED_SUPER and musb_gadget_start() will  
> complain.
> 
> My understanding is that this is a bug in musb driver as it should allow  
> the
> gadget driver to start but never set super speed.

That's right.  It should also allow driver->speed to be USB_SPEED_FULL, 
in which case it should never connect at high speed (see gmidi.c).

Alan Stern

