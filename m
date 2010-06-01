Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568Ab0FAN3Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 09:29:25 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:45655 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756398Ab0FAN3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 09:29:22 -0400
From: Borislav Petkov <bp@amd64.org>
To: <mingo@elte.hu>, <norsk5@yahoo.com>
Cc: <hpa@zytor.com>, <tglx@linutronix.de>, <linux-edac@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 3/6] amd64_edac: Remove unneeded defines
Date: Tue,  1 Jun 2010 15:29:28 +0200
Message-Id: <1275398971-12439-4-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1275398971-12439-1-git-send-email-bp@amd64.org>
References: <1275398971-12439-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

All F2x110-related bit defines are used at only one place so replace
them with simple BIT() macros.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.h |   43 ++++++++-----------------------------------
 1 files changed, 8 insertions(+), 35 deletions(-)

diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 93bfdb4..b46061e 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -244,44 +244,17 @@
 
 
 #define F10_DCTL_SEL_LOW		0x110
-
-#define dct_sel_baseaddr(pvt)    \
-	((pvt->dram_ctl_select_low) & 0xFFFFF800)
-
-#define dct_sel_interleave_addr(pvt)    \
-	(((pvt->dram_ctl_select_low) >> 6) & 0x3)
-
-enum {
-	F10_DCTL_SEL_LOW_DctSelHiRngEn	= BIT(0),
-	F10_DCTL_SEL_LOW_DctSelIntLvEn	= BIT(2),
-	F10_DCTL_SEL_LOW_DctGangEn	= BIT(4),
-	F10_DCTL_SEL_LOW_DctDatIntLv	= BIT(5),
-	F10_DCTL_SEL_LOW_DramEnable	= BIT(8),
-	F10_DCTL_SEL_LOW_MemCleared	= BIT(10),
-};
-
-#define    dct_high_range_enabled(pvt)    \
-	(pvt->dram_ctl_select_low & F10_DCTL_SEL_LOW_DctSelHiRngEn)
-
-#define dct_interleave_enabled(pvt)	   \
-	(pvt->dram_ctl_select_low & F10_DCTL_SEL_LOW_DctSelIntLvEn)
-
-#define dct_ganging_enabled(pvt)        \
-	(pvt->dram_ctl_select_low & F10_DCTL_SEL_LOW_DctGangEn)
-
-#define dct_data_intlv_enabled(pvt)    \
-	(pvt->dram_ctl_select_low & F10_DCTL_SEL_LOW_DctDatIntLv)
-
-#define dct_dram_enabled(pvt)    \
-	(pvt->dram_ctl_select_low & F10_DCTL_SEL_LOW_DramEnable)
-
-#define dct_memory_cleared(pvt)    \
-	(pvt->dram_ctl_select_low & F10_DCTL_SEL_LOW_MemCleared)
-
+#define dct_sel_baseaddr(pvt)		((pvt->dram_ctl_select_low) & 0xFFFFF800)
+#define dct_sel_interleave_addr(pvt)	(((pvt->dram_ctl_select_low) >> 6) & 0x3)
+#define dct_high_range_enabled(pvt)	(pvt->dram_ctl_select_low & BIT(0))
+#define dct_interleave_enabled(pvt)	(pvt->dram_ctl_select_low & BIT(2))
+#define dct_ganging_enabled(pvt)	(pvt->dram_ctl_select_low & BIT(4))
+#define dct_data_intlv_enabled(pvt)	(pvt->dram_ctl_select_low & BIT(5))
+#define dct_dram_enabled(pvt)		(pvt->dram_ctl_select_low & BIT(8))
+#define dct_memory_cleared(pvt)		(pvt->dram_ctl_select_low & BIT(10))
 
 #define F10_DCTL_SEL_HIGH		0x114
 
-
 /*
  * Function 3 - Misc Control
  */
-- 
1.7.1

