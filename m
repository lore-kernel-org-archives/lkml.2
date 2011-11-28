Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793Ab1K1Ob2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 09:31:28 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37987 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753464Ab1K1Ob0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 09:31:26 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] ARM: S3C64XX: Improve logging of unknown Cragganmore module types
Date: Mon, 28 Nov 2011 14:31:23 +0000
Message-Id: <1322490684-18898-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As our ID table is populated with hexidecimal values it makes sense to log
unknown module IDs in hexidecimal. It's also helpful to display board
revisions as 1 based rather than 0 based as that's the numbering system
used for the hardware (and what we do when announcing known modules).

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 arch/arm/mach-s3c64xx/mach-crag6410-module.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-s3c64xx/mach-crag6410-module.c b/arch/arm/mach-s3c64xx/mach-crag6410-module.c
index 8e19ce6..bb87348 100644
--- a/arch/arm/mach-s3c64xx/mach-crag6410-module.c
+++ b/arch/arm/mach-s3c64xx/mach-crag6410-module.c
@@ -217,8 +217,8 @@ static __devinit int wlf_gf_module_probe(struct i2c_client *i2c,
 		spi_register_board_info(gf_mods[i].spi_devs,
 					gf_mods[i].num_spi_devs);
 	} else {
-		dev_warn(&i2c->dev, "Unknown module ID %d revision %d\n",
-			 id, rev);
+		dev_warn(&i2c->dev, "Unknown module ID 0x%x revision %d\n",
+			 id, rev + 1);
 	}
 
 	return 0;
-- 
1.7.7.3

