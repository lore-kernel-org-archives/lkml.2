Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757004Ab2IZPwQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 11:52:16 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47844 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756955Ab2IZPwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 11:52:14 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
        Heinz.Egger@linutronix.de, artem.bityutskiy@linux.intel.com,
        tim.bird@am.sony.com, Richard Weinberger <richard@nod.at>
Subject: [PATCH 10/10] UBI: Wire-up fastmap
Date: Wed, 26 Sep 2012 17:51:50 +0200
Message-Id: <1348674710-102885-11-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1348674710-102885-1-git-send-email-richard@nod.at>
References: <1348674710-102885-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make fastmap known to Kconfig, UBI Makefile and MAINTAINERS.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 MAINTAINERS              |    6 ++++++
 drivers/mtd/ubi/Kconfig  |   20 ++++++++++++++++++++
 drivers/mtd/ubi/Makefile |    1 +
 3 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index fdc0119..7bcade0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7075,6 +7075,12 @@ F:	drivers/mtd/ubi/
 F:	include/linux/mtd/ubi.h
 F:	include/mtd/ubi-user.h
 
+UNSORTED BLOCK IMAGES (UBI) Fastmap
+M:	Richard Weinberger <richard@nod.at>
+L:	linux-mtd@lists.infradead.org
+S:	Maintained
+F:	drivers/mtd/ubi/fastmap.c
+
 USB ACM DRIVER
 M:	Oliver Neukum <oliver@neukum.org>
 L:	linux-usb@vger.kernel.org
diff --git a/drivers/mtd/ubi/Kconfig b/drivers/mtd/ubi/Kconfig
index 271a842..3620f91 100644
--- a/drivers/mtd/ubi/Kconfig
+++ b/drivers/mtd/ubi/Kconfig
@@ -56,6 +56,26 @@ config MTD_UBI_BEB_LIMIT
 
 	  Leave the default value if unsure.
 
+config MTD_UBI_FASTMAP
+	bool "UBI Fastmap (EXPERIMENTAL)"
+	depends on EXPERIMENTAL
+	default n
+	help
+	   Fastmap is a mechanism which allows attaching an UBI device
+	   in nearly constant time.
+	   Instead of scanning the whole MTD device it only has to locate
+	   a checkpoint (called fastmap) on the device.
+	   The on-flash fastmap contains all information needed to attach
+	   the device. Using fastmap makes only sense on large devices where
+	   attaching by scanning takes long. UBI will not automatically install
+	   a fastmap on old images, but you can set the UBI module parameter
+	   fm_autoconvert to 1 if you want so. Please note that fastmap-enabled
+	   images are still usable with UBI implementations without
+	   fastmap support. On typical flash devices the whole fastmap fits
+	   into one PEB. UBI will reserve PEBs to hold two fastmaps.
+
+	   If in doubt, say "N".
+
 config MTD_UBI_GLUEBI
 	tristate "MTD devices emulation driver (gluebi)"
 	help
diff --git a/drivers/mtd/ubi/Makefile b/drivers/mtd/ubi/Makefile
index a0803ac..7ab19ac 100644
--- a/drivers/mtd/ubi/Makefile
+++ b/drivers/mtd/ubi/Makefile
@@ -4,3 +4,4 @@ ubi-y += vtbl.o vmt.o upd.o build.o cdev.o kapi.o eba.o io.o wl.o attach.o
 ubi-y += misc.o debug.o
 
 obj-$(CONFIG_MTD_UBI_GLUEBI) += gluebi.o
+obj-$(CONFIG_MTD_UBI_FASTMAP) += fastmap.o
-- 
1.7.6.5

