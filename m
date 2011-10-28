Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039Ab1J1Rw5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 13:52:57 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:48696 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754895Ab1J1Rwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 13:52:54 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: dwmw2@infradead.org, dedekind1@gmail.com, mikedunn@newsguy.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH 07/13] mtd/docg3: add registers for erasing and writing
Date: Fri, 28 Oct 2011 19:51:26 +0200
Message-Id: <1319824292-11085-8-git-send-email-robert.jarzmik@free.fr>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1319824292-11085-1-git-send-email-robert.jarzmik@free.fr>
References: <1319824292-11085-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the required registers and commands to erase and write
flash pages / blocks.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/mtd/devices/docg3.h |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/devices/docg3.h b/drivers/mtd/devices/docg3.h
index 75df3a1..e9967ab 100644
--- a/drivers/mtd/devices/docg3.h
+++ b/drivers/mtd/devices/docg3.h
@@ -130,6 +130,8 @@
 #define DOC_SEQ_SET_PLANE1		0x0e
 #define DOC_SEQ_SET_PLANE2		0x10
 #define DOC_SEQ_PAGE_SETUP		0x1d
+#define DOC_SEQ_ERASE			0x27
+#define DOC_SEQ_PLANES_STATUS		0x31
 
 /*
  * Flash commands
@@ -144,7 +146,10 @@
 #define DOC_CMD_PROG_BLOCK_ADDR		0x60
 #define DOC_CMD_PROG_CYCLE1		0x80
 #define DOC_CMD_PROG_CYCLE2		0x10
+#define DOC_CMD_PROG_CYCLE3		0x11
 #define DOC_CMD_ERASECYCLE2		0xd0
+#define DOC_CMD_READ_STATUS		0x70
+#define DOC_CMD_PLANES_STATUS		0x71
 
 #define DOC_CMD_RELIABLE_MODE		0x22
 #define DOC_CMD_FAST_MODE		0xa2
@@ -186,7 +191,7 @@
  */
 #define DOC_ECCCONF1_BCH_SYNDROM_ERR	0x80
 #define DOC_ECCCONF1_UNKOWN1		0x40
-#define DOC_ECCCONF1_UNKOWN2		0x20
+#define DOC_ECCCONF1_PAGE_IS_WRITTEN	0x20
 #define DOC_ECCCONF1_UNKOWN3		0x10
 #define DOC_ECCCONF1_HAMMING_BITS_MASK	0x0f
 
@@ -224,6 +229,13 @@
 #define DOC_READADDR_ONE_BYTE		0x4000
 #define DOC_READADDR_ADDR_MASK		0x1fff
 
+/*
+ * Status of erase and write operation
+ */
+#define DOC_PLANES_STATUS_FAIL		0x01
+#define DOC_PLANES_STATUS_PLANE0_KO	0x02
+#define DOC_PLANES_STATUS_PLANE1_KO	0x04
+
 /**
  * struct docg3 - DiskOnChip driver private data
  * @dev: the device currently under control
-- 
1.7.5.4

