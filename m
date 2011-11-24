Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868Ab1KXPaN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 10:30:13 -0500
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:51228
	"EHLO VA3EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754099Ab1KXP2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 10:28:46 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275ch8275dhz2dh87h2a8h668h839h)
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Lars-Peter Clausen <lars@metafoo.de>
To: <linux-kernel@vger.kernel.org>
CC: Lars-Peter Clausen <lars@metafoo.de>, Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 08/11] blacklight: Remove redundant spi driver bus initialization
Date: Thu, 24 Nov 2011 16:29:18 +0100
Message-ID: <1322148561-25138-8-git-send-email-lars@metafoo.de>
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
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/video/backlight/ams369fg06.c |    1 -
 drivers/video/backlight/ld9040.c     |    1 -
 drivers/video/backlight/ltv350qv.c   |    1 -
 drivers/video/backlight/s6e63m0.c    |    1 -
 4 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/video/backlight/ams369fg06.c b/drivers/video/backlight/ams369fg06.c
index 7838a23..901024b 100644
--- a/drivers/video/backlight/ams369fg06.c
+++ b/drivers/video/backlight/ams369fg06.c
@@ -619,7 +619,6 @@ static void ams369fg06_shutdown(struct spi_device *spi)
 static struct spi_driver ams369fg06_driver = {
 	.driver = {
 		.name	= "ams369fg06",
-		.bus	= &spi_bus_type,
 		.owner	= THIS_MODULE,
 	},
 	.probe		= ams369fg06_probe,
diff --git a/drivers/video/backlight/ld9040.c b/drivers/video/backlight/ld9040.c
index da9a5ce..158ba52 100644
--- a/drivers/video/backlight/ld9040.c
+++ b/drivers/video/backlight/ld9040.c
@@ -799,7 +799,6 @@ static void ld9040_shutdown(struct spi_device *spi)
 static struct spi_driver ld9040_driver = {
 	.driver = {
 		.name	= "ld9040",
-		.bus	= &spi_bus_type,
 		.owner	= THIS_MODULE,
 	},
 	.probe		= ld9040_probe,
diff --git a/drivers/video/backlight/ltv350qv.c b/drivers/video/backlight/ltv350qv.c
index cca43c0..707e66f 100644
--- a/drivers/video/backlight/ltv350qv.c
+++ b/drivers/video/backlight/ltv350qv.c
@@ -310,7 +310,6 @@ static void ltv350qv_shutdown(struct spi_device *spi)
 static struct spi_driver ltv350qv_driver = {
 	.driver = {
 		.name		= "ltv350qv",
-		.bus		= &spi_bus_type,
 		.owner		= THIS_MODULE,
 	},
 
diff --git a/drivers/video/backlight/s6e63m0.c b/drivers/video/backlight/s6e63m0.c
index e132157..6fb9187 100644
--- a/drivers/video/backlight/s6e63m0.c
+++ b/drivers/video/backlight/s6e63m0.c
@@ -899,7 +899,6 @@ static void s6e63m0_shutdown(struct spi_device *spi)
 static struct spi_driver s6e63m0_driver = {
 	.driver = {
 		.name	= "s6e63m0",
-		.bus	= &spi_bus_type,
 		.owner	= THIS_MODULE,
 	},
 	.probe		= s6e63m0_probe,
-- 
1.7.7.1


