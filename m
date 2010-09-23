Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab0IWWjn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 18:39:43 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:5475 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361Ab0IWWia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 18:38:30 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org
Cc: David Daney <ddaney@caviumnetworks.com>
Subject: [PATCH 2/9] MIPS: Allow MAX_DMA32_PFN to be overridden.
Date: Thu, 23 Sep 2010 15:38:09 -0700
Message-Id: <1285281496-24696-3-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1285281496-24696-1-git-send-email-ddaney@caviumnetworks.com>
References: <1285281496-24696-1-git-send-email-ddaney@caviumnetworks.com>
X-OriginalArrivalTime: 23 Sep 2010 22:38:30.0409 (UTC) FILETIME=[0BE31F90:01CB5B70]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DMA mapping may reduce the usable physical address range usable for
32-bit DMA.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
---
 arch/mips/include/asm/dma.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/mips/include/asm/dma.h b/arch/mips/include/asm/dma.h
index 1353c81..2d47da6 100644
--- a/arch/mips/include/asm/dma.h
+++ b/arch/mips/include/asm/dma.h
@@ -91,7 +91,10 @@
 #define MAX_DMA_ADDRESS		(PAGE_OFFSET + 0x01000000)
 #endif
 #define MAX_DMA_PFN		PFN_DOWN(virt_to_phys((void *)MAX_DMA_ADDRESS))
+
+#ifndef MAX_DMA32_PFN
 #define MAX_DMA32_PFN		(1UL << (32 - PAGE_SHIFT))
+#endif
 
 /* 8237 DMA controllers */
 #define IO_DMA1_BASE	0x00	/* 8 bit slave DMA, channels 0..3 */
-- 
1.7.2.2

