Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759Ab1LABsC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 20:48:02 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47354 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021Ab1LABsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 20:48:01 -0500
Message-ID: <1322704074.11560.3.camel@phoenix>
Subject: [PATCH 1/4] mfd: aat2870-core: Use gpio_request_one
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jin Park <jinyoungp@nvidia.com>, Samuel Ortiz <sameo@linux.intel.com>
Date: Thu, 01 Dec 2011 09:47:54 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use gpio_request_one() instead of multiple gpiolib calls.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/aat2870-core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/aat2870-core.c b/drivers/mfd/aat2870-core.c
index 02c4201..7620617 100644
--- a/drivers/mfd/aat2870-core.c
+++ b/drivers/mfd/aat2870-core.c
@@ -407,13 +407,13 @@ static int aat2870_i2c_probe(struct i2c_client *client,
 		aat2870->init(aat2870);
 
 	if (aat2870->en_pin >= 0) {
-		ret = gpio_request(aat2870->en_pin, "aat2870-en");
+		ret = gpio_request_one(aat2870->en_pin, GPIOF_OUT_INIT_HIGH,
+				       "aat2870-en");
 		if (ret < 0) {
 			dev_err(&client->dev,
 				"Failed to request GPIO %d\n", aat2870->en_pin);
 			goto out_kfree;
 		}
-		gpio_direction_output(aat2870->en_pin, 1);
 	}
 
 	aat2870_enable(aat2870);
-- 
1.7.5.4



