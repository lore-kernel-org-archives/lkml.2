Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672Ab2I0KiM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 06:38:12 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:21131 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756353Ab2I0Kg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 06:36:59 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkECAEQrZFBbdWObgWdsb2JhbABFvg8jAQEWJieCIAEBBWcSECAxVwYTiAm3b5E1A5VpkxSBWCE
X-IronPort-AV: E=Sophos;i="4.80,496,1344204000"; 
   d="scan'208";a="956447840"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 16/17] staging: ipack: Documentation cleanups.
Date: Thu, 27 Sep 2012 12:37:40 +0200
Message-Id: <1348742261-28145-16-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1348742261-28145-1-git-send-email-siglesias@igalia.com>
References: <1348742261-28145-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Taprogge <jens.taprogge@taprogge.org>

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/Kconfig          |   13 ++++++++-----
 drivers/staging/ipack/carriers/Kconfig |    4 ++--
 drivers/staging/ipack/ipack.h          |   15 ++++++++-------
 3 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/ipack/Kconfig b/drivers/staging/ipack/Kconfig
index 9b4495a..5cf43b3 100644
--- a/drivers/staging/ipack/Kconfig
+++ b/drivers/staging/ipack/Kconfig
@@ -6,11 +6,14 @@ menuconfig IPACK_BUS
 	tristate "IndustryPack bus support"
 	depends on HAS_IOMEM
 	---help---
-	  If you say Y here you get support for the IndustryPack Framework
-	  for drivers for many types of boards that support this industrial
-	  bus. The IndustryPack Framework is a virtual bus allowing to
-	  communicate between carrier and mezzanine cards connected through
-	  this bus.
+	  This option provides support for the IndustryPack framework.  There
+	  are IndustryPack carrier boards, which interface another bus (such as
+	  PCI) to an IndustryPack bus, and IndustryPack modules, that are
+	  hosted on these buses.  While IndustryPack modules can provide a
+	  large variety of functionality, they are most often found in
+	  industrial control applications.
+
+	  Say N if unsure.
 
 if IPACK_BUS
 
diff --git a/drivers/staging/ipack/carriers/Kconfig b/drivers/staging/ipack/carriers/Kconfig
index 33fdc24..922ff5c 100644
--- a/drivers/staging/ipack/carriers/Kconfig
+++ b/drivers/staging/ipack/carriers/Kconfig
@@ -1,7 +1,7 @@
 config BOARD_TPCI200
-	tristate "TEWS TPCI-200 support for IndustryPack bus"
+	tristate "Support for the TEWS TPCI-200 IndustryPack carrier board"
 	depends on IPACK_BUS
 	depends on PCI
 	help
-	  This driver supports the TEWS TPCI200 device for the IndustryPack bus.
+	  This driver adds support for the TEWS TPCI200 IndustryPack carrier board.
 	default n
diff --git a/drivers/staging/ipack/ipack.h b/drivers/staging/ipack/ipack.h
index 689af92..7ca8789 100644
--- a/drivers/staging/ipack/ipack.h
+++ b/drivers/staging/ipack/ipack.h
@@ -80,10 +80,11 @@ struct ipack_device {
 };
 
 /**
- *	struct ipack_driver_ops -- callbacks to mezzanine driver for installing/removing one device
+ * struct ipack_driver_ops -- Callbacks to IPack device driver
  *
- *	@probe: Probe function
- *	@remove: tell the driver that the carrier board wants to remove one device
+ * @probe:  Probe function
+ * @remove: Prepare imminent removal of the device.  Services provided by the
+ *          device should be revoked.
  */
 
 struct ipack_driver_ops {
@@ -92,10 +93,10 @@ struct ipack_driver_ops {
 };
 
 /**
- *	struct ipack_driver -- Specific data to each ipack board driver
+ * struct ipack_driver -- Specific data to each ipack device driver
  *
- *	@driver: Device driver kernel representation
- *	@ops: Mezzanine driver operations specific for the ipack bus.
+ * @driver: Device driver kernel representation
+ * @ops:    Callbacks provided by the IPack device driver
  */
 struct ipack_driver {
 	struct device_driver driver;
@@ -165,7 +166,7 @@ struct ipack_bus_device *ipack_bus_register(struct device *parent, int slots,
 int ipack_bus_unregister(struct ipack_bus_device *bus);
 
 /**
- *	ipack_driver_register -- Register a new driver
+ * ipack_driver_register -- Register a new ipack device driver
  *
  * Called by a ipack driver to register itself as a driver
  * that can manage ipack devices.
-- 
1.7.10.4

