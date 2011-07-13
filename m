Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089Ab1GMNHL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 09:07:11 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45433 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833Ab1GMNHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 09:07:09 -0400
Subject: [PATCH] Input: cy8ctmg110_ts - set reset_pin and irq_pin from
 platform data
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Samuli Konttila <samuli.konttila@aavamobile.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Alan Cox <alan@linux.intel.com>, linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Jul 2011 21:06:59 +0800
Message-ID: <1310562419.5753.2.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The implementation in cy8ctmg110_probe() does not properly set reset_pin
and irq_pin from platform data. Let's fix it.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
Current implementation returns -ENODEV if no pdata available.
But it does not use the information from pdata.
I think currently the driver does not work because both ts->reset_pin and ts->irq_pin are 0, then gpio_request with ts->irq_pin will fail.

Just found this bug while reading the code.
I don't have this hardware. I appreciate if someone can test it.

Axel

 drivers/input/touchscreen/cy8ctmg110_ts.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/input/touchscreen/cy8ctmg110_ts.c b/drivers/input/touchscreen/cy8ctmg110_ts.c
index d7afa20..cd60b3c 100644
--- a/drivers/input/touchscreen/cy8ctmg110_ts.c
+++ b/drivers/input/touchscreen/cy8ctmg110_ts.c
@@ -193,6 +193,8 @@ static int __devinit cy8ctmg110_probe(struct i2c_client *client,
 
 	ts->client = client;
 	ts->input = input_dev;
+	ts->reset_pin = pdata->reset_pin;
+	ts->irq_pin = pdata->irq_pin;
 
 	snprintf(ts->phys, sizeof(ts->phys),
 		 "%s/input0", dev_name(&client->dev));
-- 
1.7.4.1



