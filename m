Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757992Ab1JEHzI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 03:55:08 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57622 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757895Ab1JEHzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 03:55:06 -0400
Subject: [PATCH] leds: leds-lm3530: Add __devexit_p at necessary place
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 Oct 2011 15:54:56 +0800
Message-ID: <1317801296.12133.0.camel@phoenix>
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

We have __devexit annotation for lm3530_remove(), thus add __devexit_p at
necessary place.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/leds/leds-lm3530.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/leds/leds-lm3530.c b/drivers/leds/leds-lm3530.c
index 15c1733..0630e4f 100644
--- a/drivers/leds/leds-lm3530.c
+++ b/drivers/leds/leds-lm3530.c
@@ -449,7 +449,7 @@ MODULE_DEVICE_TABLE(i2c, lm3530_id);
 
 static struct i2c_driver lm3530_i2c_driver = {
 	.probe = lm3530_probe,
-	.remove = lm3530_remove,
+	.remove = __devexit_p(lm3530_remove),
 	.id_table = lm3530_id,
 	.driver = {
 		.name = LM3530_NAME,
-- 
1.7.4.1



