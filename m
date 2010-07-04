Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938Ab0GDIXw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 04:23:52 -0400
Received: from a.ns.protobalance.com ([95.211.116.249]:40617 "EHLO
	protonet.co.za" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756220Ab0GDIXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 04:23:50 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 Jul 2010 04:23:49 EDT
Subject: USB mass storage fails to register on kernel 2.6.32
From: Paul Sheer <p@2038bug.com>
To: linux-kernel@vger.kernel.org, zaitcev@redhat.com,
       linux-usb-devel@lists.sourceforge.net, dbrownell@users.sourceforge.net,
       johannes@erdfelt.com, mdharm-usb@one-eyed-alien.net, gregkh@suse.de,
       stern@rowland.harvard.edu, paulsheer@gmail.com
Content-Type: text/plain
Date: Sun, 04 Jul 2010 10:03:03 +0200
Message-Id: <1278230583.6443.27.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi there,

I have a Samsung Story external USB-2.0 1.5TB drive that fails to
detect as a device in more recent kernel versions. Full kmsg details
are below. Note that a USB thumb drive works fine on my system.
Older kernels work fine with the Samsung also. In terms of which
version of the kernel this stopped working, this I don't know.


uname -a gives:

    Linux version 2.6.32-23-generic (buildd@rothera) (gcc version
    4.4.3 (Ubuntu 4.4.3-4ubuntu5) ) #37-Ubuntu SMP Fri Jun 11
    07:54:58 UTC 2010



My kmsg output when plugging in the drive is as follows:


    <6>[  244.624034] usb 1-10: new high speed USB device using ehci_hcd
and address 3
    <3>[  244.780033] usb 1-10: device descriptor read/64, error -32
    <3>[  245.036030] usb 1-10: device descriptor read/64, error -32
    <6>[  245.252038] usb 1-10: new high speed USB device using ehci_hcd
and address 4
    <3>[  245.862496] usb 1-10: unable to read config index 0
descriptor/start: -71
    <3>[  245.862615] usb 1-10: chopping to 0 config(s)
    <3>[  245.979496] usb 1-10: string descriptor 0 read error: -71
    <4>[  245.980413] usb 1-10: no configuration chosen from 0 choices




When plugging in my thumb drive I get the expected results:


    <6>[  135.216034] usb 1-10: new high speed USB device using ehci_hcd
and address 2
    <6>[  135.352726] usb 1-10: configuration #1 chosen from 1 choice
    <6>[  135.410021] Initializing USB Mass Storage driver...
    <6>[  135.410186] scsi6 : SCSI emulation for USB Mass Storage
devices
    <6>[  135.410460] usbcore: registered new interface driver
usb-storage
    <6>[  135.410466] USB Mass Storage support registered.
    <7>[  135.414677] usb-storage: device found at 2
    <7>[  135.414682] usb-storage: waiting for device to settle before
scanning
    <7>[  140.412291] usb-storage: device scan complete
    <5>[  140.414270] scsi 6:0:0:0: Direct-Access     USB      Flash
Disk       1100 PQ: 0 ANSI: 0 CCS
    <5>[  140.417527] sd 6:0:0:0: Attached scsi generic sg3 type 0
    <5>[  140.419744] sd 6:0:0:0: [sdc] 1014784 512-byte logical blocks:
(519 MB/495 MiB)
    <5>[  140.424490] sd 6:0:0:0: [sdc] Write Protect is off
    <7>[  140.424500] sd 6:0:0:0: [sdc] Mode Sense: 43 00 00 00
    <3>[  140.424506] sd 6:0:0:0: [sdc] Assuming drive cache: write
through
    <3>[  140.428511] sd 6:0:0:0: [sdc] Assuming drive cache: write
through
    <6>[  140.428631]  sdc: sdc1
    <3>[  140.494141] sd 6:0:0:0: [sdc] Assuming drive cache: write
through
    <5>[  140.494261] sd 6:0:0:0: [sdc] Attached SCSI removable disk




usb-devices  output is as follows:

    
    T:  Bus=01 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=480 MxCh=10
    D:  Ver= 2.00 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
    P:  Vendor=1d6b ProdID=0002 Rev=02.06
    S:  Manufacturer=Linux 2.6.32-23-generic ehci_hcd
    S:  Product=EHCI Host Controller
    S:  SerialNumber=0000:00:02.1
    C:  #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=0mA
    I:  If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
    
    T:  Bus=01 Lev=01 Prnt=01 Port=09 Cnt=01 Dev#=  2 Spd=480 MxCh= 0
    D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  0
    P:  Vendor=04e8 ProdID=5f06 Rev=00.00
    S:  Manufacturer=JMicron
    S:  SerialNumber=0000002CE09310500626
    C:  #Ifs= 0 Cfg#= 0 Atr= MxPwr=
    cat: /sys/bus/usb/devices/usb1/1-10/1-*:?.*/bInterfaceNumber: No
such file or directory
    cat: /sys/bus/usb/devices/usb1/1-10/1-*:?.*/bAlternateSetting: No
such file or directory
    cat: /sys/bus/usb/devices/usb1/1-10/1-*:?.*/bNumEndpoints: No such
file or directory
    cat: /sys/bus/usb/devices/usb1/1-10/1-*:?.*/bInterfaceClass: No such
file or directory
    cat: /sys/bus/usb/devices/usb1/1-10/1-*:?.*/bInterfaceSubClass: No
such file or directory
    cat: /sys/bus/usb/devices/usb1/1-10/1-*:?.*/bInterfaceProtocol: No
such file or directory
    /usr/bin/usb-devices: line 79: printf: (none): invalid number
    I:  If#= 0 Alt= 0 #EPs= 0 Cls=() Sub= Prot= Driver=
    
    T:  Bus=02 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh=10
    D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
    P:  Vendor=1d6b ProdID=0001 Rev=02.06
    S:  Manufacturer=Linux 2.6.32-23-generic ohci_hcd
    S:  Product=OHCI Host Controller
    S:  SerialNumber=0000:00:02.0
    C:  #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=0mA
    I:  If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub


I think this might be a related problem:


http://quantan.blogspot.com/2010/03/ubuntu-1004-lts-b1-dan-usb-modem-gsm.html


I will be unsubscribing from these lists after sending this bug
report, so please contact me directly if you need more info at
paulsheer at gmail


-paul





