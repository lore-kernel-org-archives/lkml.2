Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab2KPSeP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 13:34:15 -0500
Received: from smtp4.mundo-r.com ([212.51.32.151]:10936 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965Ab2KPSeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 13:34:10 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvwEAAGGplBbdWOb/2dsb2JhbABEwmaBCIMMEoE+E4gRvnSRQAOVfJBDgnA
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net, jens.taprogge@taprogge.org,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 1/2] ipack: move header files to include/linux
Date: Fri, 16 Nov 2012 19:33:45 +0100
Message-Id: <1353090826-11068-1-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move ipack header files to include/linux/ directory where they belong.

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/ipack/carriers/tpci200.h         |    3 +--
 drivers/ipack/devices/ipoctal.c          |    3 ++-
 drivers/ipack/ipack.c                    |    3 ++-
 {drivers/ipack => include/linux}/ipack.h |    2 --
 4 files changed, 5 insertions(+), 6 deletions(-)
 rename {drivers/ipack => include/linux}/ipack.h (99%)

diff --git a/drivers/ipack/carriers/tpci200.h b/drivers/ipack/carriers/tpci200.h
index 8d9be27..a7a151d 100644
--- a/drivers/ipack/carriers/tpci200.h
+++ b/drivers/ipack/carriers/tpci200.h
@@ -20,8 +20,7 @@
 #include <linux/spinlock.h>
 #include <linux/swab.h>
 #include <linux/io.h>
-
-#include "../ipack.h"
+#include <linux/ipack.h>
 
 #define TPCI200_NB_SLOT               0x4
 #define TPCI200_NB_BAR                0x6
diff --git a/drivers/ipack/devices/ipoctal.c b/drivers/ipack/devices/ipoctal.c
index 783f120..7f568e2 100644
--- a/drivers/ipack/devices/ipoctal.c
+++ b/drivers/ipack/devices/ipoctal.c
@@ -22,7 +22,8 @@
 #include <linux/slab.h>
 #include <linux/atomic.h>
 #include <linux/io.h>
-#include "../ipack.h"
+#include <linux/ipack.h>
+#include "../ipack_ids.h"
 #include "ipoctal.h"
 #include "scc2698.h"
 
diff --git a/drivers/ipack/ipack.c b/drivers/ipack/ipack.c
index 6d5079d..cc54983 100644
--- a/drivers/ipack/ipack.c
+++ b/drivers/ipack/ipack.c
@@ -13,7 +13,8 @@
 #include <linux/slab.h>
 #include <linux/idr.h>
 #include <linux/io.h>
-#include "ipack.h"
+#include <linux/ipack.h>
+#include "ipack_ids.h"
 
 #define to_ipack_dev(device) container_of(device, struct ipack_device, dev)
 #define to_ipack_driver(drv) container_of(drv, struct ipack_driver, driver)
diff --git a/drivers/ipack/ipack.h b/include/linux/ipack.h
similarity index 99%
rename from drivers/ipack/ipack.h
rename to include/linux/ipack.h
index 6760bfa..7a0a308 100644
--- a/drivers/ipack/ipack.h
+++ b/include/linux/ipack.h
@@ -13,8 +13,6 @@
 #include <linux/device.h>
 #include <linux/interrupt.h>
 
-#include "ipack_ids.h"
-
 #define IPACK_IDPROM_OFFSET_I			0x01
 #define IPACK_IDPROM_OFFSET_P			0x03
 #define IPACK_IDPROM_OFFSET_A			0x05
-- 
1.7.10.4

