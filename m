Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156Ab1F3Bb4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 21:31:56 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:40845 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733Ab1F3Bbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 21:31:49 -0400
X-AuditID: cbfee61a-b7c53ae000002dc1-bc-4e0bd20302c3
Date: Thu, 30 Jun 2011 10:31:45 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH 1/3] MFD: MAX8997: IRQ Handling Bugfix
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Donggeun Kim <dg77.kim@samsung.com>, myungjoo.ham@gmail.com
Message-id: <1309397507-24959-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
Content-transfer-encoding: 7BIT
X-OriginalArrivalTime: 30 Jun 2011 01:32:02.0176 (UTC)
 FILETIME=[8308F000:01CC36C5]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Required platform information is not handed to max8997-irq.c properly.
This patch enables to hand over such information to max8997-irq.c so
that max8997-irq functions properly.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/mfd/max8997.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/max8997.c b/drivers/mfd/max8997.c
index 5d1fca0..f83103b 100644
--- a/drivers/mfd/max8997.c
+++ b/drivers/mfd/max8997.c
@@ -135,10 +135,13 @@ static int max8997_i2c_probe(struct i2c_client *i2c,
 	max8997->dev = &i2c->dev;
 	max8997->i2c = i2c;
 	max8997->type = id->driver_data;
+	max8997->irq = i2c->irq;
 
 	if (!pdata)
 		goto err;
 
+	max8997->irq_base = pdata->irq_base;
+	max8997->ono = pdata->ono;
 	max8997->wakeup = pdata->wakeup;
 
 	mutex_init(&max8997->iolock);
@@ -152,6 +155,8 @@ static int max8997_i2c_probe(struct i2c_client *i2c,
 
 	pm_runtime_set_active(max8997->dev);
 
+	max8997_irq_init(max8997);
+
 	mfd_add_devices(max8997->dev, -1, max8997_devs,
 			ARRAY_SIZE(max8997_devs),
 			NULL, 0);
-- 
1.7.4.1

