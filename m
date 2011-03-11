Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab1CKAvH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 19:51:07 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:49528 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823Ab1CKAvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 19:51:05 -0500
Date: Thu, 10 Mar 2011 16:49:56 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2 -next] usb-storage: fix menu ordering
Message-Id: <20110310164956.0acdd33b.randy.dunlap@oracle.com>
In-Reply-To: <20110310180934.95f4f607.sfr@canb.auug.org.au>
References: <20110310180934.95f4f607.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4D7971F4.0073,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Move the USB_STORAGE_ENE_UB6250 entry so that it stays under the
USB_STORAGE menu.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/usb/storage/Kconfig |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

--- linux-next-20110310.orig/drivers/usb/storage/Kconfig
+++ linux-next-20110310/drivers/usb/storage/Kconfig
@@ -182,6 +182,21 @@ config USB_STORAGE_CYPRESS_ATACB
 
 	  If this driver is compiled as a module, it will be named ums-cypress.
 
+config USB_STORAGE_ENE_UB6250
+	tristate "USB ENE card reader support"
+	depends on USB && SCSI
+	depends on USB_STORAGE
+	---help---
+	  Say Y here if you wish to control a ENE SD Card reader.
+	  To use SM/MS card, please build driver/staging/keucr/keucr.ko
+
+	  This option depends on 'SCSI' support being enabled, but you
+	  probably also need 'SCSI device support: SCSI disk support'
+	  (BLK_DEV_SD) for most USB storage devices.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called ums-eneub6250.
+
 config USB_UAS
 	tristate "USB Attached SCSI"
 	depends on USB && SCSI
@@ -208,18 +223,3 @@ config USB_LIBUSUAL
 		options libusual bias="ub"
 
 	  If unsure, say N.
-
-config USB_STORAGE_ENE_UB6250
-	tristate "USB ENE card reader support"
-	depends on USB && SCSI
-	depends on USB_STORAGE
-	---help---
-	  Say Y here if you wish to control a ENE SD Card reader.
-	  To use SM/MS card, please build driver/staging/keucr/keucr.ko
-
-	  This option depends on 'SCSI' support being enabled, but you
-	  probably also need 'SCSI device support: SCSI disk support'
-	  (BLK_DEV_SD) for most USB storage devices.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called ums-eneub6250.
