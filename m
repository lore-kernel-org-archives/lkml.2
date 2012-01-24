Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757039Ab2AXR1g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 12:27:36 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52047 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757013Ab2AXR1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 12:27:34 -0500
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org
Cc: cbouatmailru@gmail.com, dg77.kim@samsung.com, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com, Jason.Wortham@maxim-ic.com,
        bruce.e.robertson@intel.com, Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH 1/5] max17042: Align register definitions with data sheet and init appnote
Date: Tue, 24 Jan 2012 09:26:04 -0800
Message-Id: <1327425968-21195-2-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1327425968-21195-1-git-send-email-dirk.brandewie@gmail.com>
References: <1327425968-21195-1-git-send-email-dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

align the register names with max17042 data sheet removing
registers that are marked reserved that are not used.

Add register definitions defined in the maxim initialization appnote

Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>
---
 include/linux/power/max17042_battery.h |   37 ++++++++++++++++++++++++-------
 1 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/include/linux/power/max17042_battery.h b/include/linux/power/max17042_battery.h
index fe99211..67eeada 100644
--- a/include/linux/power/max17042_battery.h
+++ b/include/linux/power/max17042_battery.h
@@ -40,11 +40,11 @@ enum max17042_register {
 	MAX17042_VCELL		= 0x09,
 	MAX17042_Current	= 0x0A,
 	MAX17042_AvgCurrent	= 0x0B,
-	MAX17042_Qresidual	= 0x0C,
+
 	MAX17042_SOC		= 0x0D,
 	MAX17042_AvSOC		= 0x0E,
 	MAX17042_RemCap		= 0x0F,
-	MAX17402_FullCAP	= 0x10,
+	MAX17042_FullCAP	= 0x10,
 	MAX17042_TTE		= 0x11,
 	MAX17042_V_empty	= 0x12,
 
@@ -62,14 +62,14 @@ enum max17042_register {
 	MAX17042_AvCap		= 0x1F,
 	MAX17042_ManName	= 0x20,
 	MAX17042_DevName	= 0x21,
-	MAX17042_DevChem	= 0x22,
 
+	MAX17042_FullCAPNom	= 0x23,
 	MAX17042_TempNom	= 0x24,
-	MAX17042_TempCold	= 0x25,
+	MAX17042_TempLim	= 0x25,
 	MAX17042_TempHot	= 0x26,
 	MAX17042_AIN		= 0x27,
 	MAX17042_LearnCFG	= 0x28,
-	MAX17042_SHFTCFG	= 0x29,
+	MAX17042_FilterCFG	= 0x29,
 	MAX17042_RelaxCFG	= 0x2A,
 	MAX17042_MiscCFG	= 0x2B,
 	MAX17042_TGAIN		= 0x2C,
@@ -77,22 +77,41 @@ enum max17042_register {
 	MAX17042_CGAIN		= 0x2E,
 	MAX17042_COFF		= 0x2F,
 
-	MAX17042_Q_empty	= 0x33,
+	MAX17042_MaskSOC	= 0x32,
+	MAX17042_SOC_empty	= 0x33,
 	MAX17042_T_empty	= 0x34,
 
+	MAX17042_FullCAP0       = 0x35,
+	MAX17042_LAvg_empty	= 0x36,
+	MAX17042_FCTC		= 0x37,
 	MAX17042_RCOMP0		= 0x38,
 	MAX17042_TempCo		= 0x39,
-	MAX17042_Rx		= 0x3A,
-	MAX17042_T_empty0	= 0x3B,
+	MAX17042_EmptyTempCo	= 0x3A,
+	MAX17042_K_empty0	= 0x3B,
 	MAX17042_TaskPeriod	= 0x3C,
 	MAX17042_FSTAT		= 0x3D,
 
 	MAX17042_SHDNTIMER	= 0x3F,
 
-	MAX17042_VFRemCap	= 0x4A,
+	MAX17042_dQacc		= 0x45,
+	MAX17042_dPacc		= 0x46,
+
+	MAX17042_VFSOC0		= 0x48,
 
 	MAX17042_QH		= 0x4D,
 	MAX17042_QL		= 0x4E,
+
+	MAX17042_VFSOC0Enable	= 0x60,
+	MAX17042_MLOCKReg1	= 0x62,
+	MAX17042_MLOCKReg2	= 0x63,
+
+	MAX17042_MODELChrTbl	= 0x80,
+
+	MAX17042_OCV		= 0xEE,
+
+	MAX17042_OCVInternal	= 0xFB,
+
+	MAX17042_VFSOC		= 0xFF,
 };
 
 /*
-- 
1.7.7.5

