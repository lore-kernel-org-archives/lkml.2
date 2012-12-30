Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab2L3WIX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2012 17:08:23 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:62489 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046Ab2L3WIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2012 17:08:22 -0500
From: Rob Herring <robherring2@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Rob Herring <rob.herring@calxeda.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] rtc: pl031: add wake-up support
Date: Sun, 30 Dec 2012 16:07:48 -0600
Message-Id: <1356905268-29587-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Mark the pl031 as wake-up capable so that rtcwake and suspend test can work.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: linux-arm-kernel@lists.infradead.org
Cc: rtc-linux@googlegroups.com
Cc: linux-kernel@vger.kernel.org
---
 drivers/rtc/rtc-pl031.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/rtc/rtc-pl031.c b/drivers/rtc/rtc-pl031.c
index 08378e3..9e20958 100644
--- a/drivers/rtc/rtc-pl031.c
+++ b/drivers/rtc/rtc-pl031.c
@@ -380,6 +380,8 @@ static int pl031_probe(struct amba_device *adev, const struct amba_id *id)
 		goto out_no_irq;
 	}
 
+	device_init_wakeup(&adev->dev, 1);
+
 	return 0;
 
 out_no_irq:
-- 
1.7.10.4

