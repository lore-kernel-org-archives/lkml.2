Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab0H0PgY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 11:36:24 -0400
Received: from smtp.nokia.com ([192.100.105.134]:22640 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631Ab0H0PgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 11:36:22 -0400
From: Yuri Ershov <ext-yuri.ershov@nokia.com>
To: eric.piel@tremplin-utc.net, samu.p.onkalo@nokia.com,
        akpm@linux-foundation.org, daniel@caiaq.de
Cc: ext-yuri.kululin@nokia.com, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, ext-yuri.ershov@nokia.com
Subject: [PATCH 2/2] lis3: Set device owner
Date: Fri, 27 Aug 2010 18:33:21 +0400
Message-Id: <f7f75208147a0655eda1ac402f07e98d745fc178.1282647258.git.ext-yuri.kululin@nokia.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <ee6b20c71d49b8438ced798a9e561dbbd2991cf6.1282647258.git.ext-yuri.kululin@nokia.com>
References: <1282919601-21821-1-git-send-email-ext-yuri.ershov@nokia.com>
 <ee6b20c71d49b8438ced798a9e561dbbd2991cf6.1282647258.git.ext-yuri.kululin@nokia.com>
In-Reply-To: <ee6b20c71d49b8438ced798a9e561dbbd2991cf6.1282647258.git.ext-yuri.kululin@nokia.com>
References: <ee6b20c71d49b8438ced798a9e561dbbd2991cf6.1282647258.git.ext-yuri.kululin@nokia.com>
X-OriginalArrivalTime: 27 Aug 2010 15:35:13.0657 (UTC) FILETIME=[71170E90:01CB45FD]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set device owner for i2c part.

Signed-off-by: Yuri Kululin <ext-yuri.kululin@nokia.com>
---
 drivers/hwmon/lis3lv02d_i2c.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/hwmon/lis3lv02d_i2c.c b/drivers/hwmon/lis3lv02d_i2c.c
index b2f8bae..1a55bb3 100644
--- a/drivers/hwmon/lis3lv02d_i2c.c
+++ b/drivers/hwmon/lis3lv02d_i2c.c
@@ -129,6 +129,7 @@ static int __devinit lis3lv02d_i2c_probe(struct i2c_client *client,
 	lis3_dev.reg_ctrl = lis3_reg_ctrl;
 	lis3_dev.irq	  = client->irq;
 	lis3_dev.ac	  = lis3lv02d_axis_map;
+	lis3_dev.owner	  = THIS_MODULE;
 
 	i2c_set_clientdata(client, &lis3_dev);
 
@@ -149,6 +150,7 @@ static int __devexit lis3lv02d_i2c_remove(struct i2c_client *client)
 
 	lis3lv02d_joystick_disable();
 	lis3lv02d_remove_fs(&lis3_dev);
+	lis3_dev.owner = NULL;
 
 	regulator_bulk_free(ARRAY_SIZE(lis3_dev.regulators),
 			lis3_dev.regulators);
-- 
1.7.1.1

