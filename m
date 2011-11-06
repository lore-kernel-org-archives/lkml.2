Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab1KFWYr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 17:24:47 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:47973 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753983Ab1KFWYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 17:24:46 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+lLylM+/OlMzdrpQs7rb12+uvJsUxTWsPdWc8a6P
	Vsj1fs49aCz3jo
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ian Abbott <abbotti@mev.co.uk>,
        Mori Hess <fmhess@users.sourceforge.net>,
        u.kleine-koenig@pengutronix.de, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH] staging/comedi/addi:  Convert pci_table entries to PCI_DEVICE (if PCI_ANY_ID is used)
Date: Sun,  6 Nov 2011 23:24:43 +0100
Message-Id: <1320618283-17235-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts pci_table entries to use the PCI_DEVICE macro,
if .subvendor and .subdevice are set to PCI_ANY_ID,
and thus improves readablity.

Since the driver_data field isn't used anywhere we can also drop the
assignments for class, class_mask and driver_data.

Moreover the hardcoded 0x15B8 was replaced by the more readable
PCI_VENDOR_ID_ADDIDATA

KernelVersion: Staging-20111106
---
Remark:
The other APCIXXXX_BOARD_VENDOR_ID defines could also be replaced by either
PCI_VENDOR_ID_ADDIDATA or PCI_VENDOR_ID_ADDIDATA_OLD
but I'd rather do this in a separate patch.

 .../staging/comedi/drivers/addi-data/addi_common.c |  137 ++++++++++----------
 1 files changed, 68 insertions(+), 69 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/addi_common.c b/drivers/staging/comedi/drivers/addi-data/addi_common.c
