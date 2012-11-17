Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828Ab2KQMgU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 07:36:20 -0500
Received: from pindarots.xs4all.nl ([80.101.128.228]:42299 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab2KQMgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 07:36:19 -0500
Message-ID: <50A7849C.6080502@xs4all.nl>
Date: Sat, 17 Nov 2012 13:35:40 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: linux-usb@vger.kernel.org
CC: Alan Stern <stern@rowland.harvard.edu>,
        Jan Ceuleers <jan.ceuleers@computer.org>,
        Clemens Ladisch <clemens@ladisch.de>,
        Simon Jones <sijones2010@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: 3.4.4: disabling irq
References: <Pine.LNX.4.44L0.1207151423440.29236-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1207151423440.29236-100000@netrider.rowland.org>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-07-15 20:28, Alan Stern wrote:
> Um, I think you missed the point.  The whole idea of the test is to see 
> what happens while the controller is unbound from the driver.  Binding 
> it again defeats the purpose.

The problem still happens. irq 18 is dsiabled every now and then.
This time on different, new hardware.
The motherboard is now a Gigabyte F2A85X-UP4.
Camera is the same pwc cam.

Recently I removed the USB printer that was attached to the same USB
controller.
So probably it is not a hardware issue related to board or printer.

How to proceed next?

Udo




PS: Info captured soon after one occurrence:

# cat /sys/kernel/debug/usb/ohci/*/registers
bus pci, device 0000:00:12.0
OHCI Host Controller
ohci_hcd
OHCI 1.0, NO legacy support registers, rh state running
control 0x08f HCFS=operational IE PLE CBSR=3
cmdstatus 0x00000 SOC=0
intrstatus 0x00000024 FNO SF
intrenable 0x8000005a MIE RHSC UE RD WDH
ed_controlhead 00004000
hcca frame 0x6ed9
fmintvl 0xa7782edf FIT FSMPS=0xa778 FI=0x2edf
fmremaining 0x800005fa FRT FR=0x05fa
periodicstart 0x2a2f
lsthresh 0x0628
hub poll timer off
roothub.a 02001205 POTPGT=2 NOCP NPS NDP=5(5)
roothub.b 00000000 PPCM=0000 DR=0000
roothub.status 00008000 DRWE
roothub.portstatus [0] 0x00000100 PPS
roothub.portstatus [1] 0x00000303 LSDA PPS PES CCS
roothub.portstatus [2] 0x00000100 PPS
roothub.portstatus [3] 0x00000100 PPS
roothub.portstatus [4] 0x00000100 PPS
bus pci, device 0000:00:13.0
OHCI Host Controller
ohci_hcd
OHCI 1.0, NO legacy support registers, rh state running
control 0x08f HCFS=operational IE PLE CBSR=3
cmdstatus 0x00000 SOC=0
intrstatus 0x00000026 FNO SF WDH
intrenable 0x8000005a MIE RHSC UE RD WDH
ed_controlhead 00004000
hcca frame 0x6e9d
fmintvl 0xa7782edf FIT FSMPS=0xa778 FI=0x2edf
fmremaining 0x80001fcf FRT FR=0x1fcf
periodicstart 0x2a2f
lsthresh 0x0628
hub poll timer off
roothub.a 02001205 POTPGT=2 NOCP NPS NDP=5(5)
roothub.b 00000000 PPCM=0000 DR=0000
roothub.status 00008000 DRWE
roothub.portstatus [0] 0x00000100 PPS
roothub.portstatus [1] 0x00000100 PPS
roothub.portstatus [2] 0x00000100 PPS
roothub.portstatus [3] 0x00000103 PPS PES CCS
roothub.portstatus [4] 0x00000100 PPS
bus pci, device 0000:00:14.5
OHCI Host Controller
ohci_hcd
OHCI 1.0, NO legacy support registers, rh state running
control 0x083 HCFS=operational CBSR=3
cmdstatus 0x00000 SOC=0
intrstatus 0x00000024 FNO SF
intrenable 0x8000005a MIE RHSC UE RD WDH
hcca frame 0x6e61
fmintvl 0xa7782edf FIT FSMPS=0xa778 FI=0x2edf
fmremaining 0x80000cd8 FRT FR=0x0cd8
periodicstart 0x2a2f
lsthresh 0x0628
hub poll timer off
roothub.a 02001202 POTPGT=2 NOCP NPS NDP=2(2)
roothub.b 00000000 PPCM=0000 DR=0000
roothub.status 00008000 DRWE
roothub.portstatus [0] 0x00000100 PPS
roothub.portstatus [1] 0x00000100 PPS
# cat /sys/kernel/debug/usb/devices

T:  Bus=11 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=5000 MxCh= 2
B:  Alloc=  0/800 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 3.00 Cls=09(hub  ) Sub=00 Prot=03 MxPS= 9 #Cfgs=  1
P:  Vendor=1d6b ProdID=0003 Rev= 3.06
S:  Manufacturer=Linux 3.6.6 xhci_hcd
S:  Product=xHCI Host Controller
S:  SerialNumber=0000:02:00.0
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=256ms

T:  Bus=10 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=480  MxCh= 2
B:  Alloc=  0/800 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 2.00 Cls=09(hub  ) Sub=00 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=1d6b ProdID=0002 Rev= 3.06
S:  Manufacturer=Linux 3.6.6 xhci_hcd
S:  Product=xHCI Host Controller
S:  SerialNumber=0000:02:00.0
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=256ms

T:  Bus=09 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=5000 MxCh= 2
B:  Alloc=  0/800 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 3.00 Cls=09(hub  ) Sub=00 Prot=03 MxPS= 9 #Cfgs=  1
P:  Vendor=1d6b ProdID=0003 Rev= 3.06
S:  Manufacturer=Linux 3.6.6 xhci_hcd
S:  Product=xHCI Host Controller
S:  SerialNumber=0000:00:10.1
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=256ms

T:  Bus=08 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=480  MxCh= 2
B:  Alloc=  0/800 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 2.00 Cls=09(hub  ) Sub=00 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=1d6b ProdID=0002 Rev= 3.06
S:  Manufacturer=Linux 3.6.6 xhci_hcd
S:  Product=xHCI Host Controller
S:  SerialNumber=0000:00:10.1
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=256ms

T:  Bus=07 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=5000 MxCh= 2
B:  Alloc=  0/800 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 3.00 Cls=09(hub  ) Sub=00 Prot=03 MxPS= 9 #Cfgs=  1
P:  Vendor=1d6b ProdID=0003 Rev= 3.06
S:  Manufacturer=Linux 3.6.6 xhci_hcd
S:  Product=xHCI Host Controller
S:  SerialNumber=0000:00:10.0
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=256ms

T:  Bus=06 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=480  MxCh= 2
B:  Alloc=  0/800 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 2.00 Cls=09(hub  ) Sub=00 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=1d6b ProdID=0002 Rev= 3.06
S:  Manufacturer=Linux 3.6.6 xhci_hcd
S:  Product=xHCI Host Controller
S:  SerialNumber=0000:00:10.0
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=256ms

T:  Bus=05 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=480  MxCh= 5
B:  Alloc=  0/800 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 2.00 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1d6b ProdID=0002 Rev= 3.06
S:  Manufacturer=Linux 3.6.6 ehci_hcd
S:  Product=EHCI Host Controller
S:  SerialNumber=0000:00:13.2
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=256ms

T:  Bus=04 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=480  MxCh= 5
B:  Alloc=  0/800 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 2.00 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1d6b ProdID=0002 Rev= 3.06
S:  Manufacturer=Linux 3.6.6 ehci_hcd
S:  Product=EHCI Host Controller
S:  SerialNumber=0000:00:12.2
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=256ms

T:  Bus=03 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12   MxCh= 2
B:  Alloc=  0/900 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1d6b ProdID=0001 Rev= 3.06
S:  Manufacturer=Linux 3.6.6 ohci_hcd
S:  Product=OHCI Host Controller
S:  SerialNumber=0000:00:14.5
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms

T:  Bus=02 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12   MxCh= 5
B:  Alloc=757/900 us (84%), #Int=  0, #Iso=  3
D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1d6b ProdID=0001 Rev= 3.06
S:  Manufacturer=Linux 3.6.6 ohci_hcd
S:  Product=OHCI Host Controller
S:  SerialNumber=0000:00:13.0
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms

T:  Bus=02 Lev=01 Prnt=01 Port=03 Cnt=01 Dev#=  2 Spd=12   MxCh= 0
D:  Ver= 1.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
P:  Vendor=0471 ProdID=0311 Rev= 0.03
S:  SerialNumber=01690000A5000000
C:* #Ifs= 3 Cfg#= 1 Atr=a0 MxPwr=500mA
I:  If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=Philips webcam
E:  Ad=82(I) Atr=03(Int.) MxPS=   1 Ivl=32ms
E:  Ad=85(I) Atr=01(Isoc) MxPS=   0 Ivl=1ms
I:  If#= 0 Alt= 1 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=Philips webcam
E:  Ad=82(I) Atr=03(Int.) MxPS=   1 Ivl=32ms
E:  Ad=85(I) Atr=01(Isoc) MxPS= 196 Ivl=1ms
I:  If#= 0 Alt= 2 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=Philips webcam
E:  Ad=82(I) Atr=03(Int.) MxPS=   1 Ivl=32ms
E:  Ad=85(I) Atr=01(Isoc) MxPS= 292 Ivl=1ms
I:  If#= 0 Alt= 3 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=Philips webcam
E:  Ad=82(I) Atr=03(Int.) MxPS=   1 Ivl=32ms
E:  Ad=85(I) Atr=01(Isoc) MxPS= 448 Ivl=1ms
I:  If#= 0 Alt= 4 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=Philips webcam
E:  Ad=82(I) Atr=03(Int.) MxPS=   1 Ivl=32ms
E:  Ad=85(I) Atr=01(Isoc) MxPS= 592 Ivl=1ms
I:  If#= 0 Alt= 5 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=Philips webcam
E:  Ad=82(I) Atr=03(Int.) MxPS=   1 Ivl=32ms
E:  Ad=85(I) Atr=01(Isoc) MxPS= 704 Ivl=1ms
I:  If#= 0 Alt= 6 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=Philips webcam
E:  Ad=82(I) Atr=03(Int.) MxPS=   1 Ivl=32ms
E:  Ad=85(I) Atr=01(Isoc) MxPS= 776 Ivl=1ms
I:  If#= 0 Alt= 7 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=Philips webcam
E:  Ad=82(I) Atr=03(Int.) MxPS=   1 Ivl=32ms
E:  Ad=85(I) Atr=01(Isoc) MxPS= 840 Ivl=1ms
I:  If#= 0 Alt= 8 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=Philips webcam
E:  Ad=82(I) Atr=03(Int.) MxPS=   1 Ivl=32ms
E:  Ad=85(I) Atr=01(Isoc) MxPS= 896 Ivl=1ms
I:* If#= 0 Alt= 9 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=Philips webcam
E:  Ad=82(I) Atr=03(Int.) MxPS=   1 Ivl=32ms
E:  Ad=85(I) Atr=01(Isoc) MxPS= 960 Ivl=1ms
I:  If#= 0 Alt=10 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=Philips webcam
E:  Ad=82(I) Atr=03(Int.) MxPS=   1 Ivl=32ms
E:  Ad=85(I) Atr=01(Isoc) MxPS= 960 Ivl=1ms
I:* If#= 1 Alt= 0 #EPs= 0 Cls=01(audio) Sub=01 Prot=00 Driver=snd-usb-audio
I:* If#= 2 Alt= 0 #EPs= 0 Cls=01(audio) Sub=02 Prot=00 Driver=snd-usb-audio
I:  If#= 2 Alt= 1 #EPs= 1 Cls=01(audio) Sub=02 Prot=00 Driver=snd-usb-audio
E:  Ad=84(I) Atr=01(Isoc) MxPS=  90 Ivl=1ms
I:  If#= 2 Alt= 2 #EPs= 1 Cls=01(audio) Sub=02 Prot=00 Driver=snd-usb-audio
E:  Ad=84(I) Atr=01(Isoc) MxPS=  46 Ivl=1ms
I:  If#= 2 Alt= 3 #EPs= 1 Cls=01(audio) Sub=02 Prot=00 Driver=snd-usb-audio
E:  Ad=84(I) Atr=01(Isoc) MxPS=  25 Ivl=1ms
I:  If#= 2 Alt= 4 #EPs= 1 Cls=01(audio) Sub=02 Prot=00 Driver=snd-usb-audio
E:  Ad=84(I) Atr=01(Isoc) MxPS=  16 Ivl=1ms

T:  Bus=01 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12   MxCh= 5
B:  Alloc= 11/900 us ( 1%), #Int=  1, #Iso=  0
D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1d6b ProdID=0001 Rev= 3.06
S:  Manufacturer=Linux 3.6.6 ohci_hcd
S:  Product=OHCI Host Controller
S:  SerialNumber=0000:00:12.0
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms

T:  Bus=01 Lev=01 Prnt=01 Port=01 Cnt=01 Dev#=  2 Spd=1.5  MxCh= 0
D:  Ver= 1.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
P:  Vendor=046d ProdID=c00c Rev= 6.20
S:  Manufacturer=Logitech
S:  Product=USB Mouse
C:* #Ifs= 1 Cfg#= 1 Atr=a0 MxPwr=100mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=01 Prot=02 Driver=usbhid
E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=10ms



And another:

# cat /sys/kernel/debug/usb/ohci/*/registers
bus pci, device 0000:00:12.0
OHCI Host Controller
ohci_hcd
OHCI 1.0, NO legacy support registers, rh state running
control 0x08f HCFS=operational IE PLE CBSR=3
cmdstatus 0x00000 SOC=0
intrstatus 0x00000024 FNO SF
intrenable 0x8000005a MIE RHSC UE RD WDH
ed_controlhead 00004000
hcca frame 0x7769
fmintvl 0xa7782edf FIT FSMPS=0xa778 FI=0x2edf
fmremaining 0x800014b7 FRT FR=0x14b7
periodicstart 0x2a2f
lsthresh 0x0628
hub poll timer off
roothub.a 02001205 POTPGT=2 NOCP NPS NDP=5(5)
roothub.b 00000000 PPCM=0000 DR=0000
roothub.status 00008000 DRWE
roothub.portstatus [0] 0x00000100 PPS
roothub.portstatus [1] 0x00000303 LSDA PPS PES CCS
roothub.portstatus [2] 0x00000100 PPS
roothub.portstatus [3] 0x00000100 PPS
roothub.portstatus [4] 0x00000100 PPS
bus pci, device 0000:00:13.0
OHCI Host Controller
ohci_hcd
OHCI 1.0, NO legacy support registers, rh state running
control 0x08f HCFS=operational IE PLE CBSR=3
cmdstatus 0x00000 SOC=0
intrstatus 0x00000026 FNO SF WDH
intrenable 0x8000005a MIE RHSC UE RD WDH
ed_controlhead 0008e000
hcca frame 0xf7b1
fmintvl 0xa7782edf FIT FSMPS=0xa778 FI=0x2edf
fmremaining 0x8000121c FRT FR=0x121c
periodicstart 0x2a2f
lsthresh 0x0628
hub poll timer off
roothub.a 02001205 POTPGT=2 NOCP NPS NDP=5(5)
roothub.b 00000000 PPCM=0000 DR=0000
roothub.status 00008000 DRWE
roothub.portstatus [0] 0x00000100 PPS
roothub.portstatus [1] 0x00000100 PPS
roothub.portstatus [2] 0x00000100 PPS
roothub.portstatus [3] 0x00000103 PPS PES CCS
roothub.portstatus [4] 0x00000100 PPS
bus pci, device 0000:00:14.5
OHCI Host Controller
ohci_hcd
OHCI 1.0, NO legacy support registers, rh state running
control 0x083 HCFS=operational CBSR=3
cmdstatus 0x00000 SOC=0
intrstatus 0x00000024 FNO SF
intrenable 0x8000005a MIE RHSC UE RD WDH
hcca frame 0x76f0
fmintvl 0xa7782edf FIT FSMPS=0xa778 FI=0x2edf
fmremaining 0x80000fd0 FRT FR=0x0fd0
periodicstart 0x2a2f
lsthresh 0x0628
hub poll timer off
roothub.a 02001202 POTPGT=2 NOCP NPS NDP=2(2)
roothub.b 00000000 PPCM=0000 DR=0000
roothub.status 00008000 DRWE
roothub.portstatus [0] 0x00000100 PPS
roothub.portstatus [1] 0x00000100 PPS
# cat /sys/kernel/debug/usb/devices

T:  Bus=02 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12   MxCh= 5
B:  Alloc=757/900 us (84%), #Int=  0, #Iso=  3
D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1d6b ProdID=0001 Rev= 3.06
S:  Manufacturer=Linux 3.6.6 ohci_hcd
S:  Product=OHCI Host Controller
S:  SerialNumber=0000:00:13.0
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms

T:  Bus=02 Lev=01 Prnt=01 Port=03 Cnt=01 Dev#=  2 Spd=12   MxCh= 0
D:  Ver= 1.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
P:  Vendor=0471 ProdID=0311 Rev= 0.03
S:  SerialNumber=01690000A5000000
C:* #Ifs= 3 Cfg#= 1 Atr=a0 MxPwr=500mA
I:  If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=Philips webcam
E:  Ad=82(I) Atr=03(Int.) MxPS=   1 Ivl=32ms
E:  Ad=85(I) Atr=01(Isoc) MxPS=   0 Ivl=1ms
I:  If#= 0 Alt= 1 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=Philips webcam
E:  Ad=82(I) Atr=03(Int.) MxPS=   1 Ivl=32ms
E:  Ad=85(I) Atr=01(Isoc) MxPS= 196 Ivl=1ms
I:  If#= 0 Alt= 2 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=Philips webcam
E:  Ad=82(I) Atr=03(Int.) MxPS=   1 Ivl=32ms
E:  Ad=85(I) Atr=01(Isoc) MxPS= 292 Ivl=1ms
I:  If#= 0 Alt= 3 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=Philips webcam
E:  Ad=82(I) Atr=03(Int.) MxPS=   1 Ivl=32ms
E:  Ad=85(I) Atr=01(Isoc) MxPS= 448 Ivl=1ms
I:  If#= 0 Alt= 4 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=Philips webcam
E:  Ad=82(I) Atr=03(Int.) MxPS=   1 Ivl=32ms
E:  Ad=85(I) Atr=01(Isoc) MxPS= 592 Ivl=1ms
I:  If#= 0 Alt= 5 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=Philips webcam
E:  Ad=82(I) Atr=03(Int.) MxPS=   1 Ivl=32ms
E:  Ad=85(I) Atr=01(Isoc) MxPS= 704 Ivl=1ms
I:  If#= 0 Alt= 6 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=Philips webcam
E:  Ad=82(I) Atr=03(Int.) MxPS=   1 Ivl=32ms
E:  Ad=85(I) Atr=01(Isoc) MxPS= 776 Ivl=1ms
I:  If#= 0 Alt= 7 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=Philips webcam
E:  Ad=82(I) Atr=03(Int.) MxPS=   1 Ivl=32ms
E:  Ad=85(I) Atr=01(Isoc) MxPS= 840 Ivl=1ms
I:  If#= 0 Alt= 8 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=Philips webcam
E:  Ad=82(I) Atr=03(Int.) MxPS=   1 Ivl=32ms
E:  Ad=85(I) Atr=01(Isoc) MxPS= 896 Ivl=1ms
I:* If#= 0 Alt= 9 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=Philips webcam
E:  Ad=82(I) Atr=03(Int.) MxPS=   1 Ivl=32ms
E:  Ad=85(I) Atr=01(Isoc) MxPS= 960 Ivl=1ms
I:  If#= 0 Alt=10 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=Philips webcam
E:  Ad=82(I) Atr=03(Int.) MxPS=   1 Ivl=32ms
E:  Ad=85(I) Atr=01(Isoc) MxPS= 960 Ivl=1ms
I:* If#= 1 Alt= 0 #EPs= 0 Cls=01(audio) Sub=01 Prot=00 Driver=snd-usb-audio
I:* If#= 2 Alt= 0 #EPs= 0 Cls=01(audio) Sub=02 Prot=00 Driver=snd-usb-audio
I:  If#= 2 Alt= 1 #EPs= 1 Cls=01(audio) Sub=02 Prot=00 Driver=snd-usb-audio
E:  Ad=84(I) Atr=01(Isoc) MxPS=  90 Ivl=1ms
I:  If#= 2 Alt= 2 #EPs= 1 Cls=01(audio) Sub=02 Prot=00 Driver=snd-usb-audio
E:  Ad=84(I) Atr=01(Isoc) MxPS=  46 Ivl=1ms
I:  If#= 2 Alt= 3 #EPs= 1 Cls=01(audio) Sub=02 Prot=00 Driver=snd-usb-audio
E:  Ad=84(I) Atr=01(Isoc) MxPS=  25 Ivl=1ms
I:  If#= 2 Alt= 4 #EPs= 1 Cls=01(audio) Sub=02 Prot=00 Driver=snd-usb-audio
E:  Ad=84(I) Atr=01(Isoc) MxPS=  16 Ivl=1ms

T:  Bus=11 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=5000 MxCh= 2
B:  Alloc=  0/800 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 3.00 Cls=09(hub  ) Sub=00 Prot=03 MxPS= 9 #Cfgs=  1
P:  Vendor=1d6b ProdID=0003 Rev= 3.06
S:  Manufacturer=Linux 3.6.6 xhci_hcd
S:  Product=xHCI Host Controller
S:  SerialNumber=0000:02:00.0
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=256ms

T:  Bus=10 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=480  MxCh= 2
B:  Alloc=  0/800 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 2.00 Cls=09(hub  ) Sub=00 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=1d6b ProdID=0002 Rev= 3.06
S:  Manufacturer=Linux 3.6.6 xhci_hcd
S:  Product=xHCI Host Controller
S:  SerialNumber=0000:02:00.0
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=256ms

T:  Bus=09 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=5000 MxCh= 2
B:  Alloc=  0/800 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 3.00 Cls=09(hub  ) Sub=00 Prot=03 MxPS= 9 #Cfgs=  1
P:  Vendor=1d6b ProdID=0003 Rev= 3.06
S:  Manufacturer=Linux 3.6.6 xhci_hcd
S:  Product=xHCI Host Controller
S:  SerialNumber=0000:00:10.1
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=256ms

T:  Bus=08 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=480  MxCh= 2
B:  Alloc=  0/800 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 2.00 Cls=09(hub  ) Sub=00 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=1d6b ProdID=0002 Rev= 3.06
S:  Manufacturer=Linux 3.6.6 xhci_hcd
S:  Product=xHCI Host Controller
S:  SerialNumber=0000:00:10.1
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=256ms

T:  Bus=07 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=5000 MxCh= 2
B:  Alloc=  0/800 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 3.00 Cls=09(hub  ) Sub=00 Prot=03 MxPS= 9 #Cfgs=  1
P:  Vendor=1d6b ProdID=0003 Rev= 3.06
S:  Manufacturer=Linux 3.6.6 xhci_hcd
S:  Product=xHCI Host Controller
S:  SerialNumber=0000:00:10.0
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=256ms

T:  Bus=06 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=480  MxCh= 2
B:  Alloc=  0/800 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 2.00 Cls=09(hub  ) Sub=00 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=1d6b ProdID=0002 Rev= 3.06
S:  Manufacturer=Linux 3.6.6 xhci_hcd
S:  Product=xHCI Host Controller
S:  SerialNumber=0000:00:10.0
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=256ms

T:  Bus=05 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=480  MxCh= 5
B:  Alloc=  0/800 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 2.00 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1d6b ProdID=0002 Rev= 3.06
S:  Manufacturer=Linux 3.6.6 ehci_hcd
S:  Product=EHCI Host Controller
S:  SerialNumber=0000:00:13.2
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=256ms

T:  Bus=04 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=480  MxCh= 5
B:  Alloc=  0/800 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 2.00 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1d6b ProdID=0002 Rev= 3.06
S:  Manufacturer=Linux 3.6.6 ehci_hcd
S:  Product=EHCI Host Controller
S:  SerialNumber=0000:00:12.2
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=256ms

T:  Bus=03 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12   MxCh= 2
B:  Alloc=  0/900 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1d6b ProdID=0001 Rev= 3.06
S:  Manufacturer=Linux 3.6.6 ohci_hcd
S:  Product=OHCI Host Controller
S:  SerialNumber=0000:00:14.5
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms

T:  Bus=01 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12   MxCh= 5
B:  Alloc= 11/900 us ( 1%), #Int=  1, #Iso=  0
D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1d6b ProdID=0001 Rev= 3.06
S:  Manufacturer=Linux 3.6.6 ohci_hcd
S:  Product=OHCI Host Controller
S:  SerialNumber=0000:00:12.0
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms

T:  Bus=01 Lev=01 Prnt=01 Port=01 Cnt=01 Dev#=  2 Spd=1.5  MxCh= 0
D:  Ver= 1.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
P:  Vendor=046d ProdID=c00c Rev= 6.20
S:  Manufacturer=Logitech
S:  Product=USB Mouse
C:* #Ifs= 1 Cfg#= 1 Atr=a0 MxPwr=100mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=01 Prot=02 Driver=usbhid
E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=10ms


