Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab2HEQd0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 12:33:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45546 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab2HEQdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 12:33:23 -0400
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com,
        rpurdie@rpsys.net, bryan.wu@canonical.com,
        linux-kernel@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Subject: [PATCH 4/5] mfd: avoid to return failure in 88pm860x
Date: Mon,  6 Aug 2012 00:32:52 +0800
Message-Id: <1344184373-9670-5-git-send-email-haojian.zhuang@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344184373-9670-1-git-send-email-haojian.zhuang@gmail.com>
References: <1344184373-9670-1-git-send-email-haojian.zhuang@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While touch field of 88pm860x platform_data isn't assigned, probe
function returns failure. Now update code to only return without
failure since touch field isn't always used in each usage scenario.

Signed-off-by: Haojian Zhuang <haojian.zhuang@gmail.com>
---
 drivers/mfd/88pm860x-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/88pm860x-core.c b/drivers/mfd/88pm860x-core.c
index bde9231..60faf9b 100644
--- a/drivers/mfd/88pm860x-core.c
+++ b/drivers/mfd/88pm860x-core.c
@@ -551,7 +551,7 @@ static int __devinit device_gpadc_init(struct pm860x_chip *chip,
 	/* initialize GPADC without activating it */
 
 	if (!pdata || !pdata->touch)
-		return -EINVAL;
+		return 0;
 
 	/* set GPADC MISC1 register */
 	data = 0;
-- 
1.7.9.5

