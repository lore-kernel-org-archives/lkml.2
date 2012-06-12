Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140Ab2FLK45 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 06:56:57 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:48194 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751092Ab2FLK44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 06:56:56 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH] pinctrl: nomadik: fix up typo
Date: Tue, 12 Jun 2012 12:56:32 +0200
Message-ID: <1339498592-1435-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit a60b57eddaa8af6c02cf7bbeb58ebf82881f08ac
"drivers/gpio: gpio-nomadik: Add support for irqdomains"
changed GPIO offset calculations to have this form:
(gpio % NMK_GPIO_PER_CHIP) except in this one place for
setting sleep mode, where the conversion was all wrong, and
instead mod:ing the GPIO with the IRQ base which does not
make any sense.

So fix this up so we can use sleepmode.

Cc: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/pinctrl/pinctrl-nomadik.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index ba7122f..e8937e7 100644
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@ -673,7 +673,7 @@ static void __nmk_gpio_set_wake(struct nmk_gpio_chip *nmk_chip,
 	 * wakeup is anyhow controlled by the RIMSC and FIMSC registers.
 	 */
 	if (nmk_chip->sleepmode && on) {
-		__nmk_gpio_set_slpm(nmk_chip, gpio % nmk_chip->chip.base,
+		__nmk_gpio_set_slpm(nmk_chip, gpio % NMK_GPIO_PER_CHIP,
 				    NMK_GPIO_SLPM_WAKEUP_ENABLE);
 	}
 
-- 
1.7.9.2

