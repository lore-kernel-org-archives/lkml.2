Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586Ab2KPG7i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 01:59:38 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55754 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab2KPG5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 01:57:19 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: patches@linaro.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 07/14] pinctrl: SPEAr: Update error check for unsigned variables
Date: Fri, 16 Nov 2012 12:20:39 +0530
Message-Id: <1353048646-10935-8-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1353048646-10935-1-git-send-email-tushar.behera@linaro.org>
References: <1353048646-10935-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checking '< 0' for unsigned variables always returns false. For error
codes, use IS_ERR_VALUE() instead.

CC: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 drivers/pinctrl/spear/pinctrl-plgpio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pinctrl/spear/pinctrl-plgpio.c b/drivers/pinctrl/spear/pinctrl-plgpio.c
index 1044ad3..9e0c731 100644
--- a/drivers/pinctrl/spear/pinctrl-plgpio.c
+++ b/drivers/pinctrl/spear/pinctrl-plgpio.c
@@ -283,7 +283,7 @@ static int plgpio_to_irq(struct gpio_chip *chip, unsigned offset)
 {
 	struct plgpio *plgpio = container_of(chip, struct plgpio, chip);
 
-	if (plgpio->irq_base < 0)
+	if (IS_ERR_VALUE(plgpio->irq_base))
 		return -EINVAL;
 
 	return irq_find_mapping(plgpio->irq_domain, offset);
-- 
1.7.4.1

