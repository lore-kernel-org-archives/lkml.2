Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871Ab2JWIg3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 04:36:29 -0400
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:43780 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751728Ab2JWIg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 04:36:26 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v2] pinctrl/nomadik: use irq_create_mapping()
Date: Tue, 23 Oct 2012 10:35:39 +0200
Message-ID: <1350981339-13316-1-git-send-email-linus.walleij@stericsson.com>
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

ChangeLog v1->v2:

- Just use irq_create_mapping() in the .to_irq function since
  this is called before unmasking or enabling any interrupt
  lines, so irq_find_mapping() should be sufficient for the
  IRQ handler function.

Cc: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinctrl-nomadik.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index 01aea1c..db5e0b3 100644
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@ -1056,7 +1056,7 @@ static int nmk_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
 	struct nmk_gpio_chip *nmk_chip =
 		container_of(chip, struct nmk_gpio_chip, chip);
 
-	return irq_find_mapping(nmk_chip->domain, offset);
+	return irq_create_mapping(nmk_chip->domain, offset);
 }
 
 #ifdef CONFIG_DEBUG_FS
-- 
1.7.11.3

