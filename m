Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701Ab2EUPoS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 11:44:18 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:43572 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751298Ab2EUPoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 11:44:17 -0400
X-Greylist: delayed 495 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 May 2012 11:44:17 EDT
From: Reinhard Tartler <siretart@tauware.de>
To: Bryan Wu <bryan.wu@canonical.com>, Richard Purdie <rpurdie@rpsys.net>
Cc: linux-kernel@vger.kernel.org, Reinhard Tartler <siretart@tauware.de>
Subject: [PATCH] drivers/leds/leds-lp5521.c: actually check return value of lp5521_read
Date: Mon, 21 May 2012 17:35:42 +0200
Message-Id: <1337614542-31696-1-git-send-email-siretart@tauware.de>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This detects device failures properly. Fixes compiler warning:
drivers/leds/leds-lp5521.c:741: warning: 'buf' may be used uninitialized in this function

Signed-off-by: Reinhard Tartler <siretart@tauware.de>
---
 drivers/leds/leds-lp5521.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

This problem was found by tools developed by the VAMOS project:
http://www4.cs.fau.de/Research/VAMOS/

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index 410a723..943c69d 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -785,7 +785,7 @@ static int __devinit lp5521_probe(struct i2c_client *client,
 	 * LP5521_REG_ENABLE register will not have any effect - strange!
 	 */
 	ret = lp5521_read(client, LP5521_REG_R_CURRENT, &buf);
-	if (buf != LP5521_REG_R_CURR_DEFAULT) {
+	if (ret == -EIO || buf != LP5521_REG_R_CURR_DEFAULT) {
 		dev_err(&client->dev, "error in resetting chip\n");
 		goto fail2;
 	}
-- 
1.7.10

