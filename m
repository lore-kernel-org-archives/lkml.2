Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672Ab2DEDtV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 23:49:21 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44848 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab2DEDtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 23:49:20 -0400
Message-ID: <1333597752.10597.1.camel@phoenix>
Subject: [PATCH] mfd: Silence uninitialized variable warning for wm8994-core
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Date: Thu, 05 Apr 2012 11:49:12 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix below build warning:
  CC      drivers/mfd/wm8994-core.o
drivers/mfd/wm8994-core.c: In function 'wm8994_i2c_probe':
drivers/mfd/wm8994-core.c:582:7: warning: 'patch_regs' may be used uninitialized in this function [-Wuninitialized]
drivers/mfd/wm8994-core.c:393:14: note: 'patch_regs' was declared here

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/wm8994-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index 9d7ca1e..bd02202 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -390,7 +390,7 @@ static __devinit int wm8994_device_init(struct wm8994 *wm8994, int irq)
 	struct regmap_config *regmap_config;
 	const struct reg_default *regmap_patch = NULL;
 	const char *devname;
-	int ret, i, patch_regs;
+	int ret, i, patch_regs = 0;
 	int pulls = 0;
 
 	dev_set_drvdata(wm8994->dev, wm8994);
-- 
1.7.5.4



