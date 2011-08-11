Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903Ab1HKUng (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 16:43:36 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40504 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603Ab1HKUnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 16:43:33 -0400
From: Stephen Warren <swarren@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Russell King <linux@arm.linux.org.uk>,
        Colin Cross <ccross@android.com>, Erik Gilling <konkers@android.com>,
        Olof Johansson <olof@lixom.net>
Cc: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH v2 2/4] gpio/tegra: Implement gpio_chip.to_irq
Date: Thu, 11 Aug 2011 14:43:22 -0600
Message-Id: <1313095404-27858-2-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1313095404-27858-1-git-send-email-swarren@nvidia.com>
References: <1313095404-27858-1-git-send-email-swarren@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/gpio/gpio-tegra.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpio-tegra.c b/drivers/gpio/gpio-tegra.c
index ecade29..df64536 100644
--- a/drivers/gpio/gpio-tegra.c
+++ b/drivers/gpio/gpio-tegra.c
@@ -134,7 +134,10 @@ static int tegra_gpio_direction_output(struct gpio_chip *chip, unsigned offset,
 	return 0;
 }
 
-
+static int tegra_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
+{
+	return TEGRA_GPIO_TO_IRQ(offset);
+}
 
 static struct gpio_chip tegra_gpio_chip = {
 	.label			= "tegra-gpio",
@@ -142,6 +145,7 @@ static struct gpio_chip tegra_gpio_chip = {
 	.get			= tegra_gpio_get,
 	.direction_output	= tegra_gpio_direction_output,
 	.set			= tegra_gpio_set,
+	.to_irq			= tegra_gpio_to_irq,
 	.base			= 0,
 	.ngpio			= TEGRA_NR_GPIOS,
 };
-- 
1.7.0.4

