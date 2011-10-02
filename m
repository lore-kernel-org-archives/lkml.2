Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908Ab1JBBSc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 21:18:32 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:57608 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab1JBBSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 21:18:24 -0400
Subject: [PATCH] ASoC: kirkwood-i2s: Add __devexit_p at necessary place
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 02 Oct 2011 09:18:17 +0800
Message-ID: <1317518297.8024.2.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the comments in include/linux/init.h:

"Pointers to __devexit functions must use __devexit_p(function_name), the
wrapper will insert either the function_name or NULL, depending on the config
options."

We have __devexit annotation for kirkwood_i2s_dev_remove(), thus add __devexit_p
at necessary place.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/kirkwood/kirkwood-i2s.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/kirkwood/kirkwood-i2s.c b/sound/soc/kirkwood/kirkwood-i2s.c
index d0bcf3f..715e841 100644
--- a/sound/soc/kirkwood/kirkwood-i2s.c
+++ b/sound/soc/kirkwood/kirkwood-i2s.c
@@ -476,7 +476,7 @@ static __devexit int kirkwood_i2s_dev_remove(struct platform_device *pdev)
 
 static struct platform_driver kirkwood_i2s_driver = {
 	.probe  = kirkwood_i2s_dev_probe,
-	.remove = kirkwood_i2s_dev_remove,
+	.remove = __devexit_p(kirkwood_i2s_dev_remove),
 	.driver = {
 		.name = DRV_NAME,
 		.owner = THIS_MODULE,
-- 
1.7.4.1



