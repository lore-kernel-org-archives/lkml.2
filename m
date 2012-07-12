Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758709Ab2GLHFu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 03:05:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42100 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758650Ab2GLHFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 03:05:47 -0400
From: Gerard Snitselaar <dev@snitselaar.org>
To: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        stuart.yoder@freescale.com, benh@kernel.crashing.org
Subject: [PATCH] powerpc: remove rejected merge file from arch/powerpc/kernel in linux-next
Date: Thu, 12 Jul 2012 00:05:34 -0700
Message-Id: <1342076734-30996-1-git-send-email-dev@snitselaar.org>
X-Mailer: git-send-email 1.7.11.1.165.g299666c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 9778b696 (powerpc: Use CURRENT_THREAD_INFO instead of open
coded assembly) got a rejected merge file iommu.c.rej committed with
it.

Signed-off-by: Gerard Snitselaar <dev@snitselaar.org>
---
 arch/powerpc/kernel/iommu.c.rej | 22 ----------------------
 1 file changed, 22 deletions(-)
 delete mode 100644 arch/powerpc/kernel/iommu.c.rej

diff --git a/arch/powerpc/kernel/iommu.c.rej b/arch/powerpc/kernel/iommu.c.rej
deleted file mode 100644
index 9d10d34..0000000
--- a/arch/powerpc/kernel/iommu.c.rej
+++ /dev/null
@@ -1,22 +0,0 @@
---- arch/powerpc/kernel/iommu.c	2012-06-08 09:01:02.785709100 +1000
-+++ arch/powerpc/kernel/iommu.c	2012-06-08 09:01:07.489784856 +1000
-@@ -33,7 +33,9 @@
- #include <linux/bitmap.h>
- #include <linux/iommu-helper.h>
- #include <linux/crash_dump.h>
-+#include <linux/fault-inject.h>
- #include <asm/io.h>
-+#include <asm/vio.h>
- #include <asm/prom.h>
- #include <asm/iommu.h>
- #include <asm/pci-bridge.h>
-@@ -171,6 +261,9 @@
- 		return DMA_ERROR_CODE;
- 	}
- 
-+	if (should_fail_iommu(dev))
-+		return DMA_ERROR_CODE;
-+
- 	if (handle && *handle)
- 		start = *handle;
- 	else
-- 
1.7.11.1.165.g299666c

