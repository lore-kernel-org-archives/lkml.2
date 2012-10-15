Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212Ab2JOVyn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 17:54:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62303 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932182Ab2JOVyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 17:54:40 -0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Sascha Hauer <kernel@pengutronix.de>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Subject: [PATCH 02/10] ARM: plat-s3c24xx: Don't use FIQ_START
Date: Mon, 15 Oct 2012 14:51:26 -0700
Message-Id: <1350337894-9744-2-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.12.3
In-Reply-To: <20121015214954.GA3352@lizard>
References: <20121015214954.GA3352@lizard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're about to remove FIQ_START mess, so move the platform-specific
detail inside platform-specific s3c24xx_set_fiq().

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
Acked-by: Kukjin Kim <kgene.kim@samsung.com>
---
 arch/arm/plat-s3c24xx/irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/plat-s3c24xx/irq.c b/arch/arm/plat-s3c24xx/irq.c
index fe57bbb..e4e9567 100644
--- a/arch/arm/plat-s3c24xx/irq.c
+++ b/arch/arm/plat-s3c24xx/irq.c
@@ -503,7 +503,7 @@ int s3c24xx_set_fiq(unsigned int irq, bool on)
 	unsigned offs;
 
 	if (on) {
-		offs = irq - FIQ_START;
+		offs = irq - IRQ_EINT0;
 		if (offs > 31)
 			return -EINVAL;
 
-- 
1.7.12.3

