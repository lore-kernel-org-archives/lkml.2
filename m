Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323Ab0KPGDR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 01:03:17 -0500
Received: from mga09.intel.com ([134.134.136.24]:40476 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756275Ab0KPGDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 01:03:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,204,1288594800"; 
   d="scan'208";a="677894639"
Subject: [PATCH]  do not select ACPI_VIDEO in poulsbo stub driver
From: Zhang Rui <rui.zhang@intel.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Joey Lee <jlee@novell.com>, mingo@elte.hu, airlied@redhat.com,
        "Brown, Len" <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Zhang, Rui" <rui.zhang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Nov 2010 14:04:53 +0800
Message-ID: <1289887493.8148.2040.camel@rui>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


the poulsbo stub driver should not select ACPI video driver.

The reason why i915 driver selects ACPI video driver is that it needs some
cooperation between these two drivers during initialization, or else the
system may hang.

So if users want ACPI backlight control, please set CONFIG_ACPI_VIDEO manually.

http://marc.info/?l=linux-acpi&m=128952659018533&w=2

CC: Ingo Molnar <mingo@elte.hu>
CC: Dave Airlie <airlied@redhat.com>
CC: Lee, Chun-Yi <joeyli.kernel@gmail.com>
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/gpu/stub/Kconfig   |   11 +----------
 drivers/gpu/stub/poulsbo.c |    5 +----
 2 files changed, 2 insertions(+), 14 deletions(-)

Index: linux-2.6/drivers/gpu/stub/Kconfig
===================================================================
--- linux-2.6.orig/drivers/gpu/stub/Kconfig
+++ linux-2.6/drivers/gpu/stub/Kconfig
@@ -1,16 +1,7 @@
 config STUB_POULSBO
 	tristate "Intel GMA500 Stub Driver"
 	depends on PCI
-	# Poulsbo stub depends on ACPI_VIDEO when ACPI is enabled
-	# but for select to work, need to select ACPI_VIDEO's dependencies, ick
-	select VIDEO_OUTPUT_CONTROL if ACPI
-	select BACKLIGHT_CLASS_DEVICE if ACPI
-	select INPUT if ACPI
-	select ACPI_VIDEO if ACPI
 	help
 	  Choose this option if you have a system that has Intel GMA500
 	  (Poulsbo) integrated graphics. If M is selected, the module will
-	  be called Poulsbo. This driver is a stub driver for Poulsbo that
-	  will call poulsbo.ko to enable the acpi backlight control sysfs
-	  entry file because there have no poulsbo native driver can support
-	  intel opregion.
+	  be called Poulsbo.
Index: linux-2.6/drivers/gpu/stub/poulsbo.c
===================================================================
--- linux-2.6.orig/drivers/gpu/stub/poulsbo.c
+++ linux-2.6/drivers/gpu/stub/poulsbo.c
@@ -11,8 +11,6 @@
 
 #include <linux/module.h>
 #include <linux/pci.h>
-#include <linux/acpi.h>
-#include <acpi/video.h>
 
 #define DRIVER_NAME "poulsbo"
 
@@ -29,12 +27,11 @@ static DEFINE_PCI_DEVICE_TABLE(pciidlist
 
 static int poulsbo_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
-	return acpi_video_register();
+	return 0;
 }
 
 static void poulsbo_remove(struct pci_dev *pdev)
 {
-	acpi_video_unregister();
 }
 
 static struct pci_driver poulsbo_driver = {


