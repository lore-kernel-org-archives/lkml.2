Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937Ab1KXP2j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 10:28:39 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:1792 "EHLO
	VA3EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752855Ab1KXP2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 10:28:35 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bh8275dhz2dh87h2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Lars-Peter Clausen <lars@metafoo.de>
To: <linux-kernel@vger.kernel.org>
CC: Lars-Peter Clausen <lars@metafoo.de>, Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        <lm-sensors@lm-sensors.org>
Subject: [PATCH 04/11] hwmon: Remove redundant spi driver bus initialization
Date: Thu, 24 Nov 2011 16:29:14 +0100
Message-ID: <1322148561-25138-4-git-send-email-lars@metafoo.de>
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
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: lm-sensors@lm-sensors.org
---
 drivers/hwmon/ad7314.c  |    1 -
 drivers/hwmon/ads7871.c |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/ad7314.c b/drivers/hwmon/ad7314.c
index 318e38e..5d760f3 100644
--- a/drivers/hwmon/ad7314.c
+++ b/drivers/hwmon/ad7314.c
@@ -160,7 +160,6 @@ MODULE_DEVICE_TABLE(spi, ad7314_id);
 static struct spi_driver ad7314_driver = {
 	.driver = {
 		.name = "ad7314",
-		.bus = &spi_bus_type,
 		.owner = THIS_MODULE,
 	},
 	.probe = ad7314_probe,
diff --git a/drivers/hwmon/ads7871.c b/drivers/hwmon/ads7871.c
index 5231934..04450f8 100644
--- a/drivers/hwmon/ads7871.c
+++ b/drivers/hwmon/ads7871.c
@@ -227,7 +227,6 @@ static int __devexit ads7871_remove(struct spi_device *spi)
 static struct spi_driver ads7871_driver = {
 	.driver = {
 		.name = DEVICE_NAME,
-		.bus = &spi_bus_type,
 		.owner = THIS_MODULE,
 	},
 
-- 
1.7.7.1


