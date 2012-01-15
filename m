Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060Ab2AOSWq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 13:22:46 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:41600 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751927Ab2AOSWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 13:22:44 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/ekuhQed3eAmDSDdfO4lnqmIf2vQTevnAQfllXnc
	BvDB2J+E5SGe24
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 4/4] staging/xgifb: Remove remaining duplicate structs and defines
Date: Sun, 15 Jan 2012 19:22:13 +0100
Message-Id: <1326651733-9242-5-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1326651733-9242-1-git-send-email-peterhuewe@gmx.de>
References: <1326651733-9242-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the now unused structs and defines which were mere
duplicates of the ones in the sgi headers

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/XGI_main.h  |   77 +++++--------------------------------
 drivers/staging/xgifb/vb_struct.h |   66 -------------------------------
 2 files changed, 10 insertions(+), 133 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main.h b/drivers/staging/xgifb/XGI_main.h
index fdee421..e828fd4 100644
--- a/drivers/staging/xgifb/XGI_main.h
+++ b/drivers/staging/xgifb/XGI_main.h
@@ -12,43 +12,27 @@
 
 #define XGIFAIL(x) do { printk(x "\n"); return -EINVAL; } while (0)
 
-#ifndef PCI_VENDOR_ID_XG
-#define PCI_VENDOR_ID_XG          0x18CA
+#ifndef PCI_DEVICE_ID_XGI_41
+#define PCI_DEVICE_ID_XGI_41      0x041
 #endif
-
-#ifndef PCI_DEVICE_ID_XG_40
-#define PCI_DEVICE_ID_XG_40      0x040
-#endif
-#ifndef PCI_DEVICE_ID_XG_41
-#define PCI_DEVICE_ID_XG_41      0x041
-#endif
-#ifndef PCI_DEVICE_ID_XG_42
-#define PCI_DEVICE_ID_XG_42      0x042
+#ifndef PCI_DEVICE_ID_XGI_42
+#define PCI_DEVICE_ID_XGI_42      0x042
 #endif
-#ifndef PCI_DEVICE_ID_XG_20
-#define PCI_DEVICE_ID_XG_20      0x020
-#endif
-#ifndef PCI_DEVICE_ID_XG_27
-#define PCI_DEVICE_ID_XG_27      0x027
+#ifndef PCI_DEVICE_ID_XGI_27
+#define PCI_DEVICE_ID_XGI_27      0x027
 #endif
 
 static DEFINE_PCI_DEVICE_TABLE(xgifb_pci_table) = {
-	{PCI_DEVICE(PCI_VENDOR_ID_XG, PCI_DEVICE_ID_XG_20)},
-	{PCI_DEVICE(PCI_VENDOR_ID_XG, PCI_DEVICE_ID_XG_27)},
-	{PCI_DEVICE(PCI_VENDOR_ID_XG, PCI_DEVICE_ID_XG_40)},
-	{PCI_DEVICE(PCI_VENDOR_ID_XG, PCI_DEVICE_ID_XG_42)},
+	{PCI_DEVICE(PCI_VENDOR_ID_XGI, PCI_DEVICE_ID_XGI_20)},
+	{PCI_DEVICE(PCI_VENDOR_ID_XGI, PCI_DEVICE_ID_XGI_27)},
+	{PCI_DEVICE(PCI_VENDOR_ID_XGI, PCI_DEVICE_ID_XGI_40)},
+	{PCI_DEVICE(PCI_VENDOR_ID_XGI, PCI_DEVICE_ID_XGI_42)},
 	{0}
 };
 
 MODULE_DEVICE_TABLE(pci, xgifb_pci_table);
 
 /* To be included in fb.h */
-#ifndef FB_ACCEL_XGI_XABRE
-#define FB_ACCEL_XGI_XABRE      41	/* XGI 330 ("Xabre")		*/
-#endif
-
-#define SEQ_DATA                  0x15
-
 #define XGISR			  (xgifb_info->dev_info.P3c4)
 #define XGICR			  (xgifb_info->dev_info.P3d4)
 #define XGIDACA			  (xgifb_info->dev_info.P3c8)
@@ -61,12 +45,6 @@ MODULE_DEVICE_TABLE(pci, xgifb_pci_table);
 #define XGIDAC2A                  XGIPART5
 #define XGIDAC2D                  (XGIPART5 + 1)
 
-#define IND_XGI_PASSWORD          0x05  /* SRs */
-#define IND_XGI_RAMDAC_CONTROL    0x07
-#define IND_XGI_DRAM_SIZE         0x14
-#define IND_XGI_MODULE_ENABLE     0x1E
-#define IND_XGI_PCI_ADDRESS_SET   0x20
-
 #define IND_XGI_SCRATCH_REG_CR30  0x30  /* CRs */
 #define IND_XGI_SCRATCH_REG_CR31  0x31
 #define IND_XGI_SCRATCH_REG_CR32  0x32
@@ -74,10 +52,6 @@ MODULE_DEVICE_TABLE(pci, xgifb_pci_table);
 #define IND_XGI_LCD_PANEL         0x36
 #define IND_XGI_SCRATCH_REG_CR37  0x37
 
-#define IND_XGI_CRT2_WRITE_ENABLE_315 0x2F
-
-#define XGI_PASSWORD              0x86  /* SR05 */
-
 #define XGI_DRAM_SIZE_MASK     0xF0  /*SR14 */
 #define XGI_DRAM_SIZE_1MB      0x00
 #define XGI_DRAM_SIZE_2MB      0x01
