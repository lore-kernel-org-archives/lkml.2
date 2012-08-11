Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759892Ab2HKB0C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 21:26:02 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:60273 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759526Ab2HKBZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 21:25:47 -0400
From: Cyril Chemparathy <cyril@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: <arnd@arndb.de>, <catalin.marinas@arm.com>, <grant.likely@secretlab.ca>,
        <nico@linaro.org>, <linux@arm.linux.org.uk>, <will.deacon@arm.com>,
        Cyril Chemparathy <cyril@ti.com>, Vitaly Andrianov <vitalya@ti.com>
Subject: [PATCH v2 12/22] ARM: LPAE: define ARCH_LOW_ADDRESS_LIMIT for bootmem
Date: Fri, 10 Aug 2012 21:24:55 -0400
Message-ID: <1344648306-15619-13-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344648306-15619-1-git-send-email-cyril@ti.com>
References: <1344648306-15619-1-git-send-email-cyril@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an architecture defined override for ARCH_LOW_ADDRESS_LIMIT.
On PAE systems, the absence of this override causes bootmem to incorrectly
limit itself to 32-bit addressable physical memory.

Signed-off-by: Cyril Chemparathy <cyril@ti.com>
Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
---
 arch/arm/include/asm/memory.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/include/asm/memory.h b/arch/arm/include/asm/memory.h
index dc5fbf3..64db5a4 100644
--- a/arch/arm/include/asm/memory.h
+++ b/arch/arm/include/asm/memory.h
@@ -292,6 +292,8 @@ static inline __deprecated void *bus_to_virt(unsigned long x)
 #define arch_is_coherent()		0
 #endif
 
+#define ARCH_LOW_ADDRESS_LIMIT		PHYS_MASK
+
 #endif
 
 #include <asm-generic/memory_model.h>
-- 
1.7.9.5

