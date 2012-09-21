Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757085Ab2IUP6S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 11:58:18 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54171 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756850Ab2IUP5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 11:57:31 -0400
From: Cyril Chemparathy <cyril@ti.com>
To: <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <arnd@arndb.de>, <catalin.marinas@arm.com>, <davidb@codeaurora.org>,
        <frank.rowand@am.sony.com>, <hsweeten@visionengravers.com>,
        <linus.walleij@linaro.org>, <marc.zyngier@arm.com>, <nico@linaro.org>,
        <paul.gortmaker@windriver.com>, <plagnioj@jcrosoft.com>,
        <rabin@rab.in>, <rmallon@gmail.com>, <rob.herring@calxeda.com>,
        <sboyd@codeaurora.org>, <sjg@chromium.org>, <tglx@linutronix.de>,
        <tj@kernel.org>, <vincent.guittot@linaro.org>, <vitalya@ti.com>,
        <will.deacon@arm.com>, <grant.likely@secretlab.ca>,
        Cyril Chemparathy <cyril@ti.com>
Subject: [PATCH v3 RESEND 12/17] ARM: LPAE: define ARCH_LOW_ADDRESS_LIMIT for bootmem
Date: Fri, 21 Sep 2012 11:56:10 -0400
Message-ID: <1348242975-19184-13-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348242975-19184-1-git-send-email-cyril@ti.com>
References: <1348242975-19184-1-git-send-email-cyril@ti.com>
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
index f3e8f88..19221c2 100644
--- a/arch/arm/include/asm/memory.h
+++ b/arch/arm/include/asm/memory.h
@@ -315,6 +315,8 @@ static inline __deprecated void *bus_to_virt(unsigned long x)
 #define arch_is_coherent()		0
 #endif
 
+#define ARCH_LOW_ADDRESS_LIMIT		PHYS_MASK
+
 #endif
 
 #include <asm-generic/memory_model.h>
-- 
1.7.9.5