@@ -89,37 +63,6 @@ MODULE_DEVICE_TABLE(pci, xgifb_pci_table);
 #define XGI_DRAM_SIZE_128MB    0x07
 #define XGI_DRAM_SIZE_256MB    0x08
 
-#define XGI_ENABLE_2D             0x40  /* SR1E */
-
-#define XGI_MEM_MAP_IO_ENABLE     0x01  /* SR20 */
-#define XGI_PCI_ADDR_ENABLE       0x80
-
-#define XGI_SIMULTANEOUS_VIEW_ENABLE  0x01  /* CR30 */
-#define XGI_VB_OUTPUT_COMPOSITE   0x04
-#define XGI_VB_OUTPUT_SVIDEO      0x08
-#define XGI_VB_OUTPUT_SCART       0x10
-#define XGI_VB_OUTPUT_LCD         0x20
-#define XGI_VB_OUTPUT_CRT2        0x40
-#define XGI_VB_OUTPUT_HIVISION    0x80
-
-#define XGI_VB_OUTPUT_DISABLE     0x20  /* CR31 */
-#define XGI_DRIVER_MODE           0x40
-
-#define XGI_VB_COMPOSITE          0x01  /* CR32 */
-#define XGI_VB_SVIDEO             0x02
-#define XGI_VB_SCART              0x04
-#define XGI_VB_LCD                0x08
-#define XGI_VB_CRT2               0x10
-#define XGI_CRT1                  0x20
-#define XGI_VB_HIVISION           0x40
-#define XGI_VB_YPBPR              0x80
-#define XGI_VB_TV		  (XGI_VB_COMPOSITE | XGI_VB_SVIDEO | \
-				   XGI_VB_SCART | XGI_VB_HIVISION|XGI_VB_YPBPR)
-
-#define XGI_EXTERNAL_CHIP_MASK		   0x0E  /* CR37 */
-#define XGI310_EXTERNAL_CHIP_LVDS          0x02  /* in CR37 << 1 ! */
-#define XGI310_EXTERNAL_CHIP_LVDS_CHRONTEL 0x03  /* in CR37 << 1 ! */
-
 /* ------------------- Global Variables ----------------------------- */
 
 /* display status */
diff --git a/drivers/staging/xgifb/vb_struct.h b/drivers/staging/xgifb/vb_struct.h
index 76a17c2..a5bd56a 100644
--- a/drivers/staging/xgifb/vb_struct.h
+++ b/drivers/staging/xgifb/vb_struct.h
@@ -1,15 +1,5 @@
 #ifndef _VB_STRUCT_
 #define _VB_STRUCT_
-
-struct XGI_LCDDataStruct {
-	unsigned short RVBHCMAX;
-	unsigned short RVBHCFACT;
-	unsigned short VGAHT;
-	unsigned short VGAVT;
-	unsigned short LCDHT;
-	unsigned short LCDVT;
-};
-
 #include "../../video/sis/vstruct.h"
 
 struct XGI_LVDSCRT1HDataStruct {
@@ -20,22 +10,6 @@ struct XGI_LVDSCRT1VDataStruct {
 	unsigned char Reg[7];
 };
 
-struct XGI_TVDataStruct {
-	unsigned short RVBHCMAX;
-	unsigned short RVBHCFACT;
-	unsigned short VGAHT;
-	unsigned short VGAVT;
-	unsigned short TVHDE;
-	unsigned short TVVDE;
-	unsigned short RVBHRS;
-	unsigned char FlickerMode;
-	unsigned short HALFRVBHRS;
-	unsigned char RY1COE;
-	unsigned char RY2COE;
-	unsigned char RY3COE;
-	unsigned char RY4COE;
-};
-
 struct XGI_StStruct {
 	unsigned char St_ModeID;
 	unsigned short St_ModeFlag;
@@ -48,18 +22,6 @@ struct XGI_StStruct {
 	unsigned char VB_StTVYFilterIndex;
 };
 
-struct XGI_StandTableStruct {
-	unsigned char CRT_COLS;
-	unsigned char ROWS;
-	unsigned char CHAR_HEIGHT;
-	unsigned short CRT_LEN;
-	unsigned char SR[4];
-	unsigned char MISC;
-	unsigned char CRTC[0x19];
-	unsigned char ATTR[0x14];
-	unsigned char GRC[9];
-};
-
 struct XGI_ExtStruct {
 	unsigned char Ext_ModeID;
 	unsigned short Ext_ModeFlag;
@@ -86,39 +48,11 @@ struct XGI_Ext2Struct {
 	/* unsigned short ROM_OFFSET; */
 };
 
-
-struct XGI_MCLKDataStruct {
-	unsigned char SR28, SR29, SR2A;
-	unsigned short CLOCK;
-};
-
 struct XGI_ECLKDataStruct {
 	unsigned char SR2E, SR2F, SR30;
 	unsigned short CLOCK;
 };
 
-struct XGI_VCLKDataStruct {
-	unsigned char SR2B, SR2C;
-	unsigned short CLOCK;
-};
-
-struct XGI_VBVCLKDataStruct {
-	unsigned char Part4_A, Part4_B;
-	unsigned short CLOCK;
-};
-
-struct XGI_StResInfoStruct {
-	unsigned short HTotal;
-	unsigned short VTotal;
-};
-
-struct XGI_ModeResInfoStruct {
-	unsigned short HTotal;
-	unsigned short VTotal;
-	unsigned char  XChar;
-	unsigned char  YChar;
-};
-
 /*add for new UNIVGABIOS*/
 struct XGI_LCDDesStruct {
 	unsigned short LCDHDES;
-- 
1.7.3.4

