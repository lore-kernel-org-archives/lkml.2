Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092Ab2HUQbr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 12:31:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48512 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756147Ab2HUQbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 12:31:44 -0400
From: Devendra Naga <develkernel412222@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Zhang Rui <rui.zhang@intel.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        linux-kernel@vger.kernel.org
Cc: Devendra Naga <develkernel412222@gmail.com>
Subject: [PATCH] thermal: solve compilation errors in rcar_thermal
Date: Tue, 21 Aug 2012 22:01:36 +0530
Message-Id: <1345566696-21164-1-git-send-email-develkernel412222@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

following were the errors reported

drivers/thermal/rcar_thermal.c: In function ‘rcar_thermal_probe’:
drivers/thermal/rcar_thermal.c:214:10: warning: passing argument 3 of ‘thermal_zone_device_register’ makes integer from pointer without a cast [enabled by default]
include/linux/thermal.h:166:29: note: expected ‘int’ but argument is of type ‘struct rcar_thermal_priv *’
drivers/thermal/rcar_thermal.c:214:10: error: too few arguments to function ‘thermal_zone_device_register’
include/linux/thermal.h:166:29: note: declared here
make[1]: *** [drivers/thermal/rcar_thermal.o] Error 1
make: *** [drivers/thermal/rcar_thermal.o] Error 2

with gcc version 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5)

Signed-off-by: Devendra Naga <develkernel412222@gmail.com>
---
 drivers/thermal/rcar_thermal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/rcar_thermal.c b/drivers/thermal/rcar_thermal.c
index d445271..f7a1b57 100644
--- a/drivers/thermal/rcar_thermal.c
+++ b/drivers/thermal/rcar_thermal.c
@@ -210,7 +210,7 @@ static int rcar_thermal_probe(struct platform_device *pdev)
 		goto error_free_priv;
 	}
 
-	zone = thermal_zone_device_register("rcar_thermal", 0, priv,
+	zone = thermal_zone_device_register("rcar_thermal", 0, 0, priv,
 					    &rcar_thermal_zone_ops, 0, 0);
 	if (IS_ERR(zone)) {
 		dev_err(&pdev->dev, "thermal zone device is NULL\n");
-- 
1.7.9.5

