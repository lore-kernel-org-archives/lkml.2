Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759490Ab2DJUtW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 16:49:22 -0400
Received: from smtp-out-106.synserver.de ([212.40.185.106]:1100 "EHLO
	smtp-out-105.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758962Ab2DJUtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 16:49:18 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 1983
From: Lars-Peter Clausen <lars@metafoo.de>
To: linux-kernel@vger.kernel.org
Cc: Lars-Peter Clausen <lars@metafoo.de>, Samuel Ortiz <sameo@linux.intel.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 3/4] mfd: Remove redundant spi driver bus initialization
Date: Tue, 10 Apr 2012 22:51:28 +0200
Message-Id: <1334091089-10138-3-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1334091089-10138-1-git-send-email-lars@metafoo.de>
References: <1334091089-10138-1-git-send-email-lars@metafoo.de>
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
-           .bus = &spi_bus_type,
    },
};
// </smpl>

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>

---
 drivers/mfd/da9052-spi.c |    1 -
 drivers/mfd/stmpe-spi.c  |    1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/mfd/da9052-spi.c b/drivers/mfd/da9052-spi.c
index 6faf149..6e09498 100644
--- a/drivers/mfd/da9052-spi.c
+++ b/drivers/mfd/da9052-spi.c
@@ -88,7 +88,6 @@ static struct spi_driver da9052_spi_driver = {
 	.id_table = da9052_spi_id,
 	.driver = {
 		.name = "da9052",
-		.bus = &spi_bus_type,
 		.owner = THIS_MODULE,
 	},
 };
diff --git a/drivers/mfd/stmpe-spi.c b/drivers/mfd/stmpe-spi.c
index b58c43c..afd4590 100644
--- a/drivers/mfd/stmpe-spi.c
+++ b/drivers/mfd/stmpe-spi.c
@@ -122,7 +122,6 @@ MODULE_DEVICE_TABLE(spi, stmpe_id);
 static struct spi_driver stmpe_spi_driver = {
 	.driver = {
 		.name	= "stmpe-spi",
-		.bus	= &spi_bus_type,
 		.owner	= THIS_MODULE,
 #ifdef CONFIG_PM
 		.pm	= &stmpe_dev_pm_ops,
-- 
1.7.9.5

