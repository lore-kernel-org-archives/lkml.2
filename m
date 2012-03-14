Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761500Ab2CNUwM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 16:52:12 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:38003 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758535Ab2CNUwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 16:52:09 -0400
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Pete Zaitcev <zaitcev@redhat.com>, Jens Axboe <jaxboe@fusionio.com>
Subject: [PATCH] usb/ub: deprecate & schedule for removal the "Low Performance USB Block" driver
Date: Wed, 14 Mar 2012 21:52:51 +0100
Message-Id: <1331758372-9851-1-git-send-email-sebastian@breakpoint.cc>
X-Mailer: git-send-email 1.7.9.1
X-Breakpoint-Spam-Score: -1.0
X-Breakpoint-Spam-Level: -
X-Breakpoint-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Deprecate this driver. All devices which can be handled by this driver
can also be handled by the usb-storage driver.

Cc: Pete Zaitcev <zaitcev@redhat.com>
Cc: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 Documentation/feature-removal-schedule.txt |   15 +++++++++++++++
 drivers/block/Kconfig                      |    2 +-
 drivers/block/ub.c                         |    2 ++
 3 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index a0ffac0..f534828 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -524,3 +524,18 @@ Files:	arch/arm/mach-at91/at91cap9.c
 Why:	The code is not actively maintained and platforms are now hard to find.
 Who:	Nicolas Ferre <nicolas.ferre@atmel.com>
 	Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
+
+----------------------------
+
+What:	Low Performance USB Block driver ("CONFIG_BLK_DEV_UB")
+When:	3.6
+Why:	This driver provides support for USB storage devices like "USB
+	sticks". It translates the requests from the block layer into
+	READ & WRITE requests. It does not use the SCSI layer for device
+	handling and as results sdparm & smartmontool do not work. It
+	does not use libusual which holds various workarounds for
+	certain buggy devices.
+	As of now, it is deactivated in Debian, Fedora and Ubuntu. All
+	current users can switch over to usb-storage (CONFIG_USB_STORAGE)
+	which only drawback is the additional SCSI stack.
+Who:	Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index 4e4c8a4..a796407 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -354,7 +354,7 @@ config BLK_DEV_SX8
 	  Use devices /dev/sx8/$N and /dev/sx8/$Np$M.
 
 config BLK_DEV_UB
-	tristate "Low Performance USB Block driver"
+	tristate "Low Performance USB Block driver (deprecated)"
 	depends on USB
 	help
 	  This driver supports certain USB attached storage devices
diff --git a/drivers/block/ub.c b/drivers/block/ub.c
index 298ac75..fcec022 100644
--- a/drivers/block/ub.c
+++ b/drivers/block/ub.c
@@ -2440,6 +2440,8 @@ static int __init ub_init(void)
 	int rc;
 	int i;
 
+	pr_info("'Low Performance USB Block' driver is deprecated. "
+			"Please switch to usb-storage\n");
 	for (i = 0; i < UB_QLOCK_NUM; i++)
 		spin_lock_init(&ub_qlockv[i]);
 
-- 
1.7.9.1

