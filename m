Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab2IBVeW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 17:34:22 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:65319 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183Ab2IBVdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 17:33:12 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>
Subject: [PATCH 7/7] x86, iommu: use NULL instead of plain 0 for __IOMMU_INIT
Date: Sun,  2 Sep 2012 23:31:46 +0200
Message-Id: <1346621506-30857-8-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1346621506-30857-1-git-send-email-minipli@googlemail.com>
References: <1346621506-30857-1-git-send-email-minipli@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IOMMU_INIT_POST and IOMMU_INIT_POST_FINISH pass the plain value 0
instead of NULL to __IOMMU_INIT. Fix this and make sparse happy by
doing so.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 arch/x86/include/asm/iommu_table.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/iommu_table.h b/arch/x86/include/asm/iommu_table.h
index bbf8fb2..f42a047 100644
--- a/arch/x86/include/asm/iommu_table.h
+++ b/arch/x86/include/asm/iommu_table.h
@@ -63,10 +63,10 @@ struct iommu_table_entry {
  * to stop detecting the other IOMMUs after yours has been detected.
  */
 #define IOMMU_INIT_POST(_detect)					\
-	__IOMMU_INIT(_detect, pci_swiotlb_detect_4gb,  0, 0, 0)
+	__IOMMU_INIT(_detect, pci_swiotlb_detect_4gb,  NULL, NULL, 0)
 
 #define IOMMU_INIT_POST_FINISH(detect)					\
-	__IOMMU_INIT(_detect, pci_swiotlb_detect_4gb,  0, 0, 1)
+	__IOMMU_INIT(_detect, pci_swiotlb_detect_4gb,  NULL, NULL, 1)
 
 /*
  * A more sophisticated version of IOMMU_INIT. This variant requires:
-- 
1.7.10.4

