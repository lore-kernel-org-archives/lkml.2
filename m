Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480Ab2JEO4b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 10:56:31 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:54679 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756448Ab2JEO4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 10:56:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        linux-samsung-soc@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net
Subject: [PATCH 15/16] spi/s3c64xx: use correct dma_transfer_direction type
Date: Fri,  5 Oct 2012 16:55:29 +0200
Message-Id: <1349448930-23976-16-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1349448930-23976-1-git-send-email-arnd@arndb.de>
References: <1349448930-23976-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:2aOWXV5bzlX+Eo0mw/vO1uC7Y4ZYB1Uk3pUZiH6CuBp
 QzUlpY4Hhe4tsTKcQXZs4PrE//E6ULRgP0VVmevGRPKHFTlURp
 WNqkH3DGaxYSyF+IjvkCM9lB5FFJl7X5rrBlnUxrGOvJf1dTnc
 F8PbsoScrlT+6W0gsaIigijEXht2cfsQUVG5vLXC9OlYG5/q6g
 uP1VTZffDaZh7g4rTdjF1jEHZxPj9BSnBAr5bdfjIW6cI+q8vq
 fLhmAbTAoTTB7Tr4/uR5F9BlMuHO19r7Skn2kOKRfvqFDGDvV6
 AECIECUX9cjUPZPYFbbaRo3NgHgK5PIfoO3K20FXMCXYgkM4pU
 3bIjrGmZtwW2+PHdjGR1WjDhBnquyX+rfO+bj6FWuw7ec56bR2
 AaqPOd1/3JGRHjA6K8/orBELqvd9e4MxGI=
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