index 6fb7594..ca5bd9b8 100644
--- a/drivers/staging/comedi/drivers/addi-data/addi_common.c
+++ b/drivers/staging/comedi/drivers/addi-data/addi_common.c
@@ -145,78 +145,77 @@ void fpu_end(void)
 
 static DEFINE_PCI_DEVICE_TABLE(addi_apci_tbl) = {
 #ifdef CONFIG_APCI_3120
-	{APCI3120_BOARD_VENDOR_ID, 0x818D, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_DEVICE(APCI3120_BOARD_VENDOR_ID, 0x818D)},
 #endif
 #ifdef CONFIG_APCI_1032
-	{APCI1032_BOARD_VENDOR_ID, 0x1003, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_DEVICE(APCI1032_BOARD_VENDOR_ID, 0x1003)},
 #endif
 #ifdef CONFIG_APCI_1516
-	{APCI1516_BOARD_VENDOR_ID, 0x1001, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_DEVICE(APCI1516_BOARD_VENDOR_ID, 0x1001)},
 #endif
 #ifdef CONFIG_APCI_2016
-	{APCI2016_BOARD_VENDOR_ID, 0x1002, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_DEVICE(APCI2016_BOARD_VENDOR_ID, 0x1002)},
 #endif
 #ifdef CONFIG_APCI_2032
-	{APCI2032_BOARD_VENDOR_ID, 0x1004, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_DEVICE(APCI2032_BOARD_VENDOR_ID, 0x1004)},
 #endif
 #ifdef CONFIG_APCI_2200
-	{APCI2200_BOARD_VENDOR_ID, 0x1005, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_DEVICE(APCI2200_BOARD_VENDOR_ID, 0x1005)},
 #endif
 #ifdef CONFIG_APCI_1564
-	{APCI1564_BOARD_VENDOR_ID, 0x1006, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_DEVICE(APCI1564_BOARD_VENDOR_ID, 0x1006)},
 #endif
 #ifdef CONFIG_APCI_1500
-	{APCI1500_BOARD_VENDOR_ID, 0x80fc, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_DEVICE(APCI1500_BOARD_VENDOR_ID, 0x80fc)},
 #endif
 #ifdef CONFIG_APCI_3001
-	{APCI3120_BOARD_VENDOR_ID, 0x828D, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_DEVICE(APCI3120_BOARD_VENDOR_ID, 0x828D)},
 #endif
 #ifdef CONFIG_APCI_3501
-	{APCI3501_BOARD_VENDOR_ID, 0x3001, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_DEVICE(APCI3501_BOARD_VENDOR_ID, 0x3001)},
 #endif
 #ifdef CONFIG_APCI_035
-	{APCI035_BOARD_VENDOR_ID, 0x0300, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_DEVICE(APCI035_BOARD_VENDOR_ID,  0x0300)},
 #endif
 #ifdef CONFIG_APCI_3200
-	{APCI3200_BOARD_VENDOR_ID, 0x3000, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_DEVICE(APCI3200_BOARD_VENDOR_ID, 0x3000)},
 #endif
 #ifdef CONFIG_APCI_3300
-	{APCI3200_BOARD_VENDOR_ID, 0x3007, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_DEVICE(APCI3200_BOARD_VENDOR_ID, 0x3007)},
 #endif
 #ifdef CONFIG_APCI_1710
-	{APCI1710_BOARD_VENDOR_ID, APCI1710_BOARD_DEVICE_ID,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_DEVICE(APCI1710_BOARD_VENDOR_ID, APCI1710_BOARD_DEVICE_ID)},
 #endif
 #ifdef CONFIG_APCI_16XX
-	{0x15B8, 0x1009, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{0x15B8, 0x100A, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_DEVICE(PCI_VENDOR_ID_ADDIDATA, 0x1009)},
+	{PCI_DEVICE(PCI_VENDOR_ID_ADDIDATA, 0x100A)},
 #endif
 #ifdef CONFIG_APCI_3XXX
-	{0x15B8, 0x3010, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{0x15B8, 0x300F, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{0x15B8, 0x300E, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{0x15B8, 0x3013, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{0x15B8, 0x3014, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{0x15B8, 0x3015, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{0x15B8, 0x3016, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{0x15B8, 0x3017, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{0x15B8, 0x3018, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{0x15B8, 0x3019, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{0x15B8, 0x301A, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{0x15B8, 0x301B, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{0x15B8, 0x301C, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{0x15B8, 0x301D, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{0x15B8, 0x301E, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{0x15B8, 0x301F, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{0x15B8, 0x3020, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{0x15B8, 0x3021, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{0x15B8, 0x3022, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{0x15B8, 0x3023, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{0x15B8, 0x300B, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{0x15B8, 0x3002, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{0x15B8, 0x3003, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{0x15B8, 0x3004, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{0x15B8, 0x3024, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_DEVICE(PCI_VENDOR_ID_ADDIDATA, 0x3010)},
+	{PCI_DEVICE(PCI_VENDOR_ID_ADDIDATA, 0x300F)},
+	{PCI_DEVICE(PCI_VENDOR_ID_ADDIDATA, 0x300E)},
+	{PCI_DEVICE(PCI_VENDOR_ID_ADDIDATA, 0x3013)},
+	{PCI_DEVICE(PCI_VENDOR_ID_ADDIDATA, 0x3014)},
+	{PCI_DEVICE(PCI_VENDOR_ID_ADDIDATA, 0x3015)},
+	{PCI_DEVICE(PCI_VENDOR_ID_ADDIDATA, 0x3016)},
+	{PCI_DEVICE(PCI_VENDOR_ID_ADDIDATA, 0x3017)},
+	{PCI_DEVICE(PCI_VENDOR_ID_ADDIDATA, 0x3018)},
+	{PCI_DEVICE(PCI_VENDOR_ID_ADDIDATA, 0x3019)},
+	{PCI_DEVICE(PCI_VENDOR_ID_ADDIDATA, 0x301A)},
+	{PCI_DEVICE(PCI_VENDOR_ID_ADDIDATA, 0x301B)},
+	{PCI_DEVICE(PCI_VENDOR_ID_ADDIDATA, 0x301C)},
+	{PCI_DEVICE(PCI_VENDOR_ID_ADDIDATA, 0x301D)},
+	{PCI_DEVICE(PCI_VENDOR_ID_ADDIDATA, 0x301E)},
+	{PCI_DEVICE(PCI_VENDOR_ID_ADDIDATA, 0x301F)},
+	{PCI_DEVICE(PCI_VENDOR_ID_ADDIDATA, 0x3020)},
+	{PCI_DEVICE(PCI_VENDOR_ID_ADDIDATA, 0x3021)},
+	{PCI_DEVICE(PCI_VENDOR_ID_ADDIDATA, 0x3022)},
+	{PCI_DEVICE(PCI_VENDOR_ID_ADDIDATA, 0x3023)},
+	{PCI_DEVICE(PCI_VENDOR_ID_ADDIDATA, 0x300B)},
+	{PCI_DEVICE(PCI_VENDOR_ID_ADDIDATA, 0x3002)},
+	{PCI_DEVICE(PCI_VENDOR_ID_ADDIDATA, 0x3003)},
+	{PCI_DEVICE(PCI_VENDOR_ID_ADDIDATA, 0x3004)},
+	{PCI_DEVICE(PCI_VENDOR_ID_ADDIDATA, 0x3024)},
 #endif
 	{0}
 };
@@ -1019,7 +1018,7 @@ static const struct addi_board boardtypes[] = {
 #endif
 #ifdef CONFIG_APCI_16XX
 	{"apci1648",
-			0x15B8,
+			PCI_VENDOR_ID_ADDIDATA,
 			0x1009,
 			128,
 			0,
@@ -1075,7 +1074,7 @@ static const struct addi_board boardtypes[] = {
 		i_APCI16XX_InsnBitsWriteTTLIO},
 
 	{"apci1696",
-			0x15B8,
+			PCI_VENDOR_ID_ADDIDATA,
 			0x100A,
 			128,
 			0,
@@ -1132,7 +1131,7 @@ static const struct addi_board boardtypes[] = {
 #endif
 #ifdef CONFIG_APCI_3XXX
 	{"apci3000-16",
-			0x15B8,
+			PCI_VENDOR_ID_ADDIDATA,
 			0x3010,
 			256,
 			256,
@@ -1188,7 +1187,7 @@ static const struct addi_board boardtypes[] = {
 		i_APCI3XXX_InsnWriteTTLIO},
 
 	{"apci3000-8",
-			0x15B8,
+			PCI_VENDOR_ID_ADDIDATA,
 			0x300F,
 			256,
 			256,
@@ -1244,7 +1243,7 @@ static const struct addi_board boardtypes[] = {
 		i_APCI3XXX_InsnWriteTTLIO},
 
 	{"apci3000-4",
-			0x15B8,
+			PCI_VENDOR_ID_ADDIDATA,
 			0x300E,
 			256,
 			256,
@@ -1300,7 +1299,7 @@ static const struct addi_board boardtypes[] = {
 		i_APCI3XXX_InsnWriteTTLIO},
 
 	{"apci3006-16",
-			0x15B8,
+			PCI_VENDOR_ID_ADDIDATA,
 			0x3013,
 			256,
 			256,
@@ -1356,7 +1355,7 @@ static const struct addi_board boardtypes[] = {
 		i_APCI3XXX_InsnWriteTTLIO},
 
 	{"apci3006-8",
-			0x15B8,
+			PCI_VENDOR_ID_ADDIDATA,
 			0x3014,
 			256,
 			256,
@@ -1412,7 +1411,7 @@ static const struct addi_board boardtypes[] = {
 		i_APCI3XXX_InsnWriteTTLIO},
 
 	{"apci3006-4",
-			0x15B8,
+			PCI_VENDOR_ID_ADDIDATA,
 			0x3015,
 			256,
 			256,
@@ -1468,7 +1467,7 @@ static const struct addi_board boardtypes[] = {
 		i_APCI3XXX_InsnWriteTTLIO},
 
 	{"apci3010-16",
-			0x15B8,
+			PCI_VENDOR_ID_ADDIDATA,
 			0x3016,
 			256,
 			256,
@@ -1524,7 +1523,7 @@ static const struct addi_board boardtypes[] = {
 		i_APCI3XXX_InsnWriteTTLIO},
 
 	{"apci3010-8",
-			0x15B8,
+			PCI_VENDOR_ID_ADDIDATA,
 			0x3017,
 			256,
 			256,
@@ -1580,7 +1579,7 @@ static const struct addi_board boardtypes[] = {
 		i_APCI3XXX_InsnWriteTTLIO},
 
 	{"apci3010-4",
-			0x15B8,
+			PCI_VENDOR_ID_ADDIDATA,
 			0x3018,
 			256,
 			256,
@@ -1636,7 +1635,7 @@ static const struct addi_board boardtypes[] = {
 		i_APCI3XXX_InsnWriteTTLIO},
 
 	{"apci3016-16",
-			0x15B8,
+			PCI_VENDOR_ID_ADDIDATA,
 			0x3019,
 			256,
 			256,
@@ -1692,7 +1691,7 @@ static const struct addi_board boardtypes[] = {
 		i_APCI3XXX_InsnWriteTTLIO},
 
 	{"apci3016-8",
-			0x15B8,
+			PCI_VENDOR_ID_ADDIDATA,
 			0x301A,
 			256,
 			256,
@@ -1748,7 +1747,7 @@ static const struct addi_board boardtypes[] = {
 		i_APCI3XXX_InsnWriteTTLIO},
 
 	{"apci3016-4",
-			0x15B8,
+			PCI_VENDOR_ID_ADDIDATA,
 			0x301B,
 			256,
 			256,
@@ -1804,7 +1803,7 @@ static const struct addi_board boardtypes[] = {
 		i_APCI3XXX_InsnWriteTTLIO},
 
 	{"apci3100-16-4",
-			0x15B8,
+			PCI_VENDOR_ID_ADDIDATA,
 			0x301C,
 			256,
 			256,
@@ -1860,7 +1859,7 @@ static const struct addi_board boardtypes[] = {
 		i_APCI3XXX_InsnWriteTTLIO},
 
 	{"apci3100-8-4",
-			0x15B8,
+			PCI_VENDOR_ID_ADDIDATA,
 			0x301D,
 			256,
 			256,
@@ -1916,7 +1915,7 @@ static const struct addi_board boardtypes[] = {
 		i_APCI3XXX_InsnWriteTTLIO},
 
 	{"apci3106-16-4",
-			0x15B8,
+			PCI_VENDOR_ID_ADDIDATA,
 			0x301E,
 			256,
 			256,
@@ -1972,7 +1971,7 @@ static const struct addi_board boardtypes[] = {
 		i_APCI3XXX_InsnWriteTTLIO},
 
 	{"apci3106-8-4",
-			0x15B8,
+			PCI_VENDOR_ID_ADDIDATA,
 			0x301F,
 			256,
 			256,
@@ -2028,7 +2027,7 @@ static const struct addi_board boardtypes[] = {
 		i_APCI3XXX_InsnWriteTTLIO},
 
 	{"apci3110-16-4",
-			0x15B8,
+			PCI_VENDOR_ID_ADDIDATA,
 			0x3020,
 			256,
 			256,
@@ -2084,7 +2083,7 @@ static const struct addi_board boardtypes[] = {
 		i_APCI3XXX_InsnWriteTTLIO},
 
 	{"apci3110-8-4",
-			0x15B8,
+			PCI_VENDOR_ID_ADDIDATA,
 			0x3021,
 			256,
 			256,
@@ -2140,7 +2139,7 @@ static const struct addi_board boardtypes[] = {
 		i_APCI3XXX_InsnWriteTTLIO},
 
 	{"apci3116-16-4",
-			0x15B8,
+			PCI_VENDOR_ID_ADDIDATA,
 			0x3022,
 			256,
 			256,
@@ -2196,7 +2195,7 @@ static const struct addi_board boardtypes[] = {
 		i_APCI3XXX_InsnWriteTTLIO},
 
 	{"apci3116-8-4",
-			0x15B8,
+			PCI_VENDOR_ID_ADDIDATA,
 			0x3023,
 			256,
 			256,
@@ -2252,7 +2251,7 @@ static const struct addi_board boardtypes[] = {
 		i_APCI3XXX_InsnWriteTTLIO},
 
 	{"apci3003",
-			0x15B8,
+			PCI_VENDOR_ID_ADDIDATA,
 			0x300B,
 			256,
 			256,
@@ -2307,7 +2306,7 @@ static const struct addi_board boardtypes[] = {
 		NULL},
 
 	{"apci3002-16",
-			0x15B8,
+			PCI_VENDOR_ID_ADDIDATA,
 			0x3002,
 			256,
 			256,
@@ -2362,7 +2361,7 @@ static const struct addi_board boardtypes[] = {
 		NULL},
 
 	{"apci3002-8",
-			0x15B8,
+			PCI_VENDOR_ID_ADDIDATA,
 			0x3003,
 			256,
 			256,
@@ -2417,7 +2416,7 @@ static const struct addi_board boardtypes[] = {
 		NULL},
 
 	{"apci3002-4",
-			0x15B8,
+			PCI_VENDOR_ID_ADDIDATA,
 			0x3004,
 			256,
 			256,
@@ -2472,7 +2471,7 @@ static const struct addi_board boardtypes[] = {
 		NULL},
 
 	{"apci3500",
-			0x15B8,
+			PCI_VENDOR_ID_ADDIDATA,
 			0x3024,
 			256,
 			256,
-- 
1.7.3.4

