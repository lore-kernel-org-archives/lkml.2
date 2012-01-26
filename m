Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab2AZSkx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 13:40:53 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:42552 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753506Ab2AZSkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 13:40:49 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: linux-kernel@vger.kernel.org
Cc: Richard Purdie <rpurdie@rpsys.net>, stable <stable@kernel.org>
Subject: [PATCH] fix return value from __devinit
Date: Thu, 26 Jan 2012 19:40:39 +0100
Message-Id: <1327603239-25507-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1327603249;915498ea;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix return value from __devinit and -Wuninitialized compiler
warning.
---
 drivers/leds/leds-lp5521.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index 21301f6..b3ee64c 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -695,6 +695,7 @@ static int __devinit lp5521_probe(struct i2c_client *client,
 	lp5521_read(client, LP5521_REG_R_CURRENT, &buf);
 	if (buf != LP5521_REG_R_CURR_DEFAULT) {
 		dev_err(&client->dev, "error in reseting chip\n");
+		ret = -EIO;
 		goto fail2;
 	}
 	usleep_range(10000, 20000);
-- 
1.7.7.3

