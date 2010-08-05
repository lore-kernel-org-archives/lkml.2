Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933592Ab0HEPQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 11:16:18 -0400
Received: from gate.crashing.org ([63.228.1.57]:52413 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933450Ab0HEPQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 11:16:10 -0400
From: Kumar Gala <galak@kernel.crashing.org>
To: gregkh@suse.de
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        akpm@linux-foundation.org
Subject: [PATCH 2/3] powerpc: implement arch_setup_pdev_archdata
Date: Thu,  5 Aug 2010 10:15:46 -0500
Message-Id: <1281021347-1278-3-git-send-email-galak@kernel.crashing.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1281021347-1278-2-git-send-email-galak@kernel.crashing.org>
References: <1281021347-1278-1-git-send-email-galak@kernel.crashing.org>
 <1281021347-1278-2-git-send-email-galak@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have a long standing issues with platform devices not have a valid
dma_mask pointer.  This hasn't been an issue to date as no platform
device has tried to set its dma_mask value to a non-default value.

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---
 arch/powerpc/include/asm/platform_device.h |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/include/asm/platform_device.h b/arch/powerpc/include/asm/platform_device.h
index 01452c3..a379500 100644
--- a/arch/powerpc/include/asm/platform_device.h
+++ b/arch/powerpc/include/asm/platform_device.h
@@ -1 +1,15 @@
-#include <asm-generic/platform_device.h>
+#ifndef __ASM_PLATFORM_DEVICE_H_
+#define __ASM_PLATFORM_DEVICE_H_
+
+#include <linux/platform_device.h>
+
+#define ARCH_HAS_PDEV_ARCHDATA_SETUP
+
+static inline void arch_setup_pdev_archdata(struct platform_device *pdev)
+{
+	pdev->dev.dma_mask = &pdev->archdata.dma_mask;
+
+	return;
+}
+
+#endif /* __ASM_GENERIC_PLATFORM_DEVICE_H_ */
-- 
1.6.0.6

