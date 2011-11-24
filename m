Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab1KXP2h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 10:28:37 -0500
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:45676
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752796Ab1KXP2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 10:28:35 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bh8275dhz2dh87h2a8h668h839h)
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Lars-Peter Clausen <lars@metafoo.de>
To: <linux-kernel@vger.kernel.org>
CC: Lars-Peter Clausen <lars@metafoo.de>, John Stultz <john.stultz@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>, <rtc-linux@googlegroups.com>
Subject: [PATCH 01/11] RTC: Remove redundant spi driver bus initialization
Date: Thu, 24 Nov 2011 16:29:11 +0100
Message-ID: <1322148561-25138-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.7.1
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
Cc: John Stultz <john.stultz@linaro.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com
---
 drivers/rtc/rtc-m41t93.c  |    1 -
 drivers/rtc/rtc-m41t94.c  |    1 -
 drivers/rtc/rtc-max6902.c |    1 -
 drivers/rtc/rtc-pcf2123.c |    1 -
 drivers/rtc/rtc-rs5c348.c |    1 -
 5 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-m41t93.c b/drivers/rtc/rtc-m41t93.c
index 7317d3b..ef71132 100644
--- a/drivers/rtc/rtc-m41t93.c
+++ b/drivers/rtc/rtc-m41t93.c
@@ -200,7 +200,6 @@ static int __devexit m41t93_remove(struct spi_device *spi)
 static struct spi_driver m41t93_driver = {
 	.driver = {
 		.name	= "rtc-m41t93",
-		.bus	= &spi_bus_type,
 		.owner	= THIS_MODULE,
 	},
 	.probe	= m41t93_probe,
diff --git a/drivers/rtc/rtc-m41t94.c b/drivers/rtc/rtc-m41t94.c
index e259ed7..2a4721f 100644
--- a/drivers/rtc/rtc-m41t94.c
+++ b/drivers/rtc/rtc-m41t94.c
@@ -147,7 +147,6 @@ static int __devexit m41t94_remove(struct spi_device *spi)
 static struct spi_driver m41t94_driver = {
 	.driver = {
 		.name	= "rtc-m41t94",
-		.bus	= &spi_bus_type,
 		.owner	= THIS_MODULE,
 	},
 	.probe	= m41t94_probe,
diff --git a/drivers/rtc/rtc-max6902.c b/drivers/rtc/rtc-max6902.c
index 0ec3f58..1f6b3cc 100644
--- a/drivers/rtc/rtc-max6902.c
+++ b/drivers/rtc/rtc-max6902.c
@@ -154,7 +154,6 @@ static int __devexit max6902_remove(struct spi_device *spi)
 static struct spi_driver max6902_driver = {
 	.driver = {
 		.name	= "rtc-max6902",
-		.bus	= &spi_bus_type,
 		.owner	= THIS_MODULE,
 	},
 	.probe	= max6902_probe,
diff --git a/drivers/rtc/rtc-pcf2123.c b/drivers/rtc/rtc-pcf2123.c
index 2ee3bbf..b46c400 100644
--- a/drivers/rtc/rtc-pcf2123.c
+++ b/drivers/rtc/rtc-pcf2123.c
@@ -340,7 +340,6 @@ static int __devexit pcf2123_remove(struct spi_device *spi)
 static struct spi_driver pcf2123_driver = {
 	.driver	= {
 			.name	= "rtc-pcf2123",
-			.bus	= &spi_bus_type,
 			.owner	= THIS_MODULE,
 	},
 	.probe	= pcf2123_probe,
diff --git a/drivers/rtc/rtc-rs5c348.c b/drivers/rtc/rtc-rs5c348.c
index 971bc8e..ce2ca85 100644
--- a/drivers/rtc/rtc-rs5c348.c
+++ b/drivers/rtc/rtc-rs5c348.c
@@ -229,7 +229,6 @@ static int __devexit rs5c348_remove(struct spi_device *spi)
 static struct spi_driver rs5c348_driver = {
 	.driver = {
 		.name	= "rtc-rs5c348",
-		.bus	= &spi_bus_type,
 		.owner	= THIS_MODULE,
 	},
 	.probe	= rs5c348_probe,
-- 
1.7.7.1


