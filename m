Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547Ab1KXPa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 10:30:59 -0500
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:52216
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753123Ab1KXP2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 10:28:37 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh87h2a8h668h839h)
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Lars-Peter Clausen <lars@metafoo.de>
To: <linux-kernel@vger.kernel.org>
CC: Lars-Peter Clausen <lars@metafoo.de>, Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 05/11] mfd: Remove redundant spi driver bus initialization
Date: Thu, 24 Nov 2011 16:29:15 +0100
Message-ID: <1322148561-25138-5-git-send-email-lars@metafoo.de>
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
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/mc13xxx-core.c |    1 -
 drivers/mfd/tps65912-spi.c |    1 -
 drivers/mfd/wm831x-spi.c   |    1 -
 3 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c
index e9619ac..4417380 100644
--- a/drivers/mfd/mc13xxx-core.c
+++ b/drivers/mfd/mc13xxx-core.c
@@ -805,7 +805,6 @@ static struct spi_driver mc13xxx_driver = {
 	.id_table = mc13xxx_device_id,
 	.driver = {
 		.name = "mc13xxx",
-		.bus = &spi_bus_type,
 		.owner = THIS_MODULE,
 	},
 	.probe = mc13xxx_probe,
diff --git a/drivers/mfd/tps65912-spi.c b/drivers/mfd/tps65912-spi.c
index 6d71e0d..27d3302 100644
--- a/drivers/mfd/tps65912-spi.c
+++ b/drivers/mfd/tps65912-spi.c
@@ -111,7 +111,6 @@ static int __devexit tps65912_spi_remove(struct spi_device *spi)
 static struct spi_driver tps65912_spi_driver = {
 	.driver = {
 		.name = "tps65912",
-		.bus = &spi_bus_type,
 		.owner = THIS_MODULE,
 	},
 	.probe	= tps65912_spi_probe,
diff --git a/drivers/mfd/wm831x-spi.c b/drivers/mfd/wm831x-spi.c
index 8d6a9a9..37b3756 100644
--- a/drivers/mfd/wm831x-spi.c
+++ b/drivers/mfd/wm831x-spi.c
@@ -95,7 +95,6 @@ MODULE_DEVICE_TABLE(spi, wm831x_spi_id);
 static struct spi_driver wm831x_spi_driver = {
 	.driver = {
 		.name	= "wm831x",
-		.bus	= &spi_bus_type,
 		.owner	= THIS_MODULE,
 		.pm	= &wm831x_spi_pm,
 	},
-- 
1.7.7.1


