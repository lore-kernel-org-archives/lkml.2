Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757027Ab2D3W1c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 18:27:32 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45536 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756757Ab2D3W1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 18:27:31 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: Devices using format_write don't support bulk operations
Date: Mon, 30 Apr 2012 23:27:26 +0100
Message-Id: <1335824846-22136-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set the use_single_rw flag for devices that use format_write() since
format_write() doesn't support any form of block operation.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 0a05a70..fcd69ff 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -341,6 +341,9 @@ struct regmap *regmap_init(struct device *dev,
 		break;
 	}
 
+	if (map->format.format_write)
+		map->use_single_rw = true;
+
 	if (!map->format.format_write &&
 	    !(map->format.format_reg && map->format.format_val))
 		goto err_map;
-- 
1.7.10

