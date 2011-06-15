Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab1FODvR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 23:51:17 -0400
Received: from gherkin.frus.com ([192.158.254.49]:60745 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754070Ab1FODvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 23:51:16 -0400
X-Greylist: delayed 1675 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Jun 2011 23:51:15 EDT
Date: Tue, 14 Jun 2011 22:23:18 -0500
From: Bob Tracy <rct@gherkin.frus.com>
To: linux-kernel@vger.kernel.org
Subject: [BUG] 3.0.0-rc2 usb mouse not working
Message-ID: <20110615032318.GA2575@gherkin.frus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note: 3.0.0-rc1 hung during boot (right after parport initialization),
so the best I can do at the moment is say the bug first showed up after
2.6.39.  Processor is an AMD K6-III/450.

Symptoms: Microsoft Intellimouse (corded USB optical) non-functional.
	Red LED comes on when mouse is plugged in, but movement and
	clicks are not seen.

"lsusb" segfaults :-(.  "cat /proc/bus/usb/devices" gives the following
(the mouse and an APC UPS monitoring cable are plugged into the two
low-speed ports on the motherboard hub):

T:  Bus=04 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12   MxCh= 2
B:  Alloc=  0/900 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1d6b ProdID=0001 Rev= 3.00
S:  Manufacturer=Linux 3.0.0-rc2 uhci_hcd
S:  Product=UHCI Host Controller
S:  SerialNumber=0000:00:08.1
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms

T:  Bus=03 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12   MxCh= 2
B:  Alloc=  0/900 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1d6b ProdID=0001 Rev= 3.00
S:  Manufacturer=Linux 3.0.0-rc2 uhci_hcd
S:  Product=UHCI Host Controller
S:  SerialNumber=0000:00:08.0
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms

T:  Bus=02 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12   MxCh= 2
B:  Alloc=  0/900 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1d6b ProdID=0001 Rev= 3.00
S:  Manufacturer=Linux 3.0.0-rc2 uhci_hcd
S:  Product=UHCI Host Controller
S:  SerialNumber=0000:00:07.2
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms

T:  Bus=02 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=1.5  MxCh= 0
D:  Ver= 1.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
P:  Vendor=051d ProdID=0002 Rev= 1.06
S:  Manufacturer=American Power Conversion
S:  Product=Back-UPS NS 1250 FW:7.g1 .D USB FW:g1 
S:  SerialNumber=JB0643005571  
C:* #Ifs= 1 Cfg#= 1 Atr=a0 MxPwr= 24mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=00 Prot=00 Driver=(none)
E:  Ad=81(I) Atr=03(Int.) MxPS=   6 Ivl=10ms

T:  Bus=02 Lev=01 Prnt=01 Port=01 Cnt=02 Dev#=  4 Spd=1.5  MxCh= 0
D:  Ver= 1.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
P:  Vendor=045e ProdID=0039 Rev= 1.21
S:  Manufacturer=Microsoft
S:  Product=Microsoft IntelliMouse® Optical
C:* #Ifs= 1 Cfg#= 1 Atr=a0 MxPwr=100mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=01 Prot=02 Driver=(none)
E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=10ms

T:  Bus=01 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=480  MxCh= 4
B:  Alloc=  0/800 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 2.00 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1d6b ProdID=0002 Rev= 3.00
S:  Manufacturer=Linux 3.0.0-rc2 ehci_hcd
S:  Product=EHCI Host Controller
S:  SerialNumber=0000:00:08.2
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=256ms

Unfortunately, I no longer have a working 2.6.39 kernel to compare
against, but the internal driver "plumbing" looks wrong: as mentioned
above, the mouse and the UPS cable are plugged into the low-speed
motherboard hub.

--Bob
