Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab1KXP2t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 10:28:49 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:27268
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753985Ab1KXP2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 10:28:45 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bh8275dhz2dh87h2a8h668h839h)
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Lars-Peter Clausen <lars@metafoo.de>
To: <linux-kernel@vger.kernel.org>
CC: Lars-Peter Clausen <lars@metafoo.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        <linux-fbdev@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: [PATCH 09/11] video: Remove redundant spi driver bus initialization
Date: Thu, 24 Nov 2011 16:29:19 +0100
Message-ID: <1322148561-25138-9-git-send-email-lars@metafoo.de>
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
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-fbdev@vger.kernel.org
Cc: linux-omap@vger.kernel.org
---
 drivers/video/omap/lcd_mipid.c                     |    1 -
 drivers/video/omap2/displays/panel-acx565akm.c     |    1 -
 drivers/video/omap2/displays/panel-n8x0.c          |    1 -
 .../omap2/displays/panel-nec-nl8048hl11-01b.c      |    1 -
 .../video/omap2/displays/panel-tpo-td043mtea1.c    |    1 -
 5 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/video/omap/lcd_mipid.c b/drivers/video/omap/lcd_mipid.c
index eb381db..8d546dd 100644
--- a/drivers/video/omap/lcd_mipid.c
+++ b/drivers/video/omap/lcd_mipid.c
@@ -603,7 +603,6 @@ static int mipid_spi_remove(struct spi_device *spi)
 static struct spi_driver mipid_spi_driver = {
 	.driver = {
 		.name	= MIPID_MODULE_NAME,
-		.bus	= &spi_bus_type,
 		.owner	= THIS_MODULE,
 	},
 	.probe	= mipid_spi_probe,
diff --git a/drivers/video/omap2/displays/panel-acx565akm.c b/drivers/video/omap2/displays/panel-acx565akm.c
index dbd59b8..51a87e1 100644
--- a/drivers/video/omap2/displays/panel-acx565akm.c
+++ b/drivers/video/omap2/displays/panel-acx565akm.c
@@ -803,7 +803,6 @@ static int acx565akm_spi_remove(struct spi_device *spi)
 static struct spi_driver acx565akm_spi_driver = {
 	.driver = {
 		.name	= "acx565akm",
-		.bus	= &spi_bus_type,
 		.owner	= THIS_MODULE,
 	},
 	.probe	= acx565akm_spi_probe,
diff --git a/drivers/video/omap2/displays/panel-n8x0.c b/drivers/video/omap2/displays/panel-n8x0.c
index 150e8ba..dc9408d 100644
--- a/drivers/video/omap2/displays/panel-n8x0.c
+++ b/drivers/video/omap2/displays/panel-n8x0.c
@@ -708,7 +708,6 @@ static int mipid_spi_remove(struct spi_device *spi)
 static struct spi_driver mipid_spi_driver = {
 	.driver = {
 		.name	= "lcd_mipid",
-		.bus	= &spi_bus_type,
 		.owner	= THIS_MODULE,
 	},
 	.probe	= mipid_spi_probe,
diff --git a/drivers/video/omap2/displays/panel-nec-nl8048hl11-01b.c b/drivers/video/omap2/displays/panel-nec-nl8048hl11-01b.c
index 2ba9d0c..8365e77 100644
--- a/drivers/video/omap2/displays/panel-nec-nl8048hl11-01b.c
+++ b/drivers/video/omap2/displays/panel-nec-nl8048hl11-01b.c
@@ -303,7 +303,6 @@ static struct spi_driver nec_8048_spi_driver = {
 	.resume		= nec_8048_spi_resume,
 	.driver		= {
 		.name	= "nec_8048_spi",
-		.bus	= &spi_bus_type,
 		.owner	= THIS_MODULE,
 	},
 };
diff --git a/drivers/video/omap2/displays/panel-tpo-td043mtea1.c b/drivers/video/omap2/displays/panel-tpo-td043mtea1.c
index 2462b9e..e6649aa 100644
--- a/drivers/video/omap2/displays/panel-tpo-td043mtea1.c
+++ b/drivers/video/omap2/displays/panel-tpo-td043mtea1.c
@@ -512,7 +512,6 @@ static int __devexit tpo_td043_spi_remove(struct spi_device *spi)
 static struct spi_driver tpo_td043_spi_driver = {
 	.driver = {
 		.name	= "tpo_td043mtea1_panel_spi",
-		.bus	= &spi_bus_type,
 		.owner	= THIS_MODULE,
 	},
 	.probe	= tpo_td043_spi_probe,
-- 
1.7.7.1


