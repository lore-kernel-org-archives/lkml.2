Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932967Ab2JSPJ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 11:09:57 -0400
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:36186 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751368Ab2JSPJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 11:09:56 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH] pinctrl/nomadik: use irq_create_mapping()
Date: Fri, 19 Oct 2012 17:09:35 +0200
Message-ID: <1350659375-7335-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

Since in the DT case, the linear domain path will not allocate
descriptors for the IRQs, we need to use irq_create_mapping()
for mapping hwirqs to Linux IRQs, so these descriptors get
created on-the-fly in this case.

Cc: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinctrl-nomadik.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index 01aea1c..d1d3cb9 100644
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@ -931,7 +931,7 @@ static void __nmk_gpio_irq_handler(unsigned int irq, struct irq_desc *desc,
 	while (status) {
 		int bit = __ffs(status);
 
-		generic_handle_irq(irq_find_mapping(nmk_chip->domain, bit));
+		generic_handle_irq(irq_create_mapping(nmk_chip->domain, bit));
 		status &= ~BIT(bit);
 	}
 
@@ -1056,7 +1056,7 @@ static int nmk_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
 	struct nmk_gpio_chip *nmk_chip =
 		container_of(chip, struct nmk_gpio_chip, chip);
 
-	return irq_find_mapping(nmk_chip->domain, offset);
+	return irq_create_mapping(nmk_chip->domain, offset);
 }
 
 #ifdef CONFIG_DEBUG_FS
-- 
1.7.11.3

