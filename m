Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082Ab0F3P6w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 11:58:52 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:39807 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756312Ab0F3P6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 11:58:50 -0400
Date: Wed, 30 Jun 2010 17:58:48 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: vamos@i4.informatik.uni-erlangen.de
Subject: [PATCH 15/33] Removing dead PROCESSOR_NS9750
Message-ID: <73d2b3929175d36d8bfdedf2d49150d2ed911b2a.1277911346.git.siccegge@cs.fau.de>
References: <cover.1277911345.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1277911345.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PROCESSOR_NS9750 doesn't exist in Kconfig, therefore removing all
references for it from the source code.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
 arch/arm/mach-ns9xxx/gpio.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-ns9xxx/gpio.c b/arch/arm/mach-ns9xxx/gpio.c
index 5503ca0..58f4f50 100644
--- a/arch/arm/mach-ns9xxx/gpio.c
+++ b/arch/arm/mach-ns9xxx/gpio.c
@@ -25,9 +25,6 @@
 
 #if defined(CONFIG_PROCESSOR_NS9360)
 #define GPIO_MAX 72
-#elif defined(CONFIG_PROCESSOR_NS9750)
-#define GPIO_MAX 49
-#endif
 
 /* protects BBU_GCONFx and BBU_GCTRLx */
 static spinlock_t gpio_lock = __SPIN_LOCK_UNLOCKED(gpio_lock);
@@ -42,11 +39,6 @@ static inline int ns9xxx_valid_gpio(unsigned gpio)
 		return gpio <= 72;
 	else
 #endif
-#if defined(CONFIG_PROCESSOR_NS9750)
-	if (processor_is_ns9750())
-		return gpio <= 49;
-	else
-#endif
 	{
 		BUG();
 		return 0;
-- 
1.7.0.4

