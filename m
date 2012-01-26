Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab2AZShu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 13:37:50 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:45141 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753456Ab2AZSht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 13:37:49 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: linux-kernel@vger.kernel.org
Cc: Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH] leds-lp5523: trival compiler warning fixes
Date: Thu, 26 Jan 2012 19:37:41 +0100
Message-Id: <1327603061-25388-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1327603069;c74c0e2d;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial compiler warning fixes (for -Wuninitialized).

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/leds/leds-lp5523.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index 73e791a..6d38e0a 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -193,7 +193,7 @@ static int lp5523_configure(struct i2c_client *client)
 {
 	struct lp5523_chip *chip = i2c_get_clientdata(client);
 	int ret = 0;
-	u8 status;
+	u8 status = 0;
 
 	/* one pattern per engine setting led mux start and stop addresses */
 	u8 pattern[][LP5523_PROGRAM_LENGTH] =  {
@@ -442,6 +442,8 @@ static ssize_t lp5523_selftest(struct device *dev,
 	int led = 0;
 	u8 status, adc, vdd;
 
+	adc = vdd = 0;
+
 	mutex_lock(&chip->lock);
 
 	ret = lp5523_read(chip->client, LP5523_REG_STATUS, &status);
-- 
1.7.7.3

