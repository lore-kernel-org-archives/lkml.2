Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438Ab0CYPxw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 11:53:52 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:52231 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750827Ab0CYPxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 11:53:51 -0400
Date: Thu, 25 Mar 2010 11:53:50 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, Alan Piszcz <ap@solarrain.com>
Subject: Re: 2.6.33: Xorg+khubd lockup (D-state) BUG / ioctl EVIOCGNAME
 failed: Inappropriate ioctl for device / PreInit returned NULL
In-Reply-To: <alpine.DEB.2.00.1003251023400.22668@p34.internal.lan>
Message-ID: <Pine.LNX.4.44L0.1003251149300.1808-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Mar 2010, Justin Piszcz wrote:

> # cat /sys/kernel/debug/usb/devices
> 
> T:  Bus=02 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh= 8
> B:  Alloc= 26/900 us ( 3%), #Int=  2, #Iso=  0
> D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
> P:  Vendor=1d6b ProdID=0001 Rev= 2.06
> S:  Manufacturer=Linux 2.6.33 ohci_hcd
> S:  Product=OHCI Host Controller
> S:  SerialNumber=0000:00:0b.0
> C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
> I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
> E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms
> 
> T:  Bus=02 Lev=01 Prnt=01 Port=04 Cnt=01 Dev#=  2 Spd=1.5 MxCh= 0
> D:  Ver= 1.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
> P:  Vendor=413c ProdID=2005 Rev= 1.05
> S:  Manufacturer=DELL
> S:  Product=DELL USB Keyboard
> C:* #Ifs= 1 Cfg#= 1 Atr=a0 MxPwr=100mA
> I:* If#= 0 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=01 Prot=01 Driver=usbhid
> E:  Ad=81(I) Atr=03(Int.) MxPS=   8 Ivl=10ms
> 
> T:  Bus=02 Lev=01 Prnt=01 Port=05 Cnt=02 Dev#=  3 Spd=1.5 MxCh= 0
> D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
> P:  Vendor=046d ProdID=c018 Rev=43.01
> S:  Manufacturer=Logitech
> S:  Product=USB Optical Mouse
> C:* #Ifs= 1 Cfg#= 1 Atr=a0 MxPwr=100mA
> I:* If#= 0 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=01 Prot=02 Driver=usbhid
> E:  Ad=81(I) Atr=03(Int.) MxPS=   5 Ivl=10ms

All right, the problematic mouse is attached to bus 2 (as is the
keyboard).  So the next step is to run a kernel with CONFIG_USB_DEBUG
enabled.  When the mouse stops working, go to
/sys/kernel/debug/usb/ohci/0000:00:0b.0 and see what the various files
in that directory contain.  Also, check if any additional debugging 
info shows up in the system log.

> > Suppose you don't run X at all.  Do the mouse and keyboard eventually
> > stop working even then?
> I have not tried that, the reason I use the host locally is for X.

You should try it anyway.  If the failure still occurs, then you can 
rule out any connection with X or the nVidia graphics.

Alan Stern

