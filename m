Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461Ab1FPJZ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 05:25:58 -0400
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:43771 "EHLO
	qmta05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754119Ab1FPJZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 05:25:52 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH 3/3] staging: usbip: userspace: cleanup README
Date: Thu, 16 Jun 2011 02:24:59 -0700
Message-Id: <b68efca3cdc69231463a8de80ff110680b060d63.1308216105.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <eaf110e01131b9396317345fb696b795df706da9.1308216105.git.mfm@muteddisk.com>
References: <eaf110e01131b9396317345fb696b795df706da9.1308216105.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update examples to correspond with the new usbip-utils; edit grammar;
and cleanup format for consistency.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/userspace/README |  283 +++++++++++++++-----------------
 1 files changed, 133 insertions(+), 150 deletions(-)

diff --git a/drivers/staging/usbip/userspace/README b/drivers/staging/usbip/userspace/README
index 2ee84b9..aafab102 100644
--- a/drivers/staging/usbip/userspace/README
+++ b/drivers/staging/usbip/userspace/README
@@ -1,19 +1,19 @@
-# vim:tw=78:ts=4:expandtab:ai:sw=4
 #
 # README for usbip-utils
 #
-# Copyright (C) 2005-2008 Takahiro Hirofuchi
+# Copyright (C) 2011 matt mooney <mfm@muteddisk.com>
+#               2005-2008 Takahiro Hirofuchi
 
 
 [Requirements]
     - USB/IP device drivers
-        Its source code is included under $(top)/drivers/.
+	Found in the staging directory of the Linux kernel.
 
     - sysfsutils >= 2.0.0
-        sysfsutils library
+	sysfsutils library
 
     - libwrap0-dev
-        tcp wrapper library
+	tcp wrapper library
 
     - gcc >= 4.0
 
@@ -21,195 +21,178 @@
 
     - libtool, automake >= 1.9, autoconf >= 2.5.0, pkg-config
 
+
 [Install]
-    0. Skip here if you see a configure script.
-        $ ./autogen.sh
+    0. Generate configuration scripts.
+	$ ./autogen.sh
+
+    1. Compile & install the userspace utilities.
+	$ ./configure [--with-tcp-wrappers=no] [--with-usbids-dir=<dir>]
+	$ make install
 
-    1. Compile & install.
-        $ ./configure
-        $ make install
+    2. Compile & install USB/IP drivers.
 
-    2. Compile & install USB/IP drivers if not yet.
 
 [Usage]
-    server:# (Attach your USB device physically.)
+    server:# (Physically attach your USB device.)
 
     server:# insmod usbip-core.ko
     server:# insmod usbip-host.ko
-        - It was formerly named as stub.ko.
 
     server:# usbipd -D
-        - Start usbip daemon.
+	- Start usbip daemon.
 
-    server:# usbip_bind_driver --list
-        - List driver assignments for usb devices.
-
-    server:# usbip_bind_driver --usbip 1-2
-        - Bind usbip-host.ko to the device of busid 1-2.
-        - A usb device 1-2 is now exportable to other hosts!
-        - Use 'usbip_bind_driver --other 1-2' when you want to shutdown exporting
-          and use the device locally.
+    server:# usbip list -l
+	- List driver assignments for USB devices.
 
