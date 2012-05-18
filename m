Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965009Ab2ERQld (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 12:41:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23248 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758613Ab2ERQdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 12:33:07 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>
Subject: [PATCH EDAC v26 62/66] edac: Use more normal debugging macro style
Date: Fri, 18 May 2012 13:32:49 -0300
Message-Id: <1337358773-6919-63-git-send-email-mchehab@redhat.com>
In-Reply-To: <1337358773-6919-1-git-send-email-mchehab@redhat.com>
References: <1337358773-6919-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>

Convert macros to a simpler style and enforce appropriate
format checking when not CONFIG_EDAC_DEBUG.

Use fmt and __VA_ARGS__, neaten macros.

Move some string arrays to the debugfx uses and remove the
now unnecessary CONFIG_EDAC_DEBUG variable block definitions.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/edac_core.h  |   35 ++++++++++++++++++-----------------
 drivers/edac/i5000_edac.c |   30 +++++++++++-------------------
 drivers/edac/i5400_edac.c |   30 ++++++++++--------------------
 drivers/edac/i7300_edac.c |   30 ++++++++++--------------------
 4 files changed, 49 insertions(+), 76 deletions(-)

diff --git a/drivers/edac/edac_core.h b/drivers/edac/edac_core.h
index eee7360..47d3684 100644
--- a/drivers/edac/edac_core.h
+++ b/drivers/edac/edac_core.h
@@ -71,29 +71,30 @@ extern const char *edac_mem_types[];
 #ifdef CONFIG_EDAC_DEBUG
 extern int edac_debug_level;
 
-#define edac_debug_printk(level, fmt, arg...)                           \
-	do {                                                            \
-		if (level <= edac_debug_level)                          \
-			edac_printk(KERN_DEBUG, EDAC_DEBUG,		\
-				    "%s: " fmt, __func__, ##arg);	\
-	} while (0)
-
-#define debugf0( ... ) edac_debug_printk(0, __VA_ARGS__ )
-#define debugf1( ... ) edac_debug_printk(1, __VA_ARGS__ )
-#define debugf2( ... ) edac_debug_printk(2, __VA_ARGS__ )
-#define debugf3( ... ) edac_debug_printk(3, __VA_ARGS__ )
-#define debugf4( ... ) edac_debug_printk(4, __VA_ARGS__ )
+#define edac_debug_printk(level, fmt, ...)				\
+do {									\
+	if (level <= edac_debug_level)					\
+		edac_printk(KERN_DEBUG, EDAC_DEBUG,			\
+			    "%s: " fmt, __func__, ##__VA_ARGS__);	\
+} while (0)
 
 #else				/* !CONFIG_EDAC_DEBUG */
 
-#define debugf0( ... )
-#define debugf1( ... )
-#define debugf2( ... )
-#define debugf3( ... )
-#define debugf4( ... )
+#define edac_debug_printk(level, fmt, ...)				\
+do {									\
+	if (0)								\
+		edac_printk(KERN_DEBUG, EDAC_DEBUG,			\
+			    "%s: " fmt, __func__, ##__VA_ARGS__);	\
+} while (0)
 
 #endif				/* !CONFIG_EDAC_DEBUG */
 
+#define debugf0(fmt, ...) edac_debug_printk(0, fmt, ##__VA_ARGS__)
+#define debugf1(fmt, ...) edac_debug_printk(1, fmt, ##__VA_ARGS__)
+#define debugf2(fmt, ...) edac_debug_printk(2, fmt, ##__VA_ARGS__)
+#define debugf3(fmt, ...) edac_debug_printk(3, fmt, ##__VA_ARGS__)
+#define debugf4(fmt, ...) edac_debug_printk(4, fmt, ##__VA_ARGS__)
+
 #define PCI_VEND_DEV(vend, dev) PCI_VENDOR_ID_ ## vend, \
 	PCI_DEVICE_ID_ ## vend ## _ ## dev
 
diff --git a/drivers/edac/i5000_edac.c b/drivers/edac/i5000_edac.c
index 4a5ca52..0e16db6 100644
--- a/drivers/edac/i5000_edac.c
+++ b/drivers/edac/i5000_edac.c
@@ -273,7 +273,7 @@
 #define CHANNELS_PER_BRANCH	2
 #define MAX_BRANCHES		2
 
-/* Defines to extract the vaious fields from the
+/* Defines to extract the various fields from the
  *	MTRx - Memory Technology Registers
  */
 #define MTR_DIMMS_PRESENT(mtr)		((mtr) & (0x1 << 8))
@@ -287,22 +287,6 @@
 #define MTR_DIMM_COLS(mtr)		((mtr) & 0x3)
 #define MTR_DIMM_COLS_ADDR_BITS(mtr)	(MTR_DIMM_COLS(mtr) + 10)
 
-#ifdef CONFIG_EDAC_DEBUG
-static char *numrow_toString[] = {
-	"8,192 - 13 rows",
-	"16,384 - 14 rows",
-	"32,768 - 15 rows",
-	"reserved"
-};
-
-static char *numcol_toString[] = {
-	"1,024 - 10 columns",
-	"2,048 - 11 columns",
-	"4,096 - 12 columns",
-	"reserved"
-};
-#endif
-
 /* enables the report of miscellaneous messages as CE errors - default off */
 static int misc_messages;
 
@@ -989,8 +973,16 @@ static void decode_mtr(int slot_row, u16 mtr)
 	debugf2("\t\tWIDTH: x%d\n", MTR_DRAM_WIDTH(mtr));
 	debugf2("\t\tNUMBANK: %d bank(s)\n", MTR_DRAM_BANKS(mtr));
 	debugf2("\t\tNUMRANK: %s\n", MTR_DIMM_RANK(mtr) ? "double" : "single");
-	debugf2("\t\tNUMROW: %s\n", numrow_toString[MTR_DIMM_ROWS(mtr)]);
-	debugf2("\t\tNUMCOL: %s\n", numcol_toString[MTR_DIMM_COLS(mtr)]);
+	debugf2("\t\tNUMROW: %s\n",
+		MTR_DIMM_ROWS(mtr) == 0 ? "8,192 - 13 rows" :
+		MTR_DIMM_ROWS(mtr) == 1 ? "16,384 - 14 rows" :
+		MTR_DIMM_ROWS(mtr) == 2 ? "32,768 - 15 rows" :
+		"reserved");
+	debugf2("\t\tNUMCOL: %s\n",
+		MTR_DIMM_COLS(mtr) == 0 ? "1,024 - 10 columns" :
+		MTR_DIMM_COLS(mtr) == 1 ? "2,048 - 11 columns" :
+		MTR_DIMM_COLS(mtr) == 2 ? "4,096 - 12 columns" :
+		"reserved");
 }
 
 static void handle_channel(struct i5000_pvt *pvt, int slot, int channel,
diff --git a/drivers/edac/i5400_edac.c b/drivers/edac/i5400_edac.c
index be1880d..3004b94 100644
--- a/drivers/edac/i5400_edac.c
+++ b/drivers/edac/i5400_edac.c
@@ -300,24 +300,6 @@ static inline int extract_fbdchan_indx(u32 x)
 	return (x>>28) & 0x3;
 }
 
-#ifdef CONFIG_EDAC_DEBUG
-/* MTR NUMROW */
-static const char *numrow_toString[] = {
-	"8,192 - 13 rows",
-	"16,384 - 14 rows",
-	"32,768 - 15 rows",
-	"65,536 - 16 rows"
-};
-
-/* MTR NUMCOL */
-static const char *numcol_toString[] = {
-	"1,024 - 10 columns",
-	"2,048 - 11 columns",
-	"4,096 - 12 columns",
-	"reserved"
-};
-#endif
-
 /* Device name and register DID (Device ID) */
 struct i5400_dev_info {
 	const char *ctl_name;	/* name for this device */
@@ -915,8 +897,16 @@ static void decode_mtr(int slot_row, u16 mtr)
 
 	debugf2("\t\tNUMBANK: %d bank(s)\n", MTR_DRAM_BANKS(mtr));
 	debugf2("\t\tNUMRANK: %s\n", MTR_DIMM_RANK(mtr) ? "double" : "single");
-	debugf2("\t\tNUMROW: %s\n", numrow_toString[MTR_DIMM_ROWS(mtr)]);
-	debugf2("\t\tNUMCOL: %s\n", numcol_toString[MTR_DIMM_COLS(mtr)]);
+	debugf2("\t\tNUMROW: %s\n",
+		MTR_DIMM_ROWS(mtr) == 0 ? "8,192 - 13 rows" :
+		MTR_DIMM_ROWS(mtr) == 1 ? "16,384 - 14 rows" :
+		MTR_DIMM_ROWS(mtr) == 2 ? "32,768 - 15 rows" :
+		"65,536 - 16 rows");
+	debugf2("\t\tNUMCOL: %s\n",
+		MTR_DIMM_COLS(mtr) == 0 ? "1,024 - 10 columns" :
+		MTR_DIMM_COLS(mtr) == 1 ? "2,048 - 11 columns" :
+		MTR_DIMM_COLS(mtr) == 2 ? "4,096 - 12 columns" :
+		"reserved");
 }
 
 static void handle_channel(struct i5400_pvt *pvt, int dimm, int channel,
diff --git a/drivers/edac/i7300_edac.c b/drivers/edac/i7300_edac.c
index 20435ee..7eca688 100644
--- a/drivers/edac/i7300_edac.c
+++ b/drivers/edac/i7300_edac.c
@@ -182,24 +182,6 @@ static const u16 mtr_regs[MAX_SLOTS] = {
 #define MTR_DIMM_COLS(mtr)		((mtr) & 0x3)
 #define MTR_DIMM_COLS_ADDR_BITS(mtr)	(MTR_DIMM_COLS(mtr) + 10)
 
-#ifdef CONFIG_EDAC_DEBUG
-/* MTR NUMROW */
-static const char *numrow_toString[] = {
-	"8,192 - 13 rows",
-	"16,384 - 14 rows",
-	"32,768 - 15 rows",
-	"65,536 - 16 rows"
-};
-
-/* MTR NUMCOL */
-static const char *numcol_toString[] = {
-	"1,024 - 10 columns",
-	"2,048 - 11 columns",
-	"4,096 - 12 columns",
-	"reserved"
-};
-#endif
-
 /************************************************
  * i7300 Register definitions for error detection
  ************************************************/
@@ -645,8 +627,16 @@ static int decode_mtr(struct i7300_pvt *pvt,
 
 	debugf2("\t\tNUMBANK: %d bank(s)\n", MTR_DRAM_BANKS(mtr));
 	debugf2("\t\tNUMRANK: %s\n", MTR_DIMM_RANKS(mtr) ? "double" : "single");
-	debugf2("\t\tNUMROW: %s\n", numrow_toString[MTR_DIMM_ROWS(mtr)]);
-	debugf2("\t\tNUMCOL: %s\n", numcol_toString[MTR_DIMM_COLS(mtr)]);
+	debugf2("\t\tNUMROW: %s\n",
+		MTR_DIMM_ROWS(mtr) == 0 ? "8,192 - 13 rows" :
+		MTR_DIMM_ROWS(mtr) == 1 ? "16,384 - 14 rows" :
+		MTR_DIMM_ROWS(mtr) == 2 ? "32,768 - 15 rows" :
+		"65,536 - 16 rows");
+	debugf2("\t\tNUMCOL: %s\n",
+		MTR_DIMM_COLS(mtr) == 0 ? "1,024 - 10 columns" :
+		MTR_DIMM_COLS(mtr) == 1 ? "2,048 - 11 columns" :
+		MTR_DIMM_COLS(mtr) == 2 ? "4,096 - 12 columns" :
+		"reserved");
 	debugf2("\t\tSIZE: %d MB\n", dinfo->megabytes);
 
 	/*
-- 
1.7.8

