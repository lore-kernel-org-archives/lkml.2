Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917Ab1EBVGV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 17:06:21 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:60040 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754587Ab1EBVGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 17:06:19 -0400
Date: Mon, 2 May 2011 17:06:19 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Adi J. Sieker" <adi@core.adi.io>
cc: Oliver Neukum <oliver@neukum.org>, USB list <linux-usb@vger.kernel.org>,
        <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: USB keyboard recognized as HID keyboard but doesn't work
In-Reply-To: <4DBF16D8.8040209@sieker.io>
Message-ID: <Pine.LNX.4.44L0.1105021657440.2106-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 May 2011, Adi J. Sieker wrote:

> Attached is the usbmon trace when I plug the keyboard in.
> 
> lsusb shows the keyboard as:
> Bus 002 Device 008: ID 060b:0230 Solid Year
> 
> Relevant section from /sys/kernel/debug/usb/devices
> T:  Bus=02 Lev=02 Prnt=02 Port=00 Cnt=01 Dev#=  8 Spd=1.5 MxCh= 0
> D:  Ver= 1.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
> P:  Vendor=060b ProdID=0230 Rev= 2.20
> S:  Manufacturer=KB
> S:  Product=USB Keyboard
> C:* #Ifs= 2 Cfg#= 1 Atr=a0 MxPwr=100mA
> I:* If#= 0 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=01 Prot=01 Driver=usbhid
> E:  Ad=81(I) Atr=03(Int.) MxPS=   8 Ivl=10ms
> I:* If#= 1 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=00 Prot=00 Driver=usbhid
> E:  Ad=82(I) Atr=03(Int.) MxPS=   8 Ivl=10ms

Interestingly, the usbmon trace shows that the interrupt endpoint for
interface 1 isn't being used by usbhid.  I don't know why, but it
shouldn't make much difference for your purposes since that interface
appears to be associated with the gaming interface.  But maybe I'm
wrong and it is important somehow...

The other noticeable thing is that the keyboard didn't accept the 
Set-Idle request for interface 1.

You said before that the keyboard worked okay when driven by a guest 
Windows OS, right?  Can you collect an equivalent usbmon trace for 
that?  Comparing the two traces may be instructive.

Alan Stern

