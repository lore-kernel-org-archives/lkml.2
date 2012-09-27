Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341Ab2I0Kg6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 06:36:58 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:61076 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756252Ab2I0Kg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 06:36:56 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkECAEQrZFBbdWObgWdsb2JhbABFvg8jAQEWJieCIAEBBSdSECAxVwYTiAm3b5E1A5VpkxQ
X-IronPort-AV: E=Sophos;i="4.80,496,1344204000"; 
   d="scan'208";a="956447812"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 06/17] Staging: ipack/bridges/tpci200: Cleanups.
Date: Thu, 27 Sep 2012 12:37:30 +0200
Message-Id: <1348742261-28145-6-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1348742261-28145-1-git-send-email-siglesias@igalia.com>
References: <1348742261-28145-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Taprogge <jens.taprogge@taprogge.org>

Constant renames:
 - Rename TPCI200_*_GAP to TPCI200_*_INTERVAL.
 - Rename TPCI200_MEM*_* to TPCI200_MEM*_SPACE_* (to match the other SPACE
   constants.

Make tpci200_status_timeout and tpci200_status_error const.

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |   24 ++++++++++++------------
 drivers/staging/ipack/bridges/tpci200.h |   14 +++++++-------
 2 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index 5acaea2..84e1c27 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -14,14 +14,14 @@
 #include <linux/module.h>
 #include "tpci200.h"
 
-static u16 tpci200_status_timeout[] = {
+static const u16 tpci200_status_timeout[] = {
 	TPCI200_A_TIMEOUT,
 	TPCI200_B_TIMEOUT,
 	TPCI200_C_TIMEOUT,
 	TPCI200_D_TIMEOUT,
 };
 
-static u16 tpci200_status_error[] = {
+static const u16 tpci200_status_error[] = {
 	TPCI200_A_ERROR,
 	TPCI200_B_ERROR,
 	TPCI200_C_ERROR,
@@ -298,7 +298,7 @@ static int tpci200_register(struct tpci200_board *tpci200)
 		ioidint_base + TPCI200_INT_SPACE_OFF;
 	tpci200->mod_mem[IPACK_MEM_SPACE] =
 		pci_resource_start(tpci200->info->pdev,
-				      TPCI200_MEM8_SPACE_BAR);
+				   TPCI200_MEM8_SPACE_BAR);
 
 	/* Set the default parameters of the slot
 	 * INT0 disabled, level sensitive
@@ -313,24 +313,24 @@ static int tpci200_register(struct tpci200_board *tpci200)
 	/* Set all slot physical address space */
 	for (i = 0; i < TPCI200_NB_SLOT; i++) {
 		tpci200->slots[i].io_phys.start =
-			tpci200->mod_mem[IPACK_IO_SPACE] +
-			TPCI200_IO_SPACE_GAP * i;
+			tpci200->mod_mem[IPACK_IO_SPACE]
+			+ TPCI200_IO_SPACE_INTERVAL * i;
 		tpci200->slots[i].io_phys.size = TPCI200_IO_SPACE_SIZE;
 
 		tpci200->slots[i].id_phys.start =
-			tpci200->mod_mem[IPACK_ID_SPACE] +
-			TPCI200_ID_SPACE_GAP * i;
+			tpci200->mod_mem[IPACK_ID_SPACE]
+			+ TPCI200_ID_SPACE_INTERVAL * i;
 		tpci200->slots[i].id_phys.size = TPCI200_ID_SPACE_SIZE;
 
 		tpci200->slots[i].int_phys.start =
-			tpci200->mod_mem[IPACK_INT_SPACE] +
-			TPCI200_INT_SPACE_GAP * i;
+			tpci200->mod_mem[IPACK_INT_SPACE]
+			+ TPCI200_INT_SPACE_INTERVAL * i;
 		tpci200->slots[i].int_phys.size = TPCI200_INT_SPACE_SIZE;
 
 		tpci200->slots[i].mem_phys.start =
-			tpci200->mod_mem[IPACK_MEM_SPACE] +
-			TPCI200_MEM8_GAP * i;
-		tpci200->slots[i].mem_phys.size = TPCI200_MEM8_SIZE;
+			tpci200->mod_mem[IPACK_MEM_SPACE]
+			+ TPCI200_MEM8_SPACE_INTERVAL * i;
+		tpci200->slots[i].mem_phys.size = TPCI200_MEM8_SPACE_SIZE;
 
 		writew(slot_ctrl, &tpci200->info->interface_regs->control[i]);
 	}
diff --git a/drivers/staging/ipack/bridges/tpci200.h b/drivers/staging/ipack/bridges/tpci200.h
index 6b7c700..fe8e97e 100644
--- a/drivers/staging/ipack/bridges/tpci200.h
+++ b/drivers/staging/ipack/bridges/tpci200.h
@@ -49,20 +49,20 @@ struct tpci200_regs {
 #define TPCI200_IFACE_SIZE            0x100
 
 #define TPCI200_IO_SPACE_OFF          0x0000
-#define TPCI200_IO_SPACE_GAP          0x0100
+#define TPCI200_IO_SPACE_INTERVAL     0x0100
 #define TPCI200_IO_SPACE_SIZE         0x0080
 #define TPCI200_ID_SPACE_OFF          0x0080
-#define TPCI200_ID_SPACE_GAP          0x0100
+#define TPCI200_ID_SPACE_INTERVAL     0x0100
 #define TPCI200_ID_SPACE_SIZE         0x0040
 #define TPCI200_INT_SPACE_OFF         0x00C0
-#define TPCI200_INT_SPACE_GAP         0x0100
+#define TPCI200_INT_SPACE_INTERVAL    0x0100
 #define TPCI200_INT_SPACE_SIZE        0x0040
 #define TPCI200_IOIDINT_SIZE          0x0400
 
-#define TPCI200_MEM8_GAP              0x00400000
-#define TPCI200_MEM8_SIZE             0x00400000
-#define TPCI200_MEM16_GAP             0x00800000
-#define TPCI200_MEM16_SIZE            0x00800000
+#define TPCI200_MEM8_SPACE_INTERVAL   0x00400000
+#define TPCI200_MEM8_SPACE_SIZE       0x00400000
+#define TPCI200_MEM16_SPACE_INTERVAL  0x00800000
+#define TPCI200_MEM16_SPACE_SIZE      0x00800000
 
 /* control field in tpci200_regs */
 #define TPCI200_INT0_EN               0x0040
-- 
1.7.10.4

