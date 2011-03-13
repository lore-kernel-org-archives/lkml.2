Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672Ab1CMK1n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 06:27:43 -0400
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:39070 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284Ab1CMK02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 06:26:28 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: [PATCH v2 23/24] staging: xgifb: clean up register access types
Date: Sun, 13 Mar 2011 12:26:27 +0200
Message-Id: <1300011988-2109-24-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1300011988-2109-1-git-send-email-aaro.koskinen@iki.fi>
References: <1300011988-2109-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make type usage consistent. Use u8 for HW registers and unsigned for
bitmasks.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/vb_util.c |   23 ++++++++++-------------
 drivers/staging/xgifb/vb_util.h |   10 +++++-----
 2 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/xgifb/vb_util.c b/drivers/staging/xgifb/vb_util.c
index d8429e8..19bcdab 100644
--- a/drivers/staging/xgifb/vb_util.c
+++ b/drivers/staging/xgifb/vb_util.c
@@ -8,46 +8,43 @@
 
 #include "vb_util.h"
 
-void xgifb_reg_set(unsigned long port, unsigned short index,
-		unsigned short data)
+void xgifb_reg_set(unsigned long port, u8 index, u8 data)
 {
 	outb(index, port);
 	outb(data, port + 1);
 }
 
-unsigned char xgifb_reg_get(unsigned long port, unsigned short index)
+u8 xgifb_reg_get(unsigned long port, u8 index)
 {
-	unsigned char data;
+	u8 data;
 
 	outb(index, port);
 	data = inb(port + 1);
 	return data;
 }
 
-void xgifb_reg_and_or(unsigned long Port, unsigned short Index,
-		unsigned short DataAND, unsigned short DataOR)
+void xgifb_reg_and_or(unsigned long Port, u8 Index,
+		unsigned DataAND, unsigned DataOR)
 {
-	unsigned short temp;
+	u8 temp;
 
 	temp = xgifb_reg_get(Port, Index); /* XGINew_Part1Port index 02 */
 	temp = (temp & (DataAND)) | DataOR;
 	xgifb_reg_set(Port, Index, temp);
 }
 
-void xgifb_reg_and(unsigned long Port, unsigned short Index,
-		unsigned short DataAND)
+void xgifb_reg_and(unsigned long Port, u8 Index, unsigned DataAND)
 {
-	unsigned short temp;
+	u8 temp;
 
 	temp = xgifb_reg_get(Port, Index); /* XGINew_Part1Port index 02 */
 	temp &= DataAND;
 	xgifb_reg_set(Port, Index, temp);
 }
 
-void xgifb_reg_or(unsigned long Port, unsigned short Index,
-		unsigned short DataOR)
+void xgifb_reg_or(unsigned long Port, u8 Index, unsigned DataOR)
 {
-	unsigned short temp;
+	u8 temp;
 
 	temp = xgifb_reg_get(Port, Index); /* XGINew_Part1Port index 02 */
 	temp |= DataOR;
diff --git a/drivers/staging/xgifb/vb_util.h b/drivers/staging/xgifb/vb_util.h
index 98af1c0..9161de1 100644
--- a/drivers/staging/xgifb/vb_util.h
+++ b/drivers/staging/xgifb/vb_util.h
@@ -1,9 +1,9 @@
 #ifndef _VBUTIL_
 #define _VBUTIL_
-extern void xgifb_reg_set(unsigned long, unsigned short, unsigned short);
-extern unsigned char xgifb_reg_get(unsigned long, unsigned short);
-extern void xgifb_reg_or(unsigned long, unsigned short, unsigned short);
-extern void xgifb_reg_and(unsigned long, unsigned short, unsigned short);
-extern void xgifb_reg_and_or(unsigned long, unsigned short, unsigned short, unsigned short);
+extern void xgifb_reg_set(unsigned long, u8, u8);
+extern u8 xgifb_reg_get(unsigned long, u8);
+extern void xgifb_reg_or(unsigned long, u8, unsigned);
+extern void xgifb_reg_and(unsigned long, u8, unsigned);
+extern void xgifb_reg_and_or(unsigned long, u8, unsigned, unsigned);
 #endif
 
-- 
1.5.6.5

