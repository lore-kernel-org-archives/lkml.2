Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600Ab1JNUGq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 16:06:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54712 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933033Ab1JNUGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 16:06:36 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Enable rbtree cache for wm831x devices
Date: Fri, 14 Oct 2011 21:06:26 +0100
Message-Id: <1318622786-20189-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most useful with the regulators where we're doing a lot of read/modify/write
updates in potentially performance critical paths.  Providing some defaults
would make this slightly better but this is a win right now.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

Samuel, this depends on the regmap code in -next so I'd like to merge
it via regmap if that's OK with you?

 drivers/mfd/wm831x-core.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/wm831x-core.c b/drivers/mfd/wm831x-core.c
index e758c89..0a2b8d4 100644
--- a/drivers/mfd/wm831x-core.c
+++ b/drivers/mfd/wm831x-core.c
@@ -1602,6 +1602,8 @@ struct regmap_config wm831x_regmap_config = {
 	.reg_bits = 16,
 	.val_bits = 16,
 
+	.cache_type = REGCACHE_RBTREE,
+
 	.max_register = WM831X_DBE_CHECK_DATA,
 	.readable_reg = wm831x_reg_readable,
 	.writeable_reg = wm831x_reg_writeable,
-- 
1.7.6.3

