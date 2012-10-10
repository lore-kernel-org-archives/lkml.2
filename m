Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985Ab2JJMii (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 08:38:38 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:37713 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755271Ab2JJMif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 08:38:35 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Patrice Chotard <patrice.chotard@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 2/5] ARM: plat-nomadik: move NMK_GPIO_PER_CHIP into gpio-nomadik.h
Date: Wed, 10 Oct 2012 14:38:09 +0200
Message-ID: <1349872689-31210-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrice Chotard <patrice.chotard@stericsson.com>

Move NMK_GPIO_PER_CHIP to gpio-nomadik.h and define it with a
shift operator.

Signed-off-by: Patrice Chotard <patrice.chotard@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/plat-nomadik/include/plat/gpio-nomadik.h | 3 +++
 drivers/pinctrl/pinctrl-nomadik.c                 | 2 --
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/plat-nomadik/include/plat/gpio-nomadik.h b/arch/arm/plat-nomadik/include/plat/gpio-nomadik.h
index cf81111..a749994 100644
--- a/arch/arm/plat-nomadik/include/plat/gpio-nomadik.h
+++ b/arch/arm/plat-nomadik/include/plat/gpio-nomadik.h
@@ -18,6 +18,9 @@
  * the "gpio" namespace for generic and cross-machine functions
  */
 
+#define GPIO_BLOCK_SHIFT 5
+#define NMK_GPIO_PER_CHIP (1 << GPIO_BLOCK_SHIFT)
+
 /* Register in the logic block */
 #define NMK_GPIO_DAT	0x00
 #define NMK_GPIO_DATS	0x04
diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index fec9c30..334cd2f 100644
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@ -47,8 +47,6 @@
  * Symbols in this file are called "nmk_gpio" for "nomadik gpio"
  */
 
-#define NMK_GPIO_PER_CHIP	32
-
 struct nmk_gpio_chip {
 	struct gpio_chip chip;
 	struct irq_domain *domain;
-- 
1.7.11.3

