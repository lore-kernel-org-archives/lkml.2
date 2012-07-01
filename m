Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab2GASVG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 14:21:06 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47011 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755999Ab2GASQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 14:16:43 -0400
Message-Id: <20120701172011.231288968@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 01 Jul 2012 18:20:38 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Jose Miguel Goncalves <jose.goncalves@inov.pt>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [ 32/48] ARM: SAMSUNG: Fix for S3C2412 EBI memory mapping
In-Reply-To: <20120701172006.535271340@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jose Miguel Goncalves <jose.goncalves@inov.pt>

commit 3dca938656c7b0ff6b0717a5dde0f5f45e592be5 upstream.

While upgrading the kernel on a S3C2412 based board I've noted
that it was impossible to boot the board with a 2.6.32 or upper
kernel. I've tracked down the problem to the EBI virtual memory
mapping that is in conflict with the IO mapping definition in
arch/arm/mach-s3c24xx/s3c2412.c.

Signed-off-by: Jose Miguel Goncalves <jose.goncalves@inov.pt>
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/plat-samsung/include/plat/map-s3c.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/plat-samsung/include/plat/map-s3c.h b/arch/arm/plat-samsung/include/plat/map-s3c.h
index 7d04875..c0c70a8 100644
--- a/arch/arm/plat-samsung/include/plat/map-s3c.h
+++ b/arch/arm/plat-samsung/include/plat/map-s3c.h
@@ -22,7 +22,7 @@
 #define S3C24XX_VA_WATCHDOG	S3C_VA_WATCHDOG
 
 #define S3C2412_VA_SSMC		S3C_ADDR_CPU(0x00000000)
-#define S3C2412_VA_EBI		S3C_ADDR_CPU(0x00010000)
+#define S3C2412_VA_EBI		S3C_ADDR_CPU(0x00100000)
 
 #define S3C2410_PA_UART		(0x50000000)
 #define S3C24XX_PA_UART		S3C2410_PA_UART


