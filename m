Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766Ab2B0MFi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 07:05:38 -0500
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:40973 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753089Ab2B0MFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 07:05:37 -0500
From: Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
To: rpurdie@rpsys.net
Cc: linux-kernel@vger.kernel.org, akpm00@gmail.com,
        linus.walleij@stericsson.com,
        srinidhi kasagar <srinidhi.kasagar@stericsson.com>
Subject: [PATCH] drivers/leds/leds-lp5521.c: ret may be uninitialized
Date: Mon, 27 Feb 2012 17:35:24 +0530
Message-Id: <1330344324-12363-1-git-send-email-srinidhi.kasagar@stericsson.com>
X-Mailer: git-send-email 1.7.2.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix it by assigning the lp5521_read return value.

Signed-off-by: srinidhi kasagar <srinidhi.kasagar@stericsson.com>
---
 drivers/leds/leds-lp5521.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index d62a798..e683e9d 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -692,7 +692,7 @@ static int __devinit lp5521_probe(struct i2c_client *client,
 	 * otherwise further access to the R G B channels in the
 	 * LP5521_REG_ENABLE register will not have any effect - strange!
 	 */
-	lp5521_read(client, LP5521_REG_R_CURRENT, &buf);
+	ret = lp5521_read(client, LP5521_REG_R_CURRENT, &buf);
 	if (buf != LP5521_REG_R_CURR_DEFAULT) {
 		dev_err(&client->dev, "error in reseting chip\n");
 		goto fail2;
-- 
1.7.2.dirty

