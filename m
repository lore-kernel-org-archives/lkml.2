Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785Ab2ILPn4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 11:43:56 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:40164 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974Ab2ILPnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 11:43:55 -0400
From: Cyril Chemparathy <cyril@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: Russell King <linux@arm.linux.org.uk>, Nicolas Pitre <nico@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        <u.kleine-koenig@pengutronix.de>, Cyril Chemparathy <cyril@ti.com>
Subject: [PATCH] ARM: fix type of PHYS_PFN_OFFSET to unsigned long
Date: Wed, 12 Sep 2012 11:43:32 -0400
Message-ID: <1347464612-22727-1-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On LPAE machines, PHYS_OFFSET evaluates to a phys_addr_t and this type is
inherited by the PHYS_PFN_OFFSET definition as well.  Consequently, the kernel
build emits warnings of the form:

init/main.c: In function 'start_kernel':
init/main.c:588:7: warning: format '%lx' expects argument of type 'long unsigned int', but argument 2 has type 'phys_addr_t' [-Wformat]

This patch fixes this warning by pinning down the PFN type to unsigned long.

Signed-off-by: Cyril Chemparathy <cyril@ti.com>
---
 arch/arm/include/asm/memory.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/memory.h b/arch/arm/include/asm/memory.h
index 73cf03a..632dc23 100644
--- a/arch/arm/include/asm/memory.h
+++ b/arch/arm/include/asm/memory.h
@@ -207,7 +207,7 @@ static inline unsigned long __phys_to_virt(unsigned long x)
  * direct-mapped view.  We assume this is the first page
  * of RAM in the mem_map as well.
  */
-#define PHYS_PFN_OFFSET	(PHYS_OFFSET >> PAGE_SHIFT)
+#define PHYS_PFN_OFFSET	((unsigned long)(PHYS_OFFSET >> PAGE_SHIFT))
 
 /*
  * These are *only* valid on the kernel direct mapped RAM memory.
-- 
1.7.9.5

