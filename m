Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935100Ab0EZXnA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 19:43:00 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:33626 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934903Ab0EZXlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 19:41:00 -0400
From: Mike Sheldon <mike@mikeasoft.com>
To: greg@kroah.com, pavel@ucw.cz
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Mike Sheldon <mike@mikeasoft.com>
Subject: [PATCH 07/15] Staging: winbond: Replace printk usage with pr_err
Date: Thu, 27 May 2010 00:39:44 +0100
Message-Id: <1274917192-16962-7-git-send-email-mike@mikeasoft.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1274917192-16962-1-git-send-email-mike@mikeasoft.com>
References: <1274917192-16962-1-git-send-email-mike@mikeasoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patches wb35reg.c to replace printk usage (missing KERN_ levels) with pr_err.

Signed-off-by: Mike Sheldon <mike@mikeasoft.com>
---
 drivers/staging/winbond/wb35reg.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/winbond/wb35reg.c b/drivers/staging/winbond/wb35reg.c
index 7707223..f245abe 100644
--- a/drivers/staging/winbond/wb35reg.c
+++ b/drivers/staging/winbond/wb35reg.c
@@ -151,7 +151,7 @@ unsigned char Wb35Reg_WriteSync(struct hw_data *pHwData, u16 RegisterNo, u32 Reg
 
 	if (ret < 0) {
 #ifdef _PE_REG_DUMP_
-		printk("EP0 Write register usb message sending error\n");
+		pr_err("EP0 Write register usb message sending error\n");
 #endif
 		pHwData->SurpriseRemove = 1;
 		return false;
@@ -321,7 +321,7 @@ unsigned char Wb35Reg_ReadSync(struct hw_data *pHwData, u16 RegisterNo, u32 *pRe
 
 	if (ret < 0) {
 #ifdef _PE_REG_DUMP_
-		printk("EP0 Read register usb message sending error\n");
+		pr_err("EP0 Read register usb message sending error\n");
 #endif
 		pHwData->SurpriseRemove = 1;
 		return false;
@@ -443,7 +443,7 @@ void Wb35Reg_EP0VM(struct hw_data *pHwData)
 
 	if (ret < 0) {
 #ifdef _PE_REG_DUMP_
-		printk("EP0 Irp sending error\n");
+		pr_err("EP0 Irp sending error\n");
 #endif
 		goto cleanup;
 	}
@@ -480,7 +480,7 @@ void Wb35Reg_EP0VM_complete(struct urb *urb)
 
 		if (reg->EP0VM_status) {
 #ifdef _PE_REG_DUMP_
-			printk("EP0 IoCompleteRoutine return error\n");
+			pr_err("EP0 IoCompleteRoutine return error\n");
 #endif
 			reg->EP0vm_state = VM_STOP;
 			pHwData->SurpriseRemove = 1;
@@ -527,7 +527,7 @@ void Wb35Reg_destroy(struct hw_data *pHwData)
 			kfree(reg_queue);
 		} else {
 #ifdef _PE_REG_DUMP_
-			printk("EP0 queue release error\n");
+			pr_err("EP0 queue release error\n");
 #endif
 		}
 		spin_lock_irq(&reg->EP0VM_spin_lock);
-- 
1.7.0.4

