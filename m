Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526Ab2DLF2b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 01:28:31 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47375 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756194Ab2DLF2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 01:28:30 -0400
Message-ID: <1334208502.15182.0.camel@phoenix>
Subject: regulator: core: Don't dereference config->dev before NULL checking
 for config
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Thu, 12 Apr 2012 13:28:22 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/core.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 1bd71a8..bf46034 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2853,7 +2853,7 @@ regulator_register(const struct regulator_desc *regulator_desc,
 	const struct regulator_init_data *init_data;
 	static atomic_t regulator_no = ATOMIC_INIT(0);
 	struct regulator_dev *rdev;
-	struct device *dev = config->dev;
+	struct device *dev;
 	int ret, i;
 	const char *supply = NULL;
 
@@ -2883,6 +2883,7 @@ regulator_register(const struct regulator_desc *regulator_desc,
 		return ERR_PTR(-EINVAL);
 	}
 
+	dev = config->dev;
 	init_data = config->init_data;
 
 	rdev = kzalloc(sizeof(struct regulator_dev), GFP_KERNEL);
-- 
1.7.5.4



