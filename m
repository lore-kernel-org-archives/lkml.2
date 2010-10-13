Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910Ab0JMQi5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 12:38:57 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:57514 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab0JMQi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 12:38:56 -0400
From: Bernhard Walle <walle@corscience.de>
To: ddaney@caviumnetworks.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: octeon: Remove USB code
Date: Wed, 13 Oct 2010 18:38:38 +0200
Message-Id: <1286987918-16691-1-git-send-email-walle@corscience.de>
X-Mailer: git-send-email 1.7.1
X-Provags-ID: V02:K0:uV6c6Ukrj3bFh6yfrYDZFcZZfYLe/S0LhZ7+7Eminkd
 ThS4iEfGrJ9FggyaKcs/5/4xvJOSVGAaKfxOjxPw2Cd48i5viU
 uNBPpljVxoXlmFu00NKfK6FYj/6Z0/Ow+bqHXx8SX6ac8LzwO2
 3R9Mon/Ujrmw//WHH61SvvSxB90dMeYk7q/30nImYfkVTn6Bh6
 O008vdcZU37EzYYbhjivg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove functions and definitions that refer to USB since the driver
doesn't support USB and it's not planned to add USB support to that
driver. So the code is just dead code which can be removed.

Signed-off-by: Bernhard Walle <walle@corscience.de>
---
 drivers/staging/octeon/cvmx-helper-board.c |   19 ------------------
 drivers/staging/octeon/cvmx-helper-board.h |   29 ----------------------------
 2 files changed, 0 insertions(+), 48 deletions(-)

diff --git a/drivers/staging/octeon/cvmx-helper-board.c b/drivers/staging/octeon/cvmx-helper-board.c
index 00a555b..57d35dc 100644
--- a/drivers/staging/octeon/cvmx-helper-board.c
+++ b/drivers/staging/octeon/cvmx-helper-board.c
@@ -693,22 +693,3 @@ int __cvmx_helper_board_hardware_enable(int interface)
 	}
 	return 0;
 }
-
-cvmx_helper_board_usb_clock_types_t __cvmx_helper_board_usb_get_clock_type(void)
-{
-	switch (cvmx_sysinfo_get()->board_type) {
-	case CVMX_BOARD_TYPE_BBGW_REF:
-		return USB_CLOCK_TYPE_CRYSTAL_12;
-	}
-	return USB_CLOCK_TYPE_REF_48;
-}
-
-int __cvmx_helper_board_usb_get_num_ports(int supported_ports)
-{
-	switch (cvmx_sysinfo_get()->board_type) {
-	case CVMX_BOARD_TYPE_NIC_XLE_4G:
-		return 0;
-	}
-
-	return supported_ports;
-}
diff --git a/drivers/staging/octeon/cvmx-helper-board.h b/drivers/staging/octeon/cvmx-helper-board.h
index dc20b01..611a8e0 100644
--- a/drivers/staging/octeon/cvmx-helper-board.h
+++ b/drivers/staging/octeon/cvmx-helper-board.h
@@ -37,13 +37,6 @@
 #include "cvmx-helper.h"
 
 typedef enum {
-	USB_CLOCK_TYPE_REF_12,
-	USB_CLOCK_TYPE_REF_24,
-	USB_CLOCK_TYPE_REF_48,
-	USB_CLOCK_TYPE_CRYSTAL_12,
-} cvmx_helper_board_usb_clock_types_t;
-
-typedef enum {
 	set_phy_link_flags_autoneg = 0x1,
 	set_phy_link_flags_flow_control_dont_touch = 0x0 << 1,
 	set_phy_link_flags_flow_control_enable = 0x1 << 1,
@@ -155,26 +148,4 @@ extern int __cvmx_helper_board_interface_probe(int interface,
  */
 extern int __cvmx_helper_board_hardware_enable(int interface);
 
-/**
- * Gets the clock type used for the USB block based on board type.
- * Used by the USB code for auto configuration of clock type.
- *
- * Returns USB clock type enumeration
- */
-cvmx_helper_board_usb_clock_types_t
-__cvmx_helper_board_usb_get_clock_type(void);
-
-/**
- * Adjusts the number of available USB ports on Octeon based on board
- * specifics.
- *
- * @supported_ports: expected number of ports based on chip type;
- *
- *
- * Returns number of available usb ports, based on board specifics.
- *         Return value is supported_ports if function does not
- *         override.
- */
-int __cvmx_helper_board_usb_get_num_ports(int supported_ports);
-
 #endif /* __CVMX_HELPER_BOARD_H__ */
-- 
1.7.1

