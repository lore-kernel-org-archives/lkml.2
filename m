Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab2FFLzX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 07:55:23 -0400
Received: from hulk.biessmann.org ([62.75.166.25]:37009 "EHLO
	hulk.biessmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109Ab2FFLzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 07:55:22 -0400
X-Greylist: delayed 1915 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Jun 2012 07:55:22 EDT
From: =?UTF-8?q?Andreas=20Bie=C3=9Fmann?= <andreas@biessmann.de>
To: linux-kernel@vger.kernel.org
Cc: Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        =?UTF-8?q?Andreas=20Bie=C3=9Fmann?= <andreas@biessmann.de>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] arm:gemini: fix irq.c
Date: Wed,  6 Jun 2012 13:22:58 +0200
Message-Id: <1338981778-19938-1-git-send-email-andreas@biessmann.de>
X-Mailer: git-send-email 1.7.10
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SPAM_bar: --
X-SPAM_score: -28
X-ChkData-Signature: 479a4824087870c93aa9915b09c024b1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 9f97da78bf018206fb623cd351d454af2f105fe0 moved disable_hlt() from
arch/arm/include/asm/system.h to arch/arm/include/asm/system_misc.h but missed
to change arch/arm/mach-gemini/irq.c.

This patch fixes following error:

---8<---
arch/arm/mach-gemini/irq.c: In function 'gemini_init_irq':
arch/arm/mach-gemini/irq.c:79:2: error: implicit declaration of function 'disable_hlt' [-Werror=implicit-function-declaration]
--->8---

Signed-off-by: Andreas Bießmann <andreas@biessmann.de>
cc: Hans Ulli Kroll <ulli.kroll@googlemail.com> 
cc: Russell King <linux@arm.linux.org.uk>
cc: linux-arm-kernel@lists.infradead.org
---
Note: this is broken since 3.4 release, 3.3 is sane.

 arch/arm/mach-gemini/irq.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-gemini/irq.c b/arch/arm/mach-gemini/irq.c
index ca70e5f..020852d 100644
--- a/arch/arm/mach-gemini/irq.c
+++ b/arch/arm/mach-gemini/irq.c
@@ -17,6 +17,7 @@
 #include <linux/sched.h>
 #include <asm/irq.h>
 #include <asm/mach/irq.h>
+#include <asm/system_misc.h>
 #include <mach/hardware.h>
 
 #define IRQ_SOURCE(base_addr)	(base_addr + 0x00)
-- 
1.7.10

