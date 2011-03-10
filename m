Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710Ab1CJIF0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 03:05:26 -0500
Received: from proxy.DResearch.DE ([87.193.137.100]:53813 "EHLO
	mail.dresearch.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751159Ab1CJIFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 03:05:25 -0500
From: Steffen Sledz <sledz@dresearch.de>
To: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>, Steffen Sledz <sledz@dresearch.de>
Subject: [PATCH] cfi: add support for AMIC flashes (e.g. A29L160AT)
Date: Thu, 10 Mar 2011 09:05:12 +0100
Message-Id: <1299744312-6291-1-git-send-email-sledz@dresearch.de>
X-Mailer: git-send-email 1.7.1
X-OriginalArrivalTime: 10 Mar 2011 08:05:23.0219 (UTC) FILETIME=[E8164E30:01CBDEF9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Steffen Sledz <sledz@dresearch.de>
---
 drivers/mtd/chips/cfi_cmdset_0002.c |    1 +
 include/linux/mtd/cfi.h             |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
index f072fcf..8338d33 100644
--- a/drivers/mtd/chips/cfi_cmdset_0002.c
+++ b/drivers/mtd/chips/cfi_cmdset_0002.c
@@ -349,6 +349,7 @@ static struct cfi_fixup cfi_fixup_table[] = {
 	{ CFI_MFR_ATMEL, CFI_ID_ANY, fixup_convert_atmel_pri },
 #ifdef AMD_BOOTLOC_BUG
 	{ CFI_MFR_AMD, CFI_ID_ANY, fixup_amd_bootblock },
+	{ CFI_MFR_AMIC, CFI_ID_ANY, fixup_amd_bootblock },
 	{ CFI_MFR_MACRONIX, CFI_ID_ANY, fixup_amd_bootblock },
 #endif
 	{ CFI_MFR_AMD, 0x0050, fixup_use_secsi },
diff --git a/include/linux/mtd/cfi.h b/include/linux/mtd/cfi.h
index a9baee6..0d823f2 100644
--- a/include/linux/mtd/cfi.h
+++ b/include/linux/mtd/cfi.h
@@ -535,6 +535,7 @@ struct cfi_fixup {
 #define CFI_MFR_CONTINUATION	0x007F
 
 #define CFI_MFR_AMD		0x0001
+#define CFI_MFR_AMIC		0x0037
 #define CFI_MFR_ATMEL		0x001F
 #define CFI_MFR_EON		0x001C
 #define CFI_MFR_FUJITSU		0x0004
-- 
1.7.1

