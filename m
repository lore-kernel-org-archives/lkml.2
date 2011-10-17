Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab1JQVET (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 17:04:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51544 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754142Ab1JQVES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 17:04:18 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Kukjin Kim <kgene.kim@samsung.com>, Grant Likely <grant@secretlab.ca>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] gpio/samsung: Complain loudly if we don't know the SoC
Date: Mon, 17 Oct 2011 22:04:15 +0100
Message-Id: <1318885455-905-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we don't know the SoC type then we won't add any chips which is rather
unfortunate as neither GPIO nor pinmux APIs will work, breaking lots of
different subsystems. Logging at least provides a hint to the user as to
what's gone wrong.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/gpio/gpio-samsung.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/gpio-samsung.c b/drivers/gpio/gpio-samsung.c
index 8baa946..90455de 100644
--- a/drivers/gpio/gpio-samsung.c
+++ b/drivers/gpio/gpio-samsung.c
@@ -2495,6 +2495,9 @@ static __init int samsung_gpiolib_init(void)
 		s5p_register_gpioint_bank(IRQ_GPIO_XA, 0, IRQ_GPIO1_NR_GROUPS);
 		s5p_register_gpioint_bank(IRQ_GPIO_XB, IRQ_GPIO1_NR_GROUPS, IRQ_GPIO2_NR_GROUPS);
 #endif
+	} else {
+		pr_crit("Unknown SoC in gpio-samsung, no GPIOs added\n");
+		return -ENODEV;
 	}
 
 	return 0;
-- 
1.7.6.3

