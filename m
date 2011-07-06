Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab1GFOkM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 10:40:12 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:40895 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753235Ab1GFOkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 10:40:10 -0400
Date: Wed, 6 Jul 2011 10:40:10 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>,
        Alan Piszcz <ap@solarrain.com>
Subject: Re: 2.6.39.2: usb kernel panic/oops: schedule+ehci_irq+0x266/0x830
In-Reply-To: <alpine.DEB.2.02.1107051742290.3983@p34.internal.lan>
Message-ID: <Pine.LNX.4.44L0.1107061036190.1995-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jul 2011, Justin Piszcz wrote:

> Hi,
> 
> I plan to build a new machine in the future (one with console access) but 
> in the meantime, after my PSU replacement, the host is still having 
> issues, I've turned off bluetooth wireless (built into the DP55KG) and 
> will see if it panics again, link the latest panic/oops/etc:
> 
> http://home.comcast.net/~jpiszcz/20110705/IMG_2875.JPG
> 
> schedule+0x266/0x830
> common_interrupt+0xe/0x13
> ehci_irq+0x20f/0x230

You need to enable CONFIG_FRAME_POINTER; without that it is difficult 
to interpret the stack dump.  Also you should collect more than a 
single screen's worth of information, say by using a serial console or 
netconsole.

> Is this a valid kernel bug?

What's the difference between a "valid" kernel bug and an "invalid" 
kernel bug?  :-)

Yes, clearly it is a bug in the kernel.

> I have another box (diff MOBO and all running 2.6.39.x no issues) but it 
> does not have built-in bluetooth, I am also running a USB (non-winmodem) 
> on this host as well, can anyone comment on this?
> 
>   16:      70587          0          0          0          0          0 
> 11675          0   IO-APIC-fasteoi   ehci_hcd:usb1
> 
> Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 001 Device 002: ID 8087:0020 Intel Corp. Integrated Rate Matching Hub
> Bus 002 Device 002: ID 8087:0020 Intel Corp. Integrated Rate Matching Hub
> Bus 001 Device 003: ID 2001:f103 D-Link Corp. DUB-H7 7-port USB 2.0 hub
> Bus 001 Device 004: ID 0baf:0303 U.S. Robotics
> Bus 001 Device 005: ID 0764:0501 Cyber Power System, Inc. CP1500 AVR UPS
> Bus 001 Device 006: ID 413c:1002 Dell Computer Corp. Keyboard Hub
> Bus 001 Device 007: ID 067b:2303 Prolific Technology, Inc. PL2303 Serial Port
> Bus 001 Device 008: ID 413c:2002 Dell Computer Corp. SK-8125 Keyboard
> Bus 001 Device 009: ID 0461:4d15 Primax Electronics, Ltd Dell Optical Mouse
> 
> I also use munin to poll the UPS for various information, could this be a 
> bug in the USB driver for this chipset/motherboard?
> 
> Can polling various USB devices, running a hylafax server, etc, cause a 
> bug to pop up more easily in the USB subsystem vs. just using a keyboard 
> for example, I assume so?

This could any of a number of things.  More information is needed.

If the problem is easily reproducible, you can use git bisect to pin 
down the commit responsible for exposing the bug.

Alan Stern

