Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293Ab1JGEU0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 00:20:26 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64807 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab1JGEUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 00:20:25 -0400
Subject: [PATCH] ARM: SAMSUNG: s3c-dma-ops needs export.h for EXPORT_SYMBOL
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Oct 2011 12:20:14 +0800
Message-ID: <1317961214.16109.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix below build warning:
  CC      arch/arm/plat-samsung/s3c-dma-ops.o
arch/arm/plat-samsung/s3c-dma-ops.c:130: warning: data definition has no type or storage class
arch/arm/plat-samsung/s3c-dma-ops.c:130: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
arch/arm/plat-samsung/s3c-dma-ops.c:130: warning: parameter names (without types) in function declaration

And fix the build error:
ERROR: "s3c_dma_get_ops" [drivers/spi/spi-s3c64xx.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
This can be reproduced by "make s3c6400_defconfig;make" on linux-next 20111006.
 arch/arm/plat-samsung/s3c-dma-ops.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/plat-samsung/s3c-dma-ops.c b/arch/arm/plat-samsung/s3c-dma-ops.c
index 582333c..7814949 100644
--- a/arch/arm/plat-samsung/s3c-dma-ops.c
+++ b/arch/arm/plat-samsung/s3c-dma-ops.c
@@ -14,6 +14,7 @@
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/types.h>
+#include <linux/export.h>
 
 #include <mach/dma.h>
 
-- 
1.7.4.1



