Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161389Ab2JXWJk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 18:09:40 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:64288 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161226Ab2JXWJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 18:09:38 -0400
From: Omar Ramirez Luna <omar.ramirez@copitl.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Victor Manuel Jaquez Leal <vjaquez@igalia.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Omar Ramirez Luna <omar.ramirez@copitl.com>
Subject: [PATCH 1/6] staging: tidspbridge: request the right irq for mmu
Date: Wed, 24 Oct 2012 17:09:15 -0500
Message-Id: <1351116560-6918-2-git-send-email-omar.ramirez@copitl.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351116560-6918-1-git-send-email-omar.ramirez@copitl.com>
References: <1351116560-6918-1-git-send-email-omar.ramirez@copitl.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Requested irq for mmu is currently conflicting with a DMA irq
due to recent changes to irq header files, now the offset for the
start of the interrupt controller numbering has changed.

This should be removed during a future migration to omap-iommu,
for now it is hardcoded.

Signed-off-by: Omar Ramirez Luna <omar.ramirez@copitl.com>
---

Intended for 3.7 due to code changes during rc1.

 .../tidspbridge/include/dspbridge/host_os.h        |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/tidspbridge/include/dspbridge/host_os.h b/drivers/staging/tidspbridge/include/dspbridge/host_os.h
index ed00d3d..5e2f4d8 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/host_os.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/host_os.h
@@ -47,8 +47,8 @@
 #include <asm/cacheflush.h>
 #include <linux/dma-mapping.h>
 
-/* TODO -- Remove, once BP defines them */
-#define INT_DSP_MMU_IRQ        28
+/* TODO -- Remove, once omap-iommu is used */
+#define INT_DSP_MMU_IRQ        (28 + NR_IRQS)
 
 #define PRCM_VDD1 1
 
-- 
1.7.9.5

