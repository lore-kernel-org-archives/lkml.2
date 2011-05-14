Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733Ab1ENK65 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 06:58:57 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63142 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755127Ab1ENK4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 06:56:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ne6+wiW1YoywNrfm1HFEOKy+kvCcsVGq+9sC1AzPnvp/fWsikd7IBo5sdOCERn7B7Y
         GVbT7UIcnRrmaWx5j3wz6C6BbwWZf3lCNi+5Z3m5nPIu9Unf0p4+vfCiFQVoxW6kR2Vm
         h/UwEuzmjJQC0ViKU49noTtsahv8GjI57bYio=
From: matt mooney <mfmooney@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 06/14] staging: usbip: userspace: update module name references
Date: Sat, 14 May 2011 03:55:12 -0700
Message-Id: <fae379ec39548b632db6580ddb26625000ea91fa.1305369176.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1305369175.git.mfm@muteddisk.com>
References: <cover.1305369175.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: matt mooney <mfm@muteddisk.com>

Change all references to the kernel modules to correspond with the new
names.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/userspace/README             |   16 ++++++++--------
 .../usbip/userspace/doc/usbip_bind_driver.8        |    2 +-
 drivers/staging/usbip/userspace/doc/usbipd.8       |    2 +-
 .../staging/usbip/userspace/libsrc/stub_driver.c   |    4 ++--
 .../staging/usbip/userspace/libsrc/vhci_driver.c   |    2 +-
 5 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/usbip/userspace/README b/drivers/staging/usbip/userspace/README
index b0df5cb..2ee84b9 100644
--- a/drivers/staging/usbip/userspace/README
+++ b/drivers/staging/usbip/userspace/README
@@ -34,8 +34,8 @@
 [Usage]
     server:# (Attach your USB device physically.)
 
-    server:# insmod usbip_common_mod.ko
-    server:# insmod usbip.ko
+    server:# insmod usbip-core.ko
+    server:# insmod usbip-host.ko
         - It was formerly named as stub.ko.
 
     server:# usbipd -D
@@ -45,13 +45,13 @@
         - List driver assignments for usb devices.
 
     server:# usbip_bind_driver --usbip 1-2
-        - Bind usbip.ko to the device of busid 1-2.
+        - Bind usbip-host.ko to the device of busid 1-2.
         - A usb device 1-2 is now exportable to other hosts!
         - Use 'usbip_bind_driver --other 1-2' when you want to shutdown exporting
           and use the device locally.
 
 
-    client:# insmod usbip_common_mod.ko
+    client:# insmod usbip-core.ko
     client:# insmod vhci-hcd.ko
         - It was formerly named as vhci.ko.
 
@@ -72,8 +72,8 @@
 --------------------------------------------------------------------------------------------------------
 - SERVER SIDE (physically attach your USB devices to this host) ----------------------------------------
 --------------------------------------------------------------------------------------------------------
-trois:# insmod (somewhere)/usbip_common_mod.ko
-trois:# insmod (somewhere)/usbip.ko
+trois:# insmod (somewhere)/usbip-core.ko
+trois:# insmod (somewhere)/usbip-host.ko
 trois:# usbipd -D
 
 --------------------------------------------------------------------------------------------------------
@@ -132,7 +132,7 @@ Iterate the above operation for other devices if you like.
 First, let's list available remote devices which are marked as exportable in
 the server host.
 
-   deux:# insmod (somewhere)/usbip_common_mod.ko
+   deux:# insmod (somewhere)/usbip-core.ko
    deux:# insmod (somewhere)/vhci_hcd.ko
 
    deux:# usbip --list 10.0.0.3
@@ -200,7 +200,7 @@ Detach the imported device.
 [Check List]
     - See Debug Tips in the project wiki.
         - http://usbip.wiki.sourceforge.net/how-to-debug-usbip
-    - usbip.ko must be bound to the target device.
+    - usbip-host.ko must be bound to the target device.
         - See /proc/bus/usb/devices and find "Driver=..." lines of the device.
     - Shutdown firewall.
         - usbip now uses TCP port 3240.
diff --git a/drivers/staging/usbip/userspace/doc/usbip_bind_driver.8 b/drivers/staging/usbip/userspace/doc/usbip_bind_driver.8
index b91df9b..d43bbd6 100644
--- a/drivers/staging/usbip/userspace/doc/usbip_bind_driver.8
+++ b/drivers/staging/usbip/userspace/doc/usbip_bind_driver.8
@@ -31,7 +31,7 @@ Print usb devices and their drivers in parseable mode
         - List driver assignments for usb devices.
 
     server:# usbip_bind_driver --usbip 1-2
-        - Bind usbip.ko to the device of busid 1-2.
+        - Bind usbip-host.ko to the device of busid 1-2.
         - A usb device 1-2 is now exportable to other hosts!
 
     server:# usbip_bind_driver --other 1-2
diff --git a/drivers/staging/usbip/userspace/doc/usbipd.8 b/drivers/staging/usbip/userspace/doc/usbipd.8
index 3c39520..006559f 100644
--- a/drivers/staging/usbip/userspace/doc/usbipd.8
+++ b/drivers/staging/usbip/userspace/doc/usbipd.8
@@ -52,7 +52,7 @@ USB/IP client can connect and use exported devices.
         - List driver assignments for usb devices.
 
     server:# usbip_bind_driver --usbip 1-2
-        - Bind usbip.ko to the device of busid 1-2.
+        - Bind usbip-host.ko to the device of busid 1-2.
         - A usb device 1-2 is now exportable to other hosts!
         - Use 'usbip_bind_driver --other 1-2' when you want to shutdown exporting and use the device locally.
 
diff --git a/drivers/staging/usbip/userspace/libsrc/stub_driver.c b/drivers/staging/usbip/userspace/libsrc/stub_driver.c
index d4d6936..a1ac067 100644
--- a/drivers/staging/usbip/userspace/libsrc/stub_driver.c
+++ b/drivers/staging/usbip/userspace/libsrc/stub_driver.c
@@ -34,7 +34,7 @@ static struct sysfs_driver *open_sysfs_stub_driver(void)
 
 	stub_driver = sysfs_open_driver_path(stub_driver_path);
 	if (!stub_driver) {
-		err("usbip_common_mod.ko and usbip.ko must be loaded");
+		err("usbip-core.ko and usbip-host.ko must be loaded");
 		return NULL;
 	}
 
@@ -199,7 +199,7 @@ static int refresh_exported_devices(void)
 
 	suinf_list = sysfs_get_driver_devices(stub_driver->sysfs_driver);
 	if (!suinf_list) {
-		printf("Bind usbip.ko to a usb device to be exportable!\n");
+		printf("Bind usbip-host.ko to a usb device to be exportable!\n");
 		goto bye;
 	}
 
diff --git a/drivers/staging/usbip/userspace/libsrc/vhci_driver.c b/drivers/staging/usbip/userspace/libsrc/vhci_driver.c
index 5e54810..db43f8d 100644
--- a/drivers/staging/usbip/userspace/libsrc/vhci_driver.c
+++ b/drivers/staging/usbip/userspace/libsrc/vhci_driver.c
@@ -282,7 +282,7 @@ static int get_hc_busid(char *sysfs_mntpath, char *hc_busid)
         sdriver = sysfs_open_driver_path(sdriver_path);
         if (!sdriver) {
 		info("%s is not found", sdriver_path);
-                info("load usbip_common_mod.ko and vhci-hcd.ko !");
+                info("load usbip-core.ko and vhci-hcd.ko !");
                 return -1;
         }
 
-- 
1.7.5.1

