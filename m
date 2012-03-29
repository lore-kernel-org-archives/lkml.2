Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759670Ab2C2Qqc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 12:46:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41188 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759608Ab2C2Qpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 12:45:53 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 13/13] edac: use Documentation-nano format for some data structs
Date: Thu, 29 Mar 2012 13:45:46 -0300
Message-Id: <1333039546-5590-14-git-send-email-mchehab@redhat.com>
In-Reply-To: <1333039546-5590-1-git-send-email-mchehab@redhat.com>
References: <1333039546-5590-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes. Just comment improvements.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 include/linux/edac.h |   80 +++++++++++++++++++++++++++++++++++--------------
 1 files changed, 57 insertions(+), 23 deletions(-)

diff --git a/include/linux/edac.h b/include/linux/edac.h
index 29899ad..21f37f7 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -45,7 +45,19 @@ static inline void opstate_init(void)
 #define EDAC_MC_LABEL_LEN	31
 #define MC_PROC_NAME_MAX_LEN	7
 
-/* memory devices */
+/**
+ * enum dev_type - describe the type of memory DRAM chips used at the stick
+ * @DEV_UNKNOWN:	Can't be determined, or MC doesn't support detect it
+ * @DEV_X1:		1 bit for data
+ * @DEV_X2:		2 bits for data
+ * @DEV_X4:		4 bits for data
+ * @DEV_X8:		8 bits for data
+ * @DEV_X16:		16 bits for data
+ * @DEV_X32:		32 bits for data
+ * @DEV_X64:		64 bits for data
+ *
+ * Typical values are x4 and x8.
+ */
 enum dev_type {
 	DEV_UNKNOWN = 0,
 	DEV_X1,
@@ -163,18 +175,29 @@ enum mem_type {
 #define MEM_FLAG_DDR3		 BIT(MEM_DDR3)
 #define MEM_FLAG_RDDR3		 BIT(MEM_RDDR3)
 
-/* chipset Error Detection and Correction capabilities and mode */
+/** enum edac-type - Error Detection and Correction capabilities and mode
+ * @EDAC_UNKNOWN:	Unknown if ECC is available
+ * @EDAC_NONE:		Doesn't support ECC
+ * @EDAC_RESERVED:	Reserved ECC type
+ * @EDAC_PARITY:	Detects parity errors
+ * @EDAC_EC:		Error Checking - no correction
+ * @EDAC_SECDED:	Single bit error correction, Double detection
+ * @EDAC_S2ECD2ED:	Chipkill x2 devices - do these exist?
+ * @EDAC_S4ECD4ED:	Chipkill x4 devices
+ * @EDAC_S8ECD8ED:	Chipkill x8 devices
+ * @EDAC_S16ECD16ED:	Chipkill x16 devices
+ */
 enum edac_type {
-	EDAC_UNKNOWN = 0,	/* Unknown if ECC is available */
-	EDAC_NONE,		/* Doesn't support ECC */
-	EDAC_RESERVED,		/* Reserved ECC type */
-	EDAC_PARITY,		/* Detects parity errors */
-	EDAC_EC,		/* Error Checking - no correction */
-	EDAC_SECDED,		/* Single bit error correction, Double detection */
-	EDAC_S2ECD2ED,		/* Chipkill x2 devices - do these exist? */
-	EDAC_S4ECD4ED,		/* Chipkill x4 devices */
-	EDAC_S8ECD8ED,		/* Chipkill x8 devices */
-	EDAC_S16ECD16ED,	/* Chipkill x16 devices */
+	EDAC_UNKNOWN =	0,
+	EDAC_NONE,
+	EDAC_RESERVED,
+	EDAC_PARITY,
+	EDAC_EC,
+	EDAC_SECDED,
+	EDAC_S2ECD2ED,
+	EDAC_S4ECD4ED,
+	EDAC_S8ECD8ED,
+	EDAC_S16ECD16ED,
 };
 
 #define EDAC_FLAG_UNKNOWN	BIT(EDAC_UNKNOWN)
@@ -187,18 +210,29 @@ enum edac_type {
 #define EDAC_FLAG_S8ECD8ED	BIT(EDAC_S8ECD8ED)
 #define EDAC_FLAG_S16ECD16ED	BIT(EDAC_S16ECD16ED)
 
-/* scrubbing capabilities */
+/** enum scrub_type - scrubbing capabilities
+ * @SCRUB_UNKNOWN		Unknown if scrubber is available
+ * @SCRUB_NONE:			No scrubber
+ * @SCRUB_SW_PROG:		SW progressive (sequential) scrubbing
+ * @SCRUB_SW_SRC:		Software scrub only errors
+ * @SCRUB_SW_PROG_SRC:		Progressive software scrub from an error
+ * @SCRUB_SW_TUNABLE:		Software scrub frequency is tunable
+ * @SCRUB_HW_PROG:		HW progressive (sequential) scrubbing
+ * @SCRUB_HW_SRC:		Hardware scrub only errors
+ * @SCRUB_HW_PROG_SRC:		Progressive hardware scrub from an error
+ * SCRUB_HW_TUNABLE:		Hardware scrub frequency is tunable
+ */
 enum scrub_type {
-	SCRUB_UNKNOWN = 0,	/* Unknown if scrubber is available */
-	SCRUB_NONE,		/* No scrubber */
-	SCRUB_SW_PROG,		/* SW progressive (sequential) scrubbing */
-	SCRUB_SW_SRC,		/* Software scrub only errors */
-	SCRUB_SW_PROG_SRC,	/* Progressive software scrub from an error */
-	SCRUB_SW_TUNABLE,	/* Software scrub frequency is tunable */
-	SCRUB_HW_PROG,		/* HW progressive (sequential) scrubbing */
-	SCRUB_HW_SRC,		/* Hardware scrub only errors */
-	SCRUB_HW_PROG_SRC,	/* Progressive hardware scrub from an error */
-	SCRUB_HW_TUNABLE	/* Hardware scrub frequency is tunable */
+	SCRUB_UNKNOWN =	0,
+	SCRUB_NONE,
+	SCRUB_SW_PROG,
+	SCRUB_SW_SRC,
+	SCRUB_SW_PROG_SRC,
+	SCRUB_SW_TUNABLE,
+	SCRUB_HW_PROG,
+	SCRUB_HW_SRC,
+	SCRUB_HW_PROG_SRC,
+	SCRUB_HW_TUNABLE
 };
 
 #define SCRUB_FLAG_SW_PROG	BIT(SCRUB_SW_PROG)
-- 
1.7.8

