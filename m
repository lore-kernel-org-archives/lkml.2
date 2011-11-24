Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630Ab1KXP2i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 10:28:38 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:24640
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752024Ab1KXP2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 10:28:35 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bh8275dhz2dh87h2a8h668h839h)
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-FB-SS: 13,
X-FB-DOMAIN-IP-MATCH: fail
From: Lars-Peter Clausen <lars@metafoo.de>
To: <linux-kernel@vger.kernel.org>
CC: Lars-Peter Clausen <lars@metafoo.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        <linux-input@vger.kernel.org>
Subject: [PATCH 03/11] Input: Remove redundant spi driver bus initialization
Date: Thu, 24 Nov 2011 16:29:13 +0100
Message-ID: <1322148561-25138-3-git-send-email-lars@metafoo.de>
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
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Michael Hennerich <michael.hennerich@analog.com>
Cc: linux-input@vger.kernel.org
---
 drivers/input/misc/adxl34x-spi.c       |    1 -
 drivers/input/touchscreen/ad7877.c     |    1 -
 drivers/input/touchscreen/ad7879-spi.c |    1 -
 drivers/input/touchscreen/ads7846.c    |    1 -
 4 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/input/misc/adxl34x-spi.c b/drivers/input/misc/adxl34x-spi.c
index f29de22..34d401e 100644
--- a/drivers/input/misc/adxl34x-spi.c
+++ b/drivers/input/misc/adxl34x-spi.c
@@ -122,7 +122,6 @@ static SIMPLE_DEV_PM_OPS(adxl34x_spi_pm, adxl34x_spi_suspend,
 static struct spi_driver adxl34x_driver = {
 	.driver = {
 		.name = "adxl34x",
-		.bus = &spi_bus_type,
 		.owner = THIS_MODULE,
 		.pm = &adxl34x_spi_pm,
 	},
diff --git a/drivers/input/touchscreen/ad7877.c b/drivers/input/touchscreen/ad7877.c
index 2da9f18..42ae7a2 100644
--- a/drivers/input/touchscreen/ad7877.c
+++ b/drivers/input/touchscreen/ad7877.c
@@ -853,7 +853,6 @@ static SIMPLE_DEV_PM_OPS(ad7877_pm, ad7877_suspend, ad7877_resume);
 static struct spi_driver ad7877_driver = {
 	.driver = {
 		.name	= "ad7877",
-		.bus	= &spi_bus_type,
 		.owner	= THIS_MODULE,
 		.pm	= &ad7877_pm,
 	},
diff --git a/drivers/input/touchscreen/ad7879-spi.c b/drivers/input/touchscreen/ad7879-spi.c
index 8f391ff..9b2e1c2 100644
--- a/drivers/input/touchscreen/ad7879-spi.c
+++ b/drivers/input/touchscreen/ad7879-spi.c
@@ -150,7 +150,6 @@ static int __devexit ad7879_spi_remove(struct spi_device *spi)
 static struct spi_driver ad7879_spi_driver = {
 	.driver = {
 		.name	= "ad7879",
-		.bus	= &spi_bus_type,
 		.owner	= THIS_MODULE,
 		.pm	= &ad7879_pm_ops,
 	},
diff --git a/drivers/input/touchscreen/ads7846.c b/drivers/input/touchscreen/ads7846.c
index 4cedae6..23fd901 100644
--- a/drivers/input/touchscreen/ads7846.c
+++ b/drivers/input/touchscreen/ads7846.c
@@ -1426,7 +1426,6 @@ static int __devexit ads7846_remove(struct spi_device *spi)
 static struct spi_driver ads7846_driver = {
 	.driver = {
 		.name	= "ads7846",
-		.bus	= &spi_bus_type,
 		.owner	= THIS_MODULE,
 		.pm	= &ads7846_pm,
 	},
-- 
1.7.7.1


