Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756377Ab2FJLWf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 07:22:35 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:48325 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755446Ab2FJLWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 07:22:34 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAKKA1E9bdWOb/2dsb2JhbABFtFqBB4IYAQEFJ1IQIDE8GwcSiA+3T5EQA5Uej3uCYg
X-IronPort-AV: E=Sophos;i="4.77,384,1336341600"; 
   d="scan'208";a="918717960"
From: "Javier M. Mellid" <jmunhoz@igalia.com>
To: gregkh@linuxfoundation.org, teddy.wang@siliconmotion.com.cn
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Javier M. Mellid" <jmunhoz@igalia.com>
Subject: [PATCH 1/3] staging: sm7xx: code improvement
Date: Sun, 10 Jun 2012 13:12:22 +0200
Message-Id: <1339326744-17507-2-git-send-email-jmunhoz@igalia.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1339326744-17507-1-git-send-email-jmunhoz@igalia.com>
References: <1339326744-17507-1-git-send-email-jmunhoz@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Javier M. Mellid" <jmunhoz@igalia.com>

This patch simplifies code. It erases redundant code under little endian
compilations.

Signed-off-by: Javier M. Mellid <jmunhoz@igalia.com>
---
 drivers/staging/sm7xx/smtcfb.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/sm7xx/smtcfb.c b/drivers/staging/sm7xx/smtcfb.c
index 746c4cd..2c172d6 100644
--- a/drivers/staging/sm7xx/smtcfb.c
+++ b/drivers/staging/sm7xx/smtcfb.c
@@ -724,16 +724,13 @@ static void smtc_unmap_mmio(struct smtcfb_info *sfb)
 static int smtc_map_smem(struct smtcfb_info *sfb,
 		struct pci_dev *pdev, u_long smem_len)
 {
-	if (sfb->fb.var.bits_per_pixel == 32) {
+
+	sfb->fb.fix.smem_start = pci_resource_start(pdev, 0);
+
 #ifdef __BIG_ENDIAN
-		sfb->fb.fix.smem_start = pci_resource_start(pdev, 0)
-			+ 0x800000;
-#else
-		sfb->fb.fix.smem_start = pci_resource_start(pdev, 0);
+	if (sfb->fb.var.bits_per_pixel == 32)
+		sfb->fb.fix.smem_start += 0x800000;
 #endif
-	} else {
-		sfb->fb.fix.smem_start = pci_resource_start(pdev, 0);
-	}
 
 	sfb->fb.fix.smem_len = smem_len;
 
-- 
1.7.10

