Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab2KIGGx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 01:06:53 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10806 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab2KIGGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 01:06:50 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 08 Nov 2012 21:53:26 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <linus.walleij@linaro.org>, <grant.likely@secretlab.ca>
CC: <swarren@nvidia.com>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2] gpio: tegra: read output value when gpio is set in direction_out
Date: Fri, 9 Nov 2012 11:34:20 +0530
Message-ID: <1352441060-31559-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Read the output value when gpio is set for the output mode for
gpio_get_value(). Reading input value in direction out does not
give correct value.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes from V1:
- Keep the if part implementation same the else part to have implementation
  same kind.

 drivers/gpio/gpio-tegra.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/gpio-tegra.c b/drivers/gpio/gpio-tegra.c
index c7c175a..1163cf1 100644
--- a/drivers/gpio/gpio-tegra.c
+++ b/drivers/gpio/gpio-tegra.c
@@ -135,6 +135,11 @@ static void tegra_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
 
 static int tegra_gpio_get(struct gpio_chip *chip, unsigned offset)
 {
+	/* If gpio is in output mode then read from the out value */
+	if ((tegra_gpio_readl(GPIO_OE(offset)) >> GPIO_BIT(offset)) & 1)
+		return (tegra_gpio_readl(GPIO_OUT(offset)) >>
+				GPIO_BIT(offset)) & 0x1;
+
 	return (tegra_gpio_readl(GPIO_IN(offset)) >> GPIO_BIT(offset)) & 0x1;
 }
 
-- 
1.7.1.1