+    server:# usbip bind --busid 1-2
+	- Bind usbip-host.ko to the device with busid 1-2.
+	- The USB device 1-2 is now exportable to other hosts!
+	- Use `usbip unbind --busid 1-2' to stop exporting the device.
 
     client:# insmod usbip-core.ko
     client:# insmod vhci-hcd.ko
-        - It was formerly named as vhci.ko.
 
-    client:# usbip --list server
-        - List exportable usb devices on the server.
+    client:# usbip list --remote <host>
+	- List exported USB devices on the <host>.
+
+    client:# usbip attach --host <host> --busid 1-2
+	- Connect the remote USB device.
 
-    client:# usbip --attach server 1-2
-        - Connect the remote USB device.
+    client:# usbip port
+	- Show virtual port status.
 
-    client:# usbip --port
-        - Show virtual port status.
+    client:# usbip detach --port <port>
+	- Detach the USB device.
 
-    client:# usbip --detach 0
-        - Detach the usb device.
 
+[Example]
+---------------------------
+	SERVER SIDE
+---------------------------
+Physically attach your USB devices to this host.
 
-[Output Example]
---------------------------------------------------------------------------------------------------------
-- SERVER SIDE (physically attach your USB devices to this host) ----------------------------------------
---------------------------------------------------------------------------------------------------------
-trois:# insmod (somewhere)/usbip-core.ko
-trois:# insmod (somewhere)/usbip-host.ko
-trois:# usbipd -D
+    trois:# insmod path/to/usbip-core.ko
+    trois:# insmod path/to/usbip-host.ko
+    trois:# usbipd -D
 
---------------------------------------------------------------------------------------------------------
-In another terminal, let's look up what usb devices are physically attached to
-this host.  We can see a usb storage device of busid 3-3.2 is now bound to
-usb-storage driver. To export this device, we first mark the device as
-"exportable"; the device is bound to usbip driver. Please remember you can not
-export a usb hub.
+In another terminal, let's look up what USB devices are physically
+attached to this host.
 
-   trois:# usbip_bind_driver --list
-   List USB devices
-   - busid 3-3.2 (04bb:0206)
-       3-3.2:1.0 -> usb-storage
+    trois:# usbip_bind_driver --list
+    Local USB devices
+    =================
+     - busid 1-1 (05a9:a511)
+	     1-1:1.0 -> ov511
 
-   - busid 3-3.1 (08bb:2702)
-       3-3.1:1.0 -> snd-usb-audio
-       3-3.1:1.1 -> snd-usb-audio
+     - busid 3-2 (0711:0902)
+	     3-2:1.0 -> none
 
-   - busid 3-3 (0409:0058)
-       3-3:1.0 -> hub
+     - busid 3-3.1 (08bb:2702)
+	     3-3.1:1.0 -> snd-usb-audio
+	     3-3.1:1.1 -> snd-usb-audio
 
-   - busid 3-2 (0711:0902)
-       3-2:1.0 -> none
+     - busid 3-3.2 (04bb:0206)
+	     3-3.2:1.0 -> usb-storage
 
-   - busid 1-1 (05a9:a511)
-       1-1:1.0 -> ov511
+     - busid 3-3 (0409:0058)
+	     3-3:1.0 -> hub
 
-   - busid 4-1 (046d:08b2)
-       4-1:1.0 -> none
-       4-1:1.1 -> none
-       4-1:1.2 -> none
+     - busid 4-1 (046d:08b2)
+	     4-1:1.0 -> none
+	     4-1:1.1 -> none
+	     4-1:1.2 -> none
 
-   - busid 5-2 (058f:9254)
-       5-2:1.0 -> hub
+     - busid 5-2 (058f:9254)
+	     5-2:1.0 -> hub
 
---------------------------------------------------------------------------------------------------------
-Mark the device of busid 3-3.2 as exportable.
+A USB storage device of busid 3-3.2 is now bound to the usb-storage
+driver. To export this device, we first mark the device as
+"exportable"; the device is bound to the usbip-host driver. Please
+remember you can not export a USB hub.
 
-   trois:# usbip_bind_driver --usbip 3-3.2
-   ** (process:24621): DEBUG:  3-3.2:1.0   -> none
-   ** (process:24621): DEBUG: write "add 3-3.2" to /sys/bus/usb/drivers/usbip/match_busid
-   ** Message: bind 3-3.2 to usbip, complete!
+Mark the device of busid 3-3.2 as exportable:
 
-   trois:# usbip_bind_driver --list
-   List USB devices
-   - busid 3-3.2 (04bb:0206)
-           3-3.2:1.0 -> usbip
-   (snip)
+    trois:# usbip --debug bind --busid 3-3.2
+    ...
+    usbip dbg: utils.c:	 52 (modify_match_busid) write "add 3-3.2" to...
+    usbip dbg: usbip_bind.c: 231 (use_device_by_usbip) bind 3-3.2 complete!
 
-Iterate the above operation for other devices if you like.
+    trois:# usbip list -l
+    Local USB devices
+    =================
+    ...
 
+     - busid 3-3.2 (04bb:0206)
+	     3-3.2:1.0 -> usbip-host
+    ...
 
---------------------------------------------------------------------------------------------------------
-- CLIENT SIDE ------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
-First, let's list available remote devices which are marked as exportable in
-the server host.
+---------------------------
+	CLIENT SIDE
+---------------------------
+First, let's list available remote devices that are marked as
+exportable on the host.
 
-   deux:# insmod (somewhere)/usbip-core.ko
-   deux:# insmod (somewhere)/vhci_hcd.ko
+    deux:# insmod path/to/usbip-core.ko
+    deux:# insmod path/to/vhci-hcd.ko
 
-   deux:# usbip --list 10.0.0.3
-   - 10.0.0.3
-          1-1: Prolific Technology, Inc. : unknown product (067b:3507)
-             : /sys/devices/pci0000:00/0000:00:1f.2/usb1/1-1
-             : (Defined at Interface level) / unknown subclass / unknown protocol (00/00/00)
-             :  0 - Mass Storage / SCSI / Bulk (Zip) (08/06/50)
+    deux:# usbip list --remote 10.0.0.3
+    - 10.0.0.3
+	  1-1: Prolific Technology, Inc. : unknown product (067b:3507)
+	     : /sys/devices/pci0000:00/0000:00:1f.2/usb1/1-1
+	     : (Defined at Interface level) / unknown subclass / unknown protocol (00/00/00)
+	     :	0 - Mass Storage / SCSI / Bulk (Zip) (08/06/50)
 
       1-2.2.1: Apple Computer, Inc. : unknown product (05ac:0203)
-             : /sys/devices/pci0000:00/0000:00:1f.2/usb1/1-2/1-2.2/1-2.2.1
-             : (Defined at Interface level) / unknown subclass / unknown protocol (00/00/00)
-             :  0 - Human Interface Devices / Boot Interface Subclass / Keyboard (03/01/01)
+	     : /sys/devices/pci0000:00/0000:00:1f.2/usb1/1-2/1-2.2/1-2.2.1
+	     : (Defined at Interface level) / unknown subclass / unknown protocol (00/00/00)
+	     :	0 - Human Interface Devices / Boot Interface Subclass / Keyboard (03/01/01)
 
       1-2.2.3: OmniVision Technologies, Inc. : OV511+ WebCam (05a9:a511)
-             : /sys/devices/pci0000:00/0000:00:1f.2/usb1/1-2/1-2.2/1-2.2.3
-             : (Defined at Interface level) / unknown subclass / unknown protocol (00/00/00)
-             :  0 - Vendor Specific Class / unknown subclass / unknown protocol (ff/00/00)
-
-          3-1: Logitech, Inc. : QuickCam Pro 4000 (046d:08b2)
-             : /sys/devices/pci0000:00/0000:00:1e.0/0000:02:0a.0/usb3/3-1
-             : (Defined at Interface level) / unknown subclass / unknown protocol (00/00/00)
-             :  0 - Data / unknown subclass / unknown protocol (0a/ff/00)
-             :  1 - Audio / Control Device / unknown protocol (01/01/00)
-             :  2 - Audio / Streaming / unknown protocol (01/02/00)
-
-          4-1: Logitech, Inc. : QuickCam Express (046d:0870)
-             : /sys/devices/pci0000:00/0000:00:1e.0/0000:02:0a.1/usb4/4-1
-             : Vendor Specific Class / Vendor Specific Subclass / Vendor Specific Protocol (ff/ff/ff)
-             :  0 - Vendor Specific Class / Vendor Specific Subclass / Vendor Specific Protocol (ff/ff/ff)
-
-          4-2: Texas Instruments Japan : unknown product (08bb:2702)
-             : /sys/devices/pci0000:00/0000:00:1e.0/0000:02:0a.1/usb4/4-2
-             : (Defined at Interface level) / unknown subclass / unknown protocol (00/00/00)
-             :  0 - Audio / Control Device / unknown protocol (01/01/00)
-             :  1 - Audio / Streaming / unknown protocol (01/02/00)
-
---------------------------------------------------------------------------------------------------------
-Attach a remote usb device!
-
-   deux:# usbip --attach 10.0.0.3 1-1
-   port 0 attached
-
---------------------------------------------------------------------------------------------------------
-Show what devices are attached to this client.
-
-   deux:# usbip --port
-   Port 00: <Port in Use> at Full Speed(12Mbps)
-          Prolific Technology, Inc. : unknown product (067b:3507)
-          6-1 -> usbip://10.0.0.3:3240/1-1  (remote bus/dev 001/004)
-          6-1:1.0 used by usb-storage
-                         /sys/class/scsi_device/0:0:0:0/device
-                         /sys/class/scsi_host/host0/device
-                         /sys/block/sda/device
-
---------------------------------------------------------------------------------------------------------
-Detach the imported device.
-
-   deux:# usbip --detach 0
-   port 0 detached
-
---------------------------------------------------------------------------------------------------------
-
-
-[Check List]
-    - See Debug Tips in the project wiki.
-        - http://usbip.wiki.sourceforge.net/how-to-debug-usbip
+	     : /sys/devices/pci0000:00/0000:00:1f.2/usb1/1-2/1-2.2/1-2.2.3
+	     : (Defined at Interface level) / unknown subclass / unknown protocol (00/00/00)
+	     :	0 - Vendor Specific Class / unknown subclass / unknown protocol (ff/00/00)
+
+	  3-1: Logitech, Inc. : QuickCam Pro 4000 (046d:08b2)
+	     : /sys/devices/pci0000:00/0000:00:1e.0/0000:02:0a.0/usb3/3-1
+	     : (Defined at Interface level) / unknown subclass / unknown protocol (00/00/00)
+	     :	0 - Data / unknown subclass / unknown protocol (0a/ff/00)
+	     :	1 - Audio / Control Device / unknown protocol (01/01/00)
+	     :	2 - Audio / Streaming / unknown protocol (01/02/00)
+
+Attach a remote USB device:
+
+    deux:# usbip attach --host 10.0.0.3 --busid 1-1
+    port 0 attached
+
+Show the devices attached to this client:
+
+    deux:# usbip port
+    Port 00: <Port in Use> at Full Speed(12Mbps)
+	   Prolific Technology, Inc. : unknown product (067b:3507)
+	   6-1 -> usbip://10.0.0.3:3240/1-1  (remote bus/dev 001/004)
+	   6-1:1.0 used by usb-storage
+			  /sys/class/scsi_device/0:0:0:0/device
+			  /sys/class/scsi_host/host0/device
+			  /sys/block/sda/device
+
+Detach the imported device:
+
+    deux:# usbip detach --port 0
+    port 0 detached
+
+
+[Checklist]
+    - See 'Debug Tips' on the project wiki.
+	- http://usbip.wiki.sourceforge.net/how-to-debug-usbip
     - usbip-host.ko must be bound to the target device.
-        - See /proc/bus/usb/devices and find "Driver=..." lines of the device.
+	- See /proc/bus/usb/devices and find "Driver=..." lines of the device.
     - Shutdown firewall.
-        - usbip now uses TCP port 3240.
+	- usbip now uses TCP port 3240.
     - Disable SELinux.
-    - If possible, compile your kernel with CONFIG_USB_DEBUG flag and try
-      again.
-    - Check your kernel and daemon messages.
-        ex. /var/log/{messages, kern.log, daemon.log, syslog}
+    - If possible, compile your kernel with CONFIG_USB_DEBUG flag and try again.
+    - Check the kernel and daemon messages.
 
 
 [Contact]
-    Mailing List: usbip-devel _at_ lists.sourceforge.net
+    Mailing List: linux-usb@vger.kernel.org
-- 
1.7.5.2

