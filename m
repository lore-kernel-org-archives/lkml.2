Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758775Ab2BJAGG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 19:06:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758706Ab2BJABi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 19:01:38 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 18/31] edac.h: Use kernel-doc-nano-HOWTO.txt notation for enums
Date: Thu,  9 Feb 2012 22:01:17 -0200
Message-Id: <1328832090-9166-19-git-send-email-mchehab@redhat.com>
In-Reply-To: <1328832090-9166-1-git-send-email-mchehab@redhat.com>
References: <1328832090-9166-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 include/linux/edac.h |   96 +++++++++++++++++++++++++++++++++++++------------
 1 files changed, 72 insertions(+), 24 deletions(-)

diff --git a/include/linux/edac.h b/include/linux/edac.h
index d9fb796..1d707f4 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -153,7 +153,19 @@ static inline void opstate_init(void)
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
@@ -174,6 +186,19 @@ enum dev_type {
 #define DEV_FLAG_X32		BIT(DEV_X32)
 #define DEV_FLAG_X64		BIT(DEV_X64)
 
+/**
+ * enum hw_event_mc_err_type - type of the detected error
+ *
+ * @HW_EVENT_ERR_CORRECTED:	Corrected Error - Indicates that an ECC
+ * 				corrected error was detected
+ * @HW_EVENT_ERR_UNCORRECTED:	Uncorrected Error - Indicates an error that
+ *				can't be corrected by ECC, but it is not
+ *				factal (maybe it is on an unused memory area,
+ *				or the memory controller could recover from
+ *				it for example, by re-trying the operation).
+ * @HW_EVENT_ERR_FATAL:		Fatal Error - Uncorrected error that could not
+ *				be recovered.
+ */
 enum hw_event_mc_err_type {
 	HW_EVENT_ERR_CORRECTED,
 	HW_EVENT_ERR_UNCORRECTED,
@@ -182,6 +207,7 @@ enum hw_event_mc_err_type {
 
 /**
  * enum hw_event_error_scope - escope of a memory error
+ *
  * @HW_EVENT_ERR_MC:		error can be anywhere inside the MC
  * @HW_EVENT_SCOPE_MC_BRANCH:	error can be on any DIMM inside the branch
  * @HW_EVENT_SCOPE_MC_CHANNEL:	error can be on any DIMM inside the MC channel
@@ -215,7 +241,7 @@ enum hw_event_error_scope {
 };
 
 /**
- * enum mem_type - memory types
+ * enum mem_type - Type of the memory stick
  *
  * @MEM_EMPTY		Empty csrow
  * @MEM_RESERVED:	Reserved csrow type
@@ -319,18 +345,29 @@ enum mem_type {
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
@@ -343,18 +380,29 @@ enum edac_type {
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

