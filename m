Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759440Ab2DJUtT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 16:49:19 -0400
Received: from smtp-out-106.synserver.de ([212.40.185.106]:1027 "EHLO
	smtp-out-105.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755324Ab2DJUtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 16:49:18 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 1983
From: Lars-Peter Clausen <lars@metafoo.de>
To: linux-kernel@vger.kernel.org
Cc: Lars-Peter Clausen <lars@metafoo.de>, Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/4] blacklight: Remove redundant spi driver bus initialization
Date: Tue, 10 Apr 2012 22:51:26 +0200
Message-Id: <1334091089-10138-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In ancient times it was necessary to manually initialize the bus field of an
spi_driver to spi_bus_type. These days this is done in spi_driver_register() so
we can drop the manual assignment.

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
 4 files changed, 4 deletions(-)

diff --git a/drivers/video/backlight/ams369fg06.c b/drivers/video/backlight/ams369fg06.c
index 7bdadc7..d2494c5 100644
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
index efd352b..2ea06a5f 100644
--- a/drivers/video/backlight/ld9040.c
+++ b/drivers/video/backlight/ld9040.c
@@ -846,7 +846,6 @@ static void ld9040_shutdown(struct spi_device *spi)
 static struct spi_driver ld9040_driver = {
 	.driver = {
 		.name	= "ld9040",
-		.bus	= &spi_bus_type,
 		.owner	= THIS_MODULE,
 	},
 	.probe		= ld9040_probe,
diff --git a/drivers/video/backlight/ltv350qv.c b/drivers/video/backlight/ltv350qv.c
index 333949f..d23922f 100644
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
index e264f55..3ed05c7 100644
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
1.7.9.5

