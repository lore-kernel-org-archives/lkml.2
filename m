Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758330Ab0JUOCN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 10:02:13 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42206 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757567Ab0JUOCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 10:02:12 -0400
Date: Thu, 21 Oct 2010 10:02:10 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
cc: Brokhman Tatyana <tlinder@codeaurora.org>, <linux-usb@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/PATCH 2/2] usb: Adding SuperSpeed support to dummy_hcd
In-Reply-To: <20101020234346.GA2634@xanatos>
Message-ID: <Pine.LNX.4.44L0.1010210949100.1718-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Oct 2010, Sarah Sharp wrote:

> > For testing purposes, it is best to imitate the behavior of a real 
> > device as closely as possible.  USB-2.0 host controllers do not assign 
> > their own addresses to devices; they use the addresses provided by 
> > usbcore.  I think this is also true for the low/full/high-speed 
> > components of a USB-3.0 controller.
> 
> There is only one controller, the xHCI controller, that handles all
> device speeds.  There are no companion controllers for a USB 3.0 host
> controller.  The xHCI host controller uses the hardware assigned address
> for all devices (LS/FS/HS/SS), not the usbcore address.

I stand corrected.

> But I'll admit I don't understand what dummy-hcd is supposed to do, so

dummy-hcd is a virtual host controller/device controller combination.  
The virtual host controller has only one port, which is connected to
the virtual device controller.  The same computer acts as both host and
gadget.  The purpose is to allow testing of gadget drivers without the
need for device-controller hardware.

> I'm a bit confused as to why it needs an address_device function.  Is it
> supposed to be the gadget-side interface to the hardware that's
> transmitting over USB (i.e. responding to the USB host)?  Or does it
> have something to do with a gadget switching over to host mode for OTG?

In fact, dummy-hcd doesn't need or use the device address at all.  And
it doesn't support OTG.

Alan Stern

