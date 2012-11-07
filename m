Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab2KGPDz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 10:03:55 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9575 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392Ab2KGPDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 10:03:54 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 07 Nov 2012 07:03:52 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <linus.walleij@linaro.org>, <grant.likely@secretlab.ca>
CC: <swarren@nvidia.com>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 1/2] gpio: tegra: create irq mapping in gpio_to_irq
Date: Wed, 7 Nov 2012 20:31:31 +0530
Message-ID: <1352300492-24779-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The gpio interrupts get mapped linearly and hence the mapping
of irq need to be created by irq_create_mapping().

The function gpio_to_irq() returns the irq by irq_find_mapping()
and so returns 0 as there is no mapping created. Fix the function
to create mapping when gpio_to_irq() get called.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/gpio/gpio-tegra.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpio-tegra.c b/drivers/gpio/gpio-tegra.c
index c7c175a..6c08613 100644
--- a/drivers/gpio/gpio-tegra.c
+++ b/drivers/gpio/gpio-tegra.c
@@ -156,7 +156,7 @@ static int tegra_gpio_direction_output(struct gpio_chip *chip, unsigned offset,
 
 static int tegra_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
 {
-	return irq_find_mapping(irq_domain, offset);
+	return irq_create_mapping(irq_domain, offset);
 }
 
 static struct gpio_chip tegra_gpio_chip = {
-- 
1.7.1.1

