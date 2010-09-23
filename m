Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948Ab0IWWjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 18:39:24 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:5476 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937Ab0IWWic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 18:38:32 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org
Cc: David Daney <ddaney@caviumnetworks.com>
Subject: [PATCH 3/9] MIPS: Octeon: Adjust top of DMA32 zone.
Date: Thu, 23 Sep 2010 15:38:10 -0700
Message-Id: <1285281496-24696-4-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1285281496-24696-1-git-send-email-ddaney@caviumnetworks.com>
References: <1285281496-24696-1-git-send-email-ddaney@caviumnetworks.com>
X-OriginalArrivalTime: 23 Sep 2010 22:38:31.0706 (UTC) FILETIME=[0CA907A0:01CB5B70]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On OCTEON, we reserve the last 256MB of 32-bit PCI address space,
mapping the RAM in this region at a high DMA address.  This makes
memory in this region unavailable for 32-bit DMA.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
---
 .../asm/mach-cavium-octeon/cpu-feature-overrides.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/mips/include/asm/mach-cavium-octeon/cpu-feature-overrides.h b/arch/mips/include/asm/mach-cavium-octeon/cpu-feature-overrides.h
index b952fc7..c84ed74 100644
--- a/arch/mips/include/asm/mach-cavium-octeon/cpu-feature-overrides.h
+++ b/arch/mips/include/asm/mach-cavium-octeon/cpu-feature-overrides.h
@@ -81,4 +81,10 @@ static inline int octeon_has_saa(void)
 	return id >= 0x000d0300;
 }
 
+/*
+ * The last 256MB are reserved for device to device mappings and the
+ * BAR1 hole.
+ */
+#define MAX_DMA32_PFN (((1ULL << 32) - (1ULL << 28)) >> PAGE_SHIFT)
+
 #endif
-- 
1.7.2.2

