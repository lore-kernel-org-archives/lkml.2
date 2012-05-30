Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249Ab2E3Bob (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 21:44:31 -0400
Received: from masquerade.micron.com ([137.201.242.130]:20319 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143Ab2E3Boa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 21:44:30 -0400
Message-ID: <4FC57B7B.5050406@micron.com>
Date: Tue, 29 May 2012 18:44:27 -0700
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>
Subject: [PATCH 09/11] mtip32xx: Convert macro definitions for flag bits to
 enum
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-6.800.1017-18936.003
X-TM-AS-Result: No--3.487900-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Convert macro definitions for flags bits to enum

Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
---
 drivers/block/mtip32xx/mtip32xx.h |   48 +++++++++++++++++++-----------------
 1 files changed, 25 insertions(+), 23 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.h b/drivers/block/mtip32xx/mtip32xx.h
index 4ef5833..b2c88da 100644
--- a/drivers/block/mtip32xx/mtip32xx.h
+++ b/drivers/block/mtip32xx/mtip32xx.h
@@ -113,33 +113,35 @@
 
 #define __force_bit2int (unsigned int __force)
 
-/* below are bit numbers in 'flags' defined in mtip_port */
-#define MTIP_PF_IC_ACTIVE_BIT		0 /* pio/ioctl */
-#define MTIP_PF_EH_ACTIVE_BIT		1 /* error handling */
-#define MTIP_PF_SE_ACTIVE_BIT		2 /* secure erase */
-#define MTIP_PF_DM_ACTIVE_BIT		3 /* download microcde */
-#define MTIP_PF_PAUSE_IO	((1 << MTIP_PF_IC_ACTIVE_BIT) | \
+enum {
+	/* below are bit numbers in 'flags' defined in mtip_port */
+	MTIP_PF_IC_ACTIVE_BIT       = 0, /* pio/ioctl */
+	MTIP_PF_EH_ACTIVE_BIT       = 1, /* error handling */
+	MTIP_PF_SE_ACTIVE_BIT       = 2, /* secure erase */
+	MTIP_PF_DM_ACTIVE_BIT       = 3, /* download microcde */
+	MTIP_PF_PAUSE_IO      =	((1 << MTIP_PF_IC_ACTIVE_BIT) | \
 				(1 << MTIP_PF_EH_ACTIVE_BIT) | \
 				(1 << MTIP_PF_SE_ACTIVE_BIT) | \
-				(1 << MTIP_PF_DM_ACTIVE_BIT))
-
-#define MTIP_PF_SVC_THD_ACTIVE_BIT	4
-#define MTIP_PF_ISSUE_CMDS_BIT		5
-#define MTIP_PF_REBUILD_BIT		6
-#define MTIP_PF_SVC_THD_STOP_BIT	8
-
-/* below are bit numbers in 'dd_flag' defined in driver_data */
-#define MTIP_DDF_REMOVE_PENDING_BIT	1
-#define MTIP_DDF_OVER_TEMP_BIT		2
-#define MTIP_DDF_WRITE_PROTECT_BIT	3
-#define MTIP_DDF_STOP_IO	((1 << MTIP_DDF_REMOVE_PENDING_BIT) | \
+				(1 << MTIP_PF_DM_ACTIVE_BIT)),
+
+	MTIP_PF_SVC_THD_ACTIVE_BIT  = 4,
+	MTIP_PF_ISSUE_CMDS_BIT      = 5,
+	MTIP_PF_REBUILD_BIT         = 6,
+	MTIP_PF_SVC_THD_STOP_BIT    = 8,
+
+	/* below are bit numbers in 'dd_flag' defined in driver_data */
+	MTIP_DDF_REMOVE_PENDING_BIT = 1,
+	MTIP_DDF_OVER_TEMP_BIT      = 2,
+	MTIP_DDF_WRITE_PROTECT_BIT  = 3,
+	MTIP_DDF_STOP_IO      = ((1 << MTIP_DDF_REMOVE_PENDING_BIT) | \
 				(1 << MTIP_DDF_OVER_TEMP_BIT) | \
-				(1 << MTIP_DDF_WRITE_PROTECT_BIT))
+				(1 << MTIP_DDF_WRITE_PROTECT_BIT)),
 
-#define MTIP_DDF_CLEANUP_BIT		5
-#define MTIP_DDF_RESUME_BIT		6
-#define MTIP_DDF_INIT_DONE_BIT		7
-#define MTIP_DDF_REBUILD_FAILED_BIT	8
+	MTIP_DDF_CLEANUP_BIT        = 5,
+	MTIP_DDF_RESUME_BIT         = 6,
+	MTIP_DDF_INIT_DONE_BIT      = 7,
+	MTIP_DDF_REBUILD_FAILED_BIT = 8,
+};
 
 __packed struct smart_attr{
 	u8 attr_id;
-- 
1.7.1

