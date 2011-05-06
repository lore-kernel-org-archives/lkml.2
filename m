Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181Ab1EFJ31 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 05:29:27 -0400
Received: from dakia2.marvell.com ([65.219.4.35]:50641 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755714Ab1EFJ3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 05:29:13 -0400
X-ASG-Debug-ID: 1304674153-082dceb80001-xx1T2L
X-Barracuda-Envelope-From: haojian.zhuang@marvell.com
From: Haojian Zhuang <haojian.zhuang@marvell.com>
To: sameo@linux.intel.com, haojian.zhuang@gmail.com,
        linux-kernel@vger.kernel.org, lrg@slimlogic.co.uk,
        broonie@opensource.wolfsonmicro.com, a.zummo@towertech.it,
        khali@linux-fr.org, ben-linux@fluff.org
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
X-ASG-Orig-Subj: [PATCH 6/6] mfd: max8925: remove checking on regulator[0]
Subject: [PATCH 6/6] mfd: max8925: remove checking on regulator[0]
Date: Fri,  6 May 2011 17:21:25 +0800
X-ASG-Orig-Subj: [PATCH 6/6] mfd: max8925: remove checking on regulator[0]
Message-Id: <1304673685-21324-6-git-send-email-haojian.zhuang@marvell.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1304673685-21324-5-git-send-email-haojian.zhuang@marvell.com>
References: <2011050601>
 <1304673685-21324-1-git-send-email-haojian.zhuang@marvell.com>
 <1304673685-21324-2-git-send-email-haojian.zhuang@marvell.com>
 <1304673685-21324-3-git-send-email-haojian.zhuang@marvell.com>
 <1304673685-21324-4-git-send-email-haojian.zhuang@marvell.com>
 <1304673685-21324-5-git-send-email-haojian.zhuang@marvell.com>
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1304674153
X-Barracuda-URL: http://10.68.76.222:80/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: -1002.00
X-Barracuda-Spam-Status: No, SCORE=-1002.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since regulator[0] is always checking in mfd driver, it results in
registration failure without regulator[0].

Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/mfd/max8925-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/max8925-core.c b/drivers/mfd/max8925-core.c
index 58cc5fd..e1e59c9 100644
--- a/drivers/mfd/max8925-core.c
+++ b/drivers/mfd/max8925-core.c
@@ -627,7 +627,7 @@ int __devinit max8925_device_init(struct max8925_chip *chip,
 		goto out_dev;
 	}
 
-	if (pdata && pdata->regulator[0]) {
+	if (pdata) {
 		ret = mfd_add_devices(chip->dev, 0, &regulator_devs[0],
 				      ARRAY_SIZE(regulator_devs),
 				      &regulator_resources[0], 0);
-- 
1.5.6.5

