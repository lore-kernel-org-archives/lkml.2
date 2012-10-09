Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830Ab2JIUOm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 16:14:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:55093 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255Ab2JIUOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 16:14:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: arm@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        linux-samsung-soc@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net
Subject: [PATCH v2 v2 v2 8/8] spi/s3c64xx: use correct dma_transfer_direction type
Date: Tue,  9 Oct 2012 22:13:58 +0200
Message-Id: <1349813638-4617-9-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1349813638-4617-1-git-send-email-arnd@arndb.de>
References: <1349813638-4617-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:K1ol/Cd3KrrQPauNR/ShSFuQ4k5gbg5VAGtb6igR2Ms
 WOtKj95SoW/n2Loke5UpKjgvmSZf9vnFLdAmhbZDPPiJEgWZvt
 25A65YEP/NkBha1zEnvSApRyMrTQZ6enqDmpf0nO/tGKD6VDkE
 OKTjCZLM753d4g9fkIUuGwGIORtB9cqMfOR4lM3wfG+/ne4UMV
 VWn66dF25pRj+1TtXJkGH78+TFeEumm1nC7Y4SXHdF31nBmjdU
 +TTTqnT56G77zaA5fCQjh6uCbPryKmE0pqOzvcK2i6BQa6UhYe
 Vrpfqr51XLalQ3BfekXqrTE1IRooetATO9ZPz5g/D2mEgNeMlX
 +8LGXXAcL2btFnb8kTVWhduRczMNoT7VEF/A0rR69
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a subtle difference between dma_transfer_direction and
dma_data_direction: the former is used by the dmaengine framework,
while the latter is used by the dma-mapping API. Although the
purpose is comparable, the actual values are different and must
not be mixed. In this case, the driver just wants to use
dma_transfer_direction.

Without this patch, building s3c6400_defconfig results in:

drivers/spi/spi-s3c64xx.c: In function 's3c64xx_spi_dmacb':
drivers/spi/spi-s3c64xx.c:239:21: warning: comparison between
	'enum dma_data_direction' and 'enum dma_transfer_direction' [-Wenum-compare]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-samsung-soc@vger.kernel.org
Cc: spi-devel-general@lists.sourceforge.net
---
 drivers/spi/spi-s3c64xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
index d1c8441f..2e44dd6 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -132,7 +132,7 @@
 
 struct s3c64xx_spi_dma_data {
 	unsigned		ch;
-	enum dma_data_direction direction;
+	enum dma_transfer_direction direction;
 	enum dma_ch	dmach;
 	struct property		*dma_prop;
 };
-- 
1.7.10

