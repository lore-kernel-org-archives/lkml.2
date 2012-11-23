Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007Ab2KWAxd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 19:53:33 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:48031 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756612Ab2KWAxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 19:53:30 -0500
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Jason Wessel <jason.wessel@windriver.com>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: [PATCH 02/10] ARM: plat-s3c24xx: Don't use FIQ_START
Date: Thu, 22 Nov 2012 16:49:55 -0800
Message-Id: <1353631803-4853-2-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <20121123003849.GA973@lizard.mcd25758.sjc.wayport.net>
References: <20121123003849.GA973@lizard.mcd25758.sjc.wayport.net>
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
1.8.0

