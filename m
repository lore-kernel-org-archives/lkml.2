Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab1HJMSL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 08:18:11 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:35062 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753917Ab1HJMSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 08:18:07 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Grant Likely <grant.likely@secretlab.ca>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        Lennert Buytenhek <kernel@wantstofly.org>
Subject: [PATCH 11/19] mach-ixp2000: rename GPIO header
Date: Wed, 10 Aug 2011 14:17:43 +0200
Message-ID: <1312978663-18438-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

The ixp2000 abuses the <mach/gpio.h> namespace by not implementing
any generic GPIO nor gpiolib functions in it - just custom GPIO.
Rename the header to <mach/gpio-ixp2000.h> for clarity.

Cc: Lennert Buytenhek <kernel@wantstofly.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-ixp2000/core.c                       |    2 ++
 .../include/mach/{gpio.h => gpio-ixp2000.h}        |    0
 arch/arm/mach-ixp2000/ixdp2x00.c                   |    1 +
 drivers/i2c/busses/i2c-ixp2000.c                   |    2 +-
 4 files changed, 4 insertions(+), 1 deletions(-)
 rename arch/arm/mach-ixp2000/include/mach/{gpio.h => gpio-ixp2000.h} (100%)

diff --git a/arch/arm/mach-ixp2000/core.c b/arch/arm/mach-ixp2000/core.c
index e95c5e7..59a5126 100644
--- a/arch/arm/mach-ixp2000/core.c
+++ b/arch/arm/mach-ixp2000/core.c
@@ -39,6 +39,8 @@
 #include <asm/mach/time.h>
 #include <asm/mach/irq.h>
 
+#include <mach/gpio-ixp2000.h>
+
 static DEFINE_SPINLOCK(ixp2000_slowport_lock);
 static unsigned long ixp2000_slowport_irq_flags;
 
diff --git a/arch/arm/mach-ixp2000/include/mach/gpio.h b/arch/arm/mach-ixp2000/include/mach/gpio-ixp2000.h
similarity index 100%
rename from arch/arm/mach-ixp2000/include/mach/gpio.h
rename to arch/arm/mach-ixp2000/include/mach/gpio-ixp2000.h
diff --git a/arch/arm/mach-ixp2000/ixdp2x00.c b/arch/arm/mach-ixp2000/ixdp2x00.c
index f615068..634b6c8 100644
--- a/arch/arm/mach-ixp2000/ixdp2x00.c
+++ b/arch/arm/mach-ixp2000/ixdp2x00.c
@@ -41,6 +41,7 @@
 #include <asm/mach/flash.h>
 #include <asm/mach/arch.h>
 
+#include <mach/gpio-ixp2000.h>
 
 /*************************************************************************
  * IXDP2x00 IRQ Initialization
diff --git a/drivers/i2c/busses/i2c-ixp2000.c b/drivers/i2c/busses/i2c-ixp2000.c
index be9991b..c01e951 100644
--- a/drivers/i2c/busses/i2c-ixp2000.c
+++ b/drivers/i2c/busses/i2c-ixp2000.c
@@ -35,7 +35,7 @@
 #include <linux/slab.h>
 
 #include <mach/hardware.h>	/* Pick up IXP2000-specific bits */
-#include <asm/gpio.h>
+#include <mach/gpio-ixp2000.h>
 
 static inline int ixp2000_scl_pin(void *data)
 {
-- 
1.7.3.2

