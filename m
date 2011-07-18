Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab1GRI21 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 04:28:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:42451 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753348Ab1GRI20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 04:28:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,221,1309762800"; 
   d="scan'208";a="29177857"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        James Bottomley <jbottomley@parallels.com>
Subject: [PATCH 1/2] scsi: target: fix typo Assoication -> Association
Date: Mon, 18 Jul 2011 11:27:56 +0300
Message-Id: <f051412fa68688dea6d9445d66fbd8085a07bdb7.1310977653.git.andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Additionally this patch brings proper apply of the designator type.
However, the original code luckily has no bug, because the association
equals to 0.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: James Bottomley <jbottomley@parallels.com>
---
 drivers/target/target_core_cdb.c      |   10 +++++-----
 drivers/target/target_core_configfs.c |    2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_cdb.c b/drivers/target/target_core_cdb.c
index 7f19c8b..4dab9f5 100644
--- a/drivers/target/target_core_cdb.c
+++ b/drivers/target/target_core_cdb.c
@@ -210,11 +210,11 @@ target_emulate_evpd_83(struct se_cmd *cmd, unsigned char *buf)
 	/* CODE SET == Binary */
 	buf[off++] = 0x1;
 
-	/* Set ASSOICATION == addressed logical unit: 0)b */
+	/* Set ASSOCIATION == addressed logical unit: 00b */
 	buf[off] = 0x00;
 
 	/* Identifier/Designator type == NAA identifier */
-	buf[off++] = 0x3;
+	buf[off++] |= 0x3;
 	off++;
 
 	/* Identifier/Designator length */
@@ -315,7 +315,7 @@ check_port:
 			(TPG_TFO(tpg)->get_fabric_proto_ident(tpg) << 4);
 		buf[off++] |= 0x1; /* CODE SET == Binary */
 		buf[off] = 0x80; /* Set PIV=1 */
-		/* Set ASSOICATION == target port: 01b */
+		/* Set ASSOCIATION == target port: 01b */
 		buf[off] |= 0x10;
 		/* DESIGNATOR TYPE == Relative target port identifer */
 		buf[off++] |= 0x4;
@@ -360,7 +360,7 @@ check_tpgi:
 			(TPG_TFO(tpg)->get_fabric_proto_ident(tpg) << 4);
 		buf[off++] |= 0x1; /* CODE SET == Binary */
 		buf[off] = 0x80; /* Set PIV=1 */
-		/* Set ASSOICATION == target port: 01b */
+		/* Set ASSOCIATION == target port: 01b */
 		buf[off] |= 0x10;
 		/* DESIGNATOR TYPE == Target port group identifier */
 		buf[off++] |= 0x5;
@@ -427,7 +427,7 @@ check_scsi_name:
 			(TPG_TFO(tpg)->get_fabric_proto_ident(tpg) << 4);
 		buf[off++] |= 0x3; /* CODE SET == UTF-8 */
 		buf[off] = 0x80; /* Set PIV=1 */
-		/* Set ASSOICATION == target port: 01b */
+		/* Set ASSOCIATION == target port: 01b */
 		buf[off] |= 0x10;
 		/* DESIGNATOR TYPE == SCSI name string */
 		buf[off++] |= 0x8;
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 25c1f49..2ad4729 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -984,7 +984,7 @@ static ssize_t target_core_dev_wwn_show_attr_##_name(			\
 }
 
 /*
- * VPD page 0x83 Assoication: Logical Unit
+ * VPD page 0x83 Association: Logical Unit
  */
 DEF_DEV_WWN_ASSOC_SHOW(vpd_assoc_logical_unit, 0x00);
 
-- 
1.7.5.4

