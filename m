Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126Ab2H0XqM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 19:46:12 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:37168 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755056Ab2H0XqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 19:46:10 -0400
MBOX-Line: From nobody Mon Aug 27 17:36:12 2012
Subject: [PATCH 5/5] hwrng: OMAP: remove SoC restrictions from driver
 registration
To: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
From: Paul Walmsley <paul@pwsan.com>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>, Matt Mackall <mpm@selenic.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 27 Aug 2012 17:36:12 -0600
Message-ID: <20120827233611.15045.19688.stgit@dusk.lan>
In-Reply-To: <20120827232922.15045.56522.stgit@dusk.lan>
References: <20120827232922.15045.56522.stgit@dusk.lan>
User-Agent: StGit/0.16-37-g27ac3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the SoC restriction code from the OMAP RNG driver.  The
integration code in arch/arm/*omap* should handle this.  The device
shouldn't be created if it doesn't exist on the currently-booted SoC.

This allows us to remove some OMAP-specific cpu_is_omap*() calls from
the driver.  Also, if other OMAP chips have RNGs that can be used
by Linux, there will be no need to modify the driver.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/arm/mach-omap1/devices.c     |    3 +++
 drivers/char/hw_random/omap-rng.c |    3 ---
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-omap1/devices.c b/arch/arm/mach-omap1/devices.c
index 7f3d9d2..aedd7a4 100644
--- a/arch/arm/mach-omap1/devices.c
+++ b/arch/arm/mach-omap1/devices.c
@@ -377,6 +377,9 @@ static struct platform_device omap1_rng_device = {
 
 static void omap1_init_rng(void)
 {
+	if (!cpu_is_omap16xx())
+		return;
+
 	(void) platform_device_register(&omap1_rng_device);
 }
 
diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
index 748fcc8..a5effd8 100644
--- a/drivers/char/hw_random/omap-rng.c
+++ b/drivers/char/hw_random/omap-rng.c
@@ -220,9 +220,6 @@ static struct platform_driver omap_rng_driver = {
 
 static int __init omap_rng_init(void)
 {
-	if (!cpu_is_omap16xx() && !cpu_is_omap24xx())
-		return -ENODEV;
-
 	return platform_driver_register(&omap_rng_driver);
 }
 


