Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab2AZSgF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 13:36:05 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:45072 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752067Ab2AZSgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 13:36:04 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: linux-kernel@vger.kernel.org
Cc: Richard Purdie <rpurdie@rpsys.net>, Jiri Kosina <trivial@kernel.org>
Subject: [PATCH] trivial compiler warning fix
Date: Thu, 26 Jan 2012 19:35:54 +0100
Message-Id: <1327602954-25315-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1327602964;207b2ba9;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix for some -Wuninitialized compiler warnings.
---
 drivers/leds/leds-lp5521.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index d62a798..21301f6 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -194,7 +194,7 @@ static int lp5521_load_program(struct lp5521_engine *eng, const u8 *pattern)
 	struct i2c_client *client = chip->client;
 	int ret;
 	int addr;
-	u8 mode;
+	u8 mode = 0;
 
 	/* move current engine to direct mode and remember the state */
 	ret = lp5521_set_engine_mode(eng, LP5521_CMD_DIRECT);
@@ -646,7 +646,7 @@ static int __devinit lp5521_probe(struct i2c_client *client,
 	struct lp5521_chip		*chip;
 	struct lp5521_platform_data	*pdata;
 	int ret, i, led;
-	u8 buf;
+	u8 buf = 0;
 
 	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
 	if (!chip)
-- 
1.7.7.3

