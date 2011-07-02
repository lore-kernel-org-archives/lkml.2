Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab1GBXyF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 19:54:05 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:48173 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab1GBXyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 19:54:01 -0400
From: Chris Forbes <chrisf@ijw.co.nz>
To: Matthieu CASTET <castet.matthieu@free.fr>
Cc: Stanislaw Gruszka <stf_xl@wp.pl>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, Chris Forbes <chrisf@ijw.co.nz>
Subject: [PATCH 1/2] drivers: usb: atm: ueagle-atm: use __packed
Date: Sun,  3 Jul 2011 11:53:33 +1200
Message-Id: <1309650814-18929-1-git-send-email-chrisf@ijw.co.nz>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced __attribute__ ((packed)) with __packed;

Signed-off-by: Chris Forbes <chrisf@ijw.co.nz>
---
 drivers/usb/atm/ueagle-atm.c |   34 +++++++++++++++++-----------------
 1 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/usb/atm/ueagle-atm.c b/drivers/usb/atm/ueagle-atm.c
index e71521c..2909457 100644
--- a/drivers/usb/atm/ueagle-atm.c
+++ b/drivers/usb/atm/ueagle-atm.c
@@ -116,14 +116,14 @@ struct uea_cmvs_v1 {
 	u32 address;
 	u16 offset;
 	u32 data;
-} __attribute__ ((packed));
+} __packed;
 
 struct uea_cmvs_v2 {
 	u32 group;
 	u32 address;
 	u32 offset;
 	u32 data;
-} __attribute__ ((packed));
+} __packed;
 
 /* information about currently processed cmv */
 struct cmv_dsc_e1 {
@@ -352,7 +352,7 @@ struct block_index {
 	__le32 PageAddress;
 	__le16 dummy1;
 	__le16 PageNumber;
-} __attribute__ ((packed));
+} __packed;
 
 #define E4_IS_BOOT_PAGE(PageSize) ((le32_to_cpu(PageSize)) & 0x80000000)
 #define E4_PAGE_BYTES(PageSize) ((le32_to_cpu(PageSize) & 0x7fffffff) * 4)
@@ -367,7 +367,7 @@ struct l1_code {
 	u8 page_number_to_block_index[E4_MAX_PAGE_NUMBER];
 	struct block_index page_header[E4_NO_SWAPPAGE_HEADERS];
 	u8 code[0];
-} __attribute__ ((packed));
+} __packed;
 
 /* structures describing a block within a DSP page */
 struct block_info_e1 {
@@ -377,7 +377,7 @@ struct block_info_e1 {
 	__le16 wOvlOffset;
 	__le16 wOvl;		/* overlay */
 	__le16 wLast;
-} __attribute__ ((packed));
+} __packed;
 #define E1_BLOCK_INFO_SIZE 12
 
 struct block_info_e4 {
@@ -387,7 +387,7 @@ struct block_info_e4 {
 	__be32 dwSize;
 	__be32 dwAddress;
 	__be16 wReserved;
-} __attribute__ ((packed));
+} __packed;
 #define E4_BLOCK_INFO_SIZE 14
 
 #define UEA_BIHDR 0xabcd
@@ -467,7 +467,7 @@ struct cmv_e1 {
 	__le32 dwSymbolicAddress;
 	__le16 wOffsetAddress;
 	__le32 dwData;
-} __attribute__ ((packed));
+} __packed;
 
 struct cmv_e4 {
 	__be16 wGroup;
@@ -475,17 +475,17 @@ struct cmv_e4 {
 	__be16 wOffset;
 	__be16 wAddress;
 	__be32 dwData[6];
-} __attribute__ ((packed));
+} __packed;
 
 /* structures representing swap information */
 struct swap_info_e1 {
 	__u8 bSwapPageNo;
 	__u8 bOvl;		/* overlay */
-} __attribute__ ((packed));
+} __packed;
 
 struct swap_info_e4 {
 	__u8 bSwapPageNo;
-} __attribute__ ((packed));
+} __packed;
 
 /* structures representing interrupt data */
 #define e1_bSwapPageNo	u.e1.s1.swapinfo.bSwapPageNo
@@ -499,23 +499,23 @@ union intr_data_e1 {
 	struct {
 		struct swap_info_e1 swapinfo;
 		__le16 wDataSize;
-	} __attribute__ ((packed)) s1;
+	} __packed s1;
 	struct {
 		struct cmv_e1 cmv;
 		__le16 wDataSize;
-	} __attribute__ ((packed)) s2;
-} __attribute__ ((packed));
+	} __packed s2;
+} __packed;
 
 union intr_data_e4 {
 	struct {
 		struct swap_info_e4 swapinfo;
 		__le16 wDataSize;
-	} __attribute__ ((packed)) s1;
+	} __packed s1;
 	struct {
 		struct cmv_e4 cmv;
 		__le16 wDataSize;
-	} __attribute__ ((packed)) s2;
-} __attribute__ ((packed));
+	} __packed s2;
+} __packed;
 
 struct intr_pkt {
 	__u8 bType;
@@ -528,7 +528,7 @@ struct intr_pkt {
 		union intr_data_e1 e1;
 		union intr_data_e4 e4;
 	} u;
-} __attribute__ ((packed));
+} __packed;
 
 #define E1_INTR_PKT_SIZE 28
 #define E4_INTR_PKT_SIZE 64
-- 
1.7.4.1

