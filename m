Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172Ab0CYQpT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 12:45:19 -0400
Received: from lucidpixels.com ([75.144.35.66]:34502 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047Ab0CYQpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 12:45:17 -0400
Date: Thu, 25 Mar 2010 12:45:15 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Alan Stern <stern@rowland.harvard.edu>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, Alan Piszcz <ap@solarrain.com>
Subject: Re: 2.6.33: Xorg+khubd lockup (D-state) BUG / ioctl EVIOCGNAME
 failed: Inappropriate ioctl for device / PreInit returned NULL
In-Reply-To: <Pine.LNX.4.44L0.1003251149300.1808-100000@iolanthe.rowland.org>
Message-ID: <alpine.DEB.2.00.1003251240590.27738@p34.internal.lan>
References: <Pine.LNX.4.44L0.1003251149300.1808-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 25 Mar 2010, Alan Stern wrote:

> On Thu, 25 Mar 2010, Justin Piszcz wrote:
> 
> > # cat /sys/kernel/debug/usb/devices
> > 
> > T:  Bus=02 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh= 8
> > B:  Alloc= 26/900 us ( 3%), #Int=  2, #Iso=  0
> > D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
> > P:  Vendor=1d6b ProdID=0001 Rev= 2.06
> > S:  Manufacturer=Linux 2.6.33 ohci_hcd
> > S:  Product=OHCI Host Controller
> > S:  SerialNumber=0000:00:0b.0
> > C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
> > I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
> > E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms
> > 
> > T:  Bus=02 Lev=01 Prnt=01 Port=04 Cnt=01 Dev#=  2 Spd=1.5 MxCh= 0
> > D:  Ver= 1.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
> > P:  Vendor=413c ProdID=2005 Rev= 1.05
> > S:  Manufacturer=DELL
> > S:  Product=DELL USB Keyboard
> > C:* #Ifs= 1 Cfg#= 1 Atr=a0 MxPwr=100mA
> > I:* If#= 0 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=01 Prot=01 Driver=usbhid
> > E:  Ad=81(I) Atr=03(Int.) MxPS=   8 Ivl=10ms
> > 
> > T:  Bus=02 Lev=01 Prnt=01 Port=05 Cnt=02 Dev#=  3 Spd=1.5 MxCh= 0
> > D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
> > P:  Vendor=046d ProdID=c018 Rev=43.01
> > S:  Manufacturer=Logitech
> > S:  Product=USB Optical Mouse
> > C:* #Ifs= 1 Cfg#= 1 Atr=a0 MxPwr=100mA
> > I:* If#= 0 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=01 Prot=02 Driver=usbhid
> > E:  Ad=81(I) Atr=03(Int.) MxPS=   5 Ivl=10ms
> 
> All right, the problematic mouse is attached to bus 2 (as is the
> keyboard).  So the next step is to run a kernel with CONFIG_USB_DEBUG
> enabled.  When the mouse stops working, go to
> /sys/kernel/debug/usb/ohci/0000:00:0b.0 and see what the various files
> in that directory contain.  Also, check if any additional debugging 
> info shows up in the system log.

Ok, done, it froze up again:

# cat async 
#

# cat periodic 
size = 32
  0 [117]: ed8/f674a040 (ls dev2 ep1in-int qlen 1 max 8 00083082)
  1 [ 98]: ed8/f674a0c0 (ls dev3 ep1in-int qlen 1 max 5 00053083)
  8 [117]: ed8/f674a040
  9 [ 98]: ed8/f674a0c0
16 [117]: ed8/f674a040
17 [ 98]: ed8/f674a0c0
24 [117]: ed8/f674a040
25 [ 98]: ed8/f674a0c0

# cat registers 
bus pci, device 0000:00:0b.0
OHCI Host Controller
ohci_hcd
OHCI 1.0, NO legacy support registers
control 0x68f RWE RWC HCFS=operational IE PLE CBSR=3
cmdstatus 0x00000 SOC=0
intrstatus 0x00000024 FNO SF
intrenable 0x8000004a MIE RHSC RD WDH
ed_controlhead 3674a080
hcca frame 0x61e7
fmintvl 0xa7782edf FIT FSMPS=0xa778 FI=0x2edf
fmremaining 0x80002565 FRT FR=0x2565
periodicstart 0x2a2f
lsthresh 0x0628
hub poll timer off
roothub.a 01000208 POTPGT=1 NPS NDP=8(8)
roothub.b 00000000 PPCM=0000 DR=0000
roothub.status 00008000 DRWE
roothub.portstatus [0] 0x00000100 PPS
roothub.portstatus [1] 0x00000100 PPS
roothub.portstatus [2] 0x00000100 PPS
roothub.portstatus [3] 0x00000100 PPS
roothub.portstatus [4] 0x00000303 LSDA PPS PES CCS
roothub.portstatus [5] 0x00000303 LSDA PPS PES CCS
roothub.portstatus [6] 0x00000100 PPS
roothub.portstatus [7] 0x00000100 PPS

Nothing unusal in dmesg:

[   30.569377] usb 2-5:1.0: uevent
[   30.572365] usb 2-6:1.0: uevent
[ 1053.663314] usb usb1: uevent
[ 1053.663404] usb 1-0:1.0: uevent
[ 1053.663455] usb usb2: uevent
[ 1053.663530] usb 2-0:1.0: uevent
[ 1053.663582] usb 2-5: uevent
[ 1053.663656] usb 2-5:1.0: uevent
[ 1053.663706] usb 2-6: uevent
[ 1053.663777] usb 2-6:1.0: uevent
<ends here>

Anything else worth gathering?
Does the above output show the problem?

BTW this keyboard and mouse were used on another system for 4+ years without
any problems, so it is not a device issue.

Justin.



> 
> > > Suppose you don't run X at all.  Do the mouse and keyboard eventually
> > > stop working even then?
> > I have not tried that, the reason I use the host locally is for X.
> 
> You should try it anyway.  If the failure still occurs, then you can 
> rule out any connection with X or the nVidia graphics.
It takes a very long time for it to happen when I want it to happen, but
if the above output does not help/this bug cannot be found/fixed, I can try
that too.

Justin.

