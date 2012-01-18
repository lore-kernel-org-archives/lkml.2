Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757741Ab2AROiC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 09:38:02 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15720 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757709Ab2AROiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 09:38:00 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 18 Jan 2012 06:37:59 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: grant.likely@secretlab.ca, linus.walleij@stericsson.com
Cc: linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        ldewangan@nvidia.com
Subject: [PATCH V1] gpio: tps65910: Use correct offset for gpio initialization
Date: Wed, 18 Jan 2012 20:07:35 +0530
Message-Id: <1326897455-8298-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the correct gpio offset for setting the initial value
of gpio when setting output direction.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/gpio/gpio-tps65910.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpio-tps65910.c b/drivers/gpio/gpio-tps65910.c
index b9c1c29..91f45b9 100644
--- a/drivers/gpio/gpio-tps65910.c
+++ b/drivers/gpio/gpio-tps65910.c
@@ -52,7 +52,7 @@ static int tps65910_gpio_output(struct gpio_chip *gc, unsigned offset,
 	struct tps65910 *tps65910 = container_of(gc, struct tps65910, gpio);
 
 	/* Set the initial value */
-	tps65910_gpio_set(gc, 0, value);
+	tps65910_gpio_set(gc, offset, value);
 
 	return tps65910_set_bits(tps65910, TPS65910_GPIO0 + offset,
 						GPIO_CFG_MASK);
-- 
1.7.1.1

