Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934475Ab0KPM5M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 07:57:12 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:43543 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934459Ab0KPM5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 07:57:09 -0500
From: manjunatha_halli@ti.com
To: mchehab@infradead.org, hverkuil@xs4all.nl
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Manjunatha Halli <manjunatha_halli@ti.com>
Subject: [PATCH v4 6/6] drivers:staging: ti-st: Kconfig & Makefile change
Date: Tue, 16 Nov 2010 08:18:14 -0500
Message-Id: <1289913494-21590-7-git-send-email-manjunatha_halli@ti.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1289913494-21590-6-git-send-email-manjunatha_halli@ti.com>
References: <1289913494-21590-1-git-send-email-manjunatha_halli@ti.com>
 <1289913494-21590-2-git-send-email-manjunatha_halli@ti.com>
 <1289913494-21590-3-git-send-email-manjunatha_halli@ti.com>
 <1289913494-21590-4-git-send-email-manjunatha_halli@ti.com>
 <1289913494-21590-5-git-send-email-manjunatha_halli@ti.com>
 <1289913494-21590-6-git-send-email-manjunatha_halli@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunatha Halli <manjunatha_halli@ti.com>

Add new menu option in Kconfig and compilation option in Makefile
for TI FM driver.

Signed-off-by: Manjunatha Halli <manjunatha_halli@ti.com>
---
 drivers/staging/ti-st/Kconfig  |   10 ++++++++++
 drivers/staging/ti-st/Makefile |    2 ++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/ti-st/Kconfig b/drivers/staging/ti-st/Kconfig
index 074b8e8..43b6dea 100644
--- a/drivers/staging/ti-st/Kconfig
+++ b/drivers/staging/ti-st/Kconfig
@@ -11,4 +11,14 @@ config ST_BT
 	  This enables the Bluetooth driver for TI BT/FM/GPS combo devices.
 	  This makes use of shared transport line discipline core driver to
 	  communicate with the BT core of the combo chip.
+
+config ST_FM
+        tristate "fm driver for ST"
+        depends on VIDEO_DEV && RFKILL
+        select TI_ST
+        help
+          This enables the FM driver for TI BT/FM/GPS combo devices.
+          This makes use of shared transport line discipline core driver to
+          communicate with the FM core of the combo chip.
+
 endmenu
diff --git a/drivers/staging/ti-st/Makefile b/drivers/staging/ti-st/Makefile
index 5f11b82..330f95b 100644
--- a/drivers/staging/ti-st/Makefile
+++ b/drivers/staging/ti-st/Makefile
@@ -3,3 +3,5 @@
 # and its protocol drivers (BT, FM, GPS)
 #
 obj-$(CONFIG_ST_BT) 		+= bt_drv.o
+obj-$(CONFIG_ST_FM) 		+= fm_drv.o
+fm_drv-objs     		:= fmdrv_common.o fmdrv_rx.o fmdrv_tx.o fmdrv_v4l2.o
-- 
1.5.6.3

