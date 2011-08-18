Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243Ab1HRHhp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 03:37:45 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:13690 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840Ab1HRHhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 03:37:42 -0400
X-AuditID: cbfee61a-b7cf1ae00000208e-85-4e4cc1447093
Date: Thu, 18 Aug 2011 16:37:35 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH v2 1/2] MFD: MAX8997: IRQ Handling Bugfix
In-reply-to: <1313653056-27263-1-git-send-email-myungjoo.ham@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, kyungmin.park@samsung.com,
        myungjoo.ham@gmail.com
Message-id: <1313653056-27263-2-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
Content-transfer-encoding: 7BIT
References: <1313653056-27263-1-git-send-email-myungjoo.ham@samsung.com>
X-OriginalArrivalTime: 18 Aug 2011 07:38:23.0561 (UTC)
 FILETIME=[CF33DB90:01CC5D79]
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

