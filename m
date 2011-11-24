Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558Ab1KXPaz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 10:30:55 -0500
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:51099
	"EHLO VA3EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752796Ab1KXP2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 10:28:37 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bh8275dhz2dh87h2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Lars-Peter Clausen <lars@metafoo.de>
To: <linux-kernel@vger.kernel.org>
CC: Lars-Peter Clausen <lars@metafoo.de>,
        David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        <linux-mtd@lists.infradead.org>
Subject: [PATCH 06/11] mtd: Remove redundant spi driver bus initialization
Date: Thu, 24 Nov 2011 16:29:16 +0100
Message-ID: <1322148561-25138-6-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.7.1
In-Reply-To: <1322148561-25138-1-git-send-email-lars@metafoo.de>
References: <1322148561-25138-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In ancient times it was necessary to manually initialize the bus field of an
spi_driver to spi_bus_type. These days this is done in spi_driver_register(),
so we can drop the manual assignment.

The patch was generated using the following coccinelle semantic patch:
// <smpl>
@@
identifier _driver;
@@
struct spi_driver _driver = {
	.driver = {
-		.bus = &spi_bus_type,
	},
};
// </smpl>

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: linux-mtd@lists.infradead.org
---
 drivers/mtd/devices/m25p80.c        |    1 -
 drivers/mtd/devices/mtd_dataflash.c |    1 -
 drivers/mtd/devices/sst25l.c        |    1 -
 3 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
index 884904d..7c60ddd 100644
--- a/drivers/mtd/devices/m25p80.c
+++ b/drivers/mtd/devices/m25p80.c
@@ -992,7 +992,6 @@ static int __devexit m25p_remove(struct spi_device *spi)
 static struct spi_driver m25p80_driver = {
 	.driver = {
 		.name	= "m25p80",
-		.bus	= &spi_bus_type,
 		.owner	= THIS_MODULE,
 	},
 	.id_table	= m25p_ids,
diff --git a/drivers/mtd/devices/mtd_dataflash.c b/drivers/mtd/devices/mtd_dataflash.c
index d75c7af..236057e 100644
--- a/drivers/mtd/devices/mtd_dataflash.c
+++ b/drivers/mtd/devices/mtd_dataflash.c
@@ -936,7 +936,6 @@ static int __devexit dataflash_remove(struct spi_device *spi)
 static struct spi_driver dataflash_driver = {
 	.driver = {
 		.name		= "mtd_dataflash",
-		.bus		= &spi_bus_type,
 		.owner		= THIS_MODULE,
 		.of_match_table = dataflash_dt_ids,
 	},
diff --git a/drivers/mtd/devices/sst25l.c b/drivers/mtd/devices/sst25l.c
index d38ef3b..e45f62e 100644
--- a/drivers/mtd/devices/sst25l.c
+++ b/drivers/mtd/devices/sst25l.c
@@ -444,7 +444,6 @@ static int __devexit sst25l_remove(struct spi_device *spi)
 static struct spi_driver sst25l_driver = {
 	.driver = {
 		.name	= "sst25l",
-		.bus	= &spi_bus_type,
 		.owner	= THIS_MODULE,
 	},
 	.probe		= sst25l_probe,
-- 
1.7.7.1


