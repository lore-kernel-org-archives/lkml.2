Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913Ab2LAIwp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 03:52:45 -0500
Received: from pindarots.xs4all.nl ([80.101.128.228]:39674 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab2LAIwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 03:52:44 -0500
Message-ID: <50B9C545.4060808@xs4all.nl>
Date: Sat, 01 Dec 2012 09:52:21 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: linux-usb@vger.kernel.org
CC: Alan Stern <stern@rowland.harvard.edu>,
        Jan Ceuleers <jan.ceuleers@computer.org>,
        Clemens Ladisch <clemens@ladisch.de>,
        Simon Jones <sijones2010@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: 3.4.4: disabling irq
References: <Pine.LNX.4.44L0.1211191139140.1598-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1211191139140.1598-100000@iolanthe.rowland.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-11-19 17:41, Alan Stern wrote:
> On Sat, 17 Nov 2012, Udo van den Heuvel wrote:
>> How to proceed next?
> 
> Firstly, what does /proc/interrupts say?
> 
> Secondly, try building a kernel with the patch below and 
> CONFIG_USB_DEBUG enabled.  Let's see what the dmesg log says when the 
> problem occurs.

Message from syslogd@a at Dec  1 09:46:01 ...
 kernel:Disabling IRQ #18
^C
[root@a mesa]# cat /sys/kernel/debug/usb/ohci/*/registers
bus pci, device 0000:00:12.0
OHCI Host Controller
ohci_hcd
OHCI 1.0, NO legacy support registers, rh state running
control 0x08f HCFS=operational IE PLE CBSR=3
cmdstatus 0x00000 SOC=0
intrstatus 0x00000024 FNO SF
intrenable 0x8000005a MIE RHSC UE RD WDH
ed_controlhead 00004000
hcca frame 0xa078
fmintvl 0xa7782edf FIT FSMPS=0xa778 FI=0x2edf
fmremaining 0x80001c56 FRT FR=0x1c56
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
ed_controlhead 00092000
hcca frame 0xa2ab
fmintvl 0xa7782edf FIT FSMPS=0xa778 FI=0x2edf
fmremaining 0x8000184a FRT FR=0x184a
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
hcca frame 0xa000
fmintvl 0xa7782edf FIT FSMPS=0xa778 FI=0x2edf
fmremaining 0x800014da FRT FR=0x14da
periodicstart 0x2a2f
lsthresh 0x0628
hub poll timer off
roothub.a 02001202 POTPGT=2 NOCP NPS NDP=2(2)
roothub.b 00000000 PPCM=0000 DR=0000
roothub.status 00008000 DRWE
roothub.portstatus [0] 0x00000100 PPS
roothub.portstatus [1] 0x00000100 PPS
[root@a mesa]# cat /sys/kernel/debug/usb/devices

T:  Bus=02 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12   MxCh= 5
B:  Alloc=757/900 us (84%), #Int=  0, #Iso=  3
D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1d6b ProdID=0001 Rev= 3.06
S:  Manufacturer=Linux 3.6.7 ohci_hcd
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
S:  Manufacturer=Linux 3.6.7 xhci_hcd
S:  Product=xHCI Host Controller
S:  SerialNumber=0000:02:00.0
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=256ms

T:  Bus=10 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=480  MxCh= 2
B:  Alloc=  0/800 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 2.00 Cls=09(hub  ) Sub=00 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=1d6b ProdID=0002 Rev= 3.06
S:  Manufacturer=Linux 3.6.7 xhci_hcd
S:  Product=xHCI Host Controller
S:  SerialNumber=0000:02:00.0
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=256ms

T:  Bus=09 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=5000 MxCh= 2
B:  Alloc=  0/800 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 3.00 Cls=09(hub  ) Sub=00 Prot=03 MxPS= 9 #Cfgs=  1
P:  Vendor=1d6b ProdID=0003 Rev= 3.06
S:  Manufacturer=Linux 3.6.7 xhci_hcd
S:  Product=xHCI Host Controller
S:  SerialNumber=0000:00:10.1
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=256ms

T:  Bus=08 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=480  MxCh= 2
B:  Alloc=  0/800 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 2.00 Cls=09(hub  ) Sub=00 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=1d6b ProdID=0002 Rev= 3.06
S:  Manufacturer=Linux 3.6.7 xhci_hcd
S:  Product=xHCI Host Controller
S:  SerialNumber=0000:00:10.1
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=256ms

T:  Bus=07 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=5000 MxCh= 2
B:  Alloc=  0/800 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 3.00 Cls=09(hub  ) Sub=00 Prot=03 MxPS= 9 #Cfgs=  1
P:  Vendor=1d6b ProdID=0003 Rev= 3.06
S:  Manufacturer=Linux 3.6.7 xhci_hcd
S:  Product=xHCI Host Controller
S:  SerialNumber=0000:00:10.0
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=256ms

T:  Bus=06 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=480  MxCh= 2
B:  Alloc=  0/800 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 2.00 Cls=09(hub  ) Sub=00 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=1d6b ProdID=0002 Rev= 3.06
S:  Manufacturer=Linux 3.6.7 xhci_hcd
S:  Product=xHCI Host Controller
S:  SerialNumber=0000:00:10.0
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=256ms

T:  Bus=06 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  4 Spd=480  MxCh= 0
D:  Ver= 2.00 Cls=02(comm.) Sub=00 Prot=00 MxPS=64 #Cfgs=  2
P:  Vendor=0525 ProdID=a4a2 Rev= 2.16
S:  Manufacturer=Linux 2.6.21-omap1/musb_hdrc
S:  Product=RNDIS/Ethernet Gadget
C:  #Ifs= 2 Cfg#= 2 Atr=e0 MxPwr=  8mA
I:  If#= 0 Alt= 0 #EPs= 1 Cls=02(comm.) Sub=02 Prot=ff Driver=
E:  Ad=82(I) Atr=03(Int.) MxPS=  16 Ivl=32ms
I:  If#= 1 Alt= 0 #EPs= 2 Cls=0a(data ) Sub=00 Prot=00 Driver=
E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
C:* #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=  8mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=02(comm.) Sub=06 Prot=00 Driver=(none)
E:  Ad=82(I) Atr=03(Int.) MxPS=  16 Ivl=32ms
I:  If#= 1 Alt= 0 #EPs= 0 Cls=0a(data ) Sub=00 Prot=00 Driver=cdc_subset
I:* If#= 1 Alt= 1 #EPs= 2 Cls=0a(data ) Sub=00 Prot=00 Driver=cdc_subset
E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms

T:  Bus=05 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=480  MxCh= 5
B:  Alloc=  0/800 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 2.00 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1d6b ProdID=0002 Rev= 3.06
S:  Manufacturer=Linux 3.6.7 ehci_hcd
S:  Product=EHCI Host Controller
S:  SerialNumber=0000:00:13.2
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=256ms

T:  Bus=04 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=480  MxCh= 5
B:  Alloc=  0/800 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 2.00 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1d6b ProdID=0002 Rev= 3.06
S:  Manufacturer=Linux 3.6.7 ehci_hcd
S:  Product=EHCI Host Controller
S:  SerialNumber=0000:00:12.2
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=256ms

T:  Bus=03 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12   MxCh= 2
B:  Alloc=  0/900 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1d6b ProdID=0001 Rev= 3.06
S:  Manufacturer=Linux 3.6.7 ohci_hcd
S:  Product=OHCI Host Controller
S:  SerialNumber=0000:00:14.5
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms

T:  Bus=01 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12   MxCh= 5
B:  Alloc= 11/900 us ( 1%), #Int=  1, #Iso=  0
D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1d6b ProdID=0001 Rev= 3.06
S:  Manufacturer=Linux 3.6.7 ohci_hcd
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
[root@a mesa]# service motion stop
Stopping motion (via systemctl):                           [  OK  ]
[root@a mesa]# rmmod pwc
[root@a mesa]# echo 0000:00:13.0 >/sys/bus/pci/drivers/ohci_hcd/unbind
[root@a mesa]# echo 0000:00:13.0 >/sys/bus/pci/drivers/ohci_hcd/bind
[root@a mesa]# modprobe pwc
[root@a mesa]# service motion start
Starting motion (via systemctl):                           [  OK  ]
[root@a mesa]# dmesg|sort|uniq
ehci_hcd 0000:00:13.2: GetStatus port:4 status 001803 0  ACK POWER sig=j
CSC CONNECT
ehci_hcd 0000:00:13.2: GetStatus port:4 status 003002 0  ACK POWER OWNER
sig=se0 CSC
ehci_hcd 0000:00:13.2: GetStatus port:4 status 003801 0  ACK POWER OWNER
sig=j CONNECT
ehci_hcd 0000:00:13.2: port 4 full speed --> companion
hub 2-0:1.0: 5 ports detected
hub 2-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x101
hub 2-0:1.0: local power source is good
hub 2-0:1.0: no over-current protection
hub 2-0:1.0: no power switching (usb 1.0)
hub 2-0:1.0: port 4, status 0101, change 0001, 12 Mb/s
hub 2-0:1.0: power on to power good time: 4ms
hub 2-0:1.0: standalone hub
hub 2-0:1.0: state 7 ports 5 chg 0000 evt 0010
hub 2-0:1.0: trying to enable port power on non-switchable hub
hub 2-0:1.0: USB hub found
hub 2-0:1.0: usb_probe_interface
hub 2-0:1.0: usb_probe_interface - got id
hub 5-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x100
hub 5-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
hub 5-0:1.0: port 4 not reset yet, waiting 50ms
hub 5-0:1.0: port 4, status 0100, change 0001, 12 Mb/s
hub 5-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 5-0:1.0: state 7 ports 5 chg 0000 evt 0010
input: PWC snapshot button as
/devices/pci0000:00/0000:00:13.0/usb2/2-4/input/input8
ohci_hcd 0000:00:12.0: IRQ: 24 8000005a
ohci_hcd 0000:00:13.0: cmdstatus 0x00000 SOC=0
ohci_hcd 0000:00:13.0: control 0x083 HCFS=operational CBSR=3
ohci_hcd 0000:00:13.0: created debug files
ohci_hcd 0000:00:13.0: ed_controlhead 00092000
ohci_hcd 0000:00:13.0: GetStatus roothub.portstatus [3] = 0x00010100 CSC PPS
ohci_hcd 0000:00:13.0: GetStatus roothub.portstatus [3] = 0x00010101 CSC
PPS CCS
ohci_hcd 0000:00:13.0: GetStatus roothub.portstatus [3] = 0x00100103
PRSC PPS PES CCS
ohci_hcd 0000:00:13.0: hcca frame #0004
ohci_hcd 0000:00:13.0: hcca frame #b161
ohci_hcd 0000:00:13.0: intrenable 0x8000005a MIE RHSC UE RD WDH
ohci_hcd 0000:00:13.0: intrstatus 0x00000004 SF
ohci_hcd 0000:00:13.0: intrstatus 0x00000024 FNO SF
ohci_hcd 0000:00:13.0: irq 18, io mem 0xfeb4e000
ohci_hcd 0000:00:13.0: IRQ: 44 8000001a
ohci_hcd 0000:00:13.0: IRQ: 4 8000001a
ohci_hcd 0000:00:13.0: IRQ: 4 8000005a
ohci_hcd 0000:00:13.0: IRQ: 64 5a
ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:13.0: OHCI 1.0, NO legacy support registers, rh state
running
ohci_hcd 0000:00:13.0: OHCI controller state
ohci_hcd 0000:00:13.0: OHCI Host Controller
ohci_hcd 0000:00:13.0: remove, state 1
ohci_hcd 0000:00:13.0: roothub.a 02001205 POTPGT=2 NOCP NPS NDP=5(5)
ohci_hcd 0000:00:13.0: roothub.b 00000000 PPCM=0000 DR=0000
ohci_hcd 0000:00:13.0: roothub graceful disconnect
ohci_hcd 0000:00:13.0: roothub.portstatus [0] 0x00000100 PPS
ohci_hcd 0000:00:13.0: roothub.portstatus [1] 0x00000100 PPS
ohci_hcd 0000:00:13.0: roothub.portstatus [2] 0x00000100 PPS
ohci_hcd 0000:00:13.0: roothub.portstatus [3] 0x00000103 PPS PES CCS
ohci_hcd 0000:00:13.0: roothub.portstatus [3] 0x00010100 CSC PPS
ohci_hcd 0000:00:13.0: roothub.portstatus [4] 0x00000100 PPS
ohci_hcd 0000:00:13.0: roothub.status 00008000 DRWE
ohci_hcd 0000:00:13.0: shutdown urb ffff8801d86233c0 ep1in-intr
ohci_hcd 0000:00:13.0: supports USB remote wakeup
ohci_hcd 0000:00:13.0: USB bus 2 deregistered
ohci_hcd 0000:00:14.5: IRQ: 24 8000005a
Philips webcam 2-4:1.0: usb_probe_interface
Philips webcam 2-4:1.0: usb_probe_interface - got id
pwc: Error (-1) re-submitting urb in pwc_isoc_handler.
pwc: Iso frame 0 has error -18
pwc: Iso frame 1 has error -114
pwc: Iso frame 1 has error -18
pwc: Iso frame 2 has error -18
pwc: Iso frame 3 has error -114
pwc: Iso frame 3 has error -18
pwc: Iso frame 4 has error -18
pwc: Iso frame 5 has error -114
pwc: Iso frame 5 has error -18
pwc: Iso frame 6 has error -18
pwc: Iso frame 7 has error -114
pwc: Iso frame 7 has error -18
pwc: Iso frame 8 has error -18
pwc: Iso frame 9 has error -114
pwc: Iso frame 9 has error -18
pwc: Philips PCVC740K (ToUCam Pro)/PCVC840 (ToUCam II) USB webcam detected.
pwc: Registered as video0.
snd-usb-audio 2-4:1.1: usb_probe_interface
snd-usb-audio 2-4:1.1: usb_probe_interface - got id
usb 2-4: adding 2-4:1.0 (config #1, interface 0)
usb 2-4: adding 2-4:1.1 (config #1, interface 1)
usb 2-4: adding 2-4:1.2 (config #1, interface 2)
usb 2-4: configuration #1 chosen from 1 choice
usb 2-4: default language 0x0409
usb 2-4: ep0 maxpacket = 8
usb 2-4: new full-speed USB device number 2 using ohci_hcd
usb 2-4: New USB device found, idVendor=0471, idProduct=0311
usb 2-4: New USB device strings: Mfr=0, Product=0, SerialNumber=1
usb 2-4: SerialNumber: 01690000A1000010
usb 2-4: skipped 1 descriptor after endpoint
usb 2-4: skipped 2 descriptors after interface
usb 2-4: skipped 4 descriptors after interface
usb 2-4: udev 2, busnum 2, minor = 129
usb 2-4: unregistering device
usb 2-4: unregistering interface 2-4:1.0
usb 2-4: unregistering interface 2-4:1.1
usb 2-4: unregistering interface 2-4:1.2
usb 2-4: usb_disable_device nuking all URBs
usb 2-4: USB disconnect, device number 2
usb 2-4: usb_probe_device
usbcore: deregistering interface driver Philips webcam
usbcore: registered new interface driver Philips webcam
usb usb2: adding 2-0:1.0 (config #1, interface 0)
usb usb2: configuration #1 chosen from 1 choice
usb usb2: default language 0x0409
usb usb2: Manufacturer: Linux 3.6.7 ohci_hcd
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: OHCI Host Controller
usb usb2: SerialNumber: 0000:00:13.0
usb usb2: udev 1, busnum 2, minor = 128
usb usb2: unregistering device
usb usb2: unregistering interface 2-0:1.0
usb usb2: usb_disable_device nuking all URBs
usb usb2: USB disconnect, device number 1
usb usb2: usb_probe_device
[root@a mesa]# ^C


I had to hurry as the debug patch overflows dmesg very quickly.
That is the reason why the dmesg is sorted and uniq'd etc.
I do hope there is enough info to further this issue.

Kind regards,
Udo
