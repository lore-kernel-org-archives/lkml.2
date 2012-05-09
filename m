Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761400Ab2EJAHE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 20:07:04 -0400
Received: from lmv.inov.pt ([146.193.64.2]:56939 "EHLO lmv.inov.pt"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754159Ab2EJAHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 20:07:01 -0400
X-Greylist: delayed 1041 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 May 2012 20:07:01 EDT
From: =?UTF-8?q?Jos=C3=A9=20Miguel=20Gon=C3=A7alves?= 
	<jose.goncalves@inov.pt>
To: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Jos=C3=A9=20Miguel=20Gon=C3=A7alves?= 
	<jose.goncalves@inov.pt>
Subject: [PATCH] ARM: SAMSUNG: Fix for S3C2412 EBI memory mapping.
Date: Thu, 10 May 2012 00:46:49 +0100
Message-Id: <1336607209-6409-1-git-send-email-jose.goncalves@inov.pt>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0.1 (lmv.inov.pt [146.193.64.2]); Thu, 10 May 2012 00:47:22 +0100 (WEST)
X-INOV-EmailServer-Information: Please contact the Email service provider for more information
X-INOV-EmailServer: Found to be clean
X-INOV-EmailServer-From: jose.goncalves@inov.pt
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While upgrading the kernel on a S3C2412 based board I've noted that it was impossible to boot the board with a 2.6.32 or upper kernel.
I've tracked down the problem to the EBI virtual memory mapping that is in conflict with the IO mapping definition in arch/arm/mach-s3c24xx/s3c2412.c.

Signed-off-by: José Miguel Gonçalves <jose.goncalves@inov.pt>
---
 arch/arm/plat-samsung/include/plat/map-s3c.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
-- 
1.7.5.4

