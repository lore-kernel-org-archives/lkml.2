Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931Ab2LLODN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 09:03:13 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:42362 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754905Ab2LLODJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 09:03:09 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <cooloney@gmail.com>
CC: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 29/33] leds-lp5521: recovers previous driver patch for
 return value
Thread-Topic: [PATCH 29/33] leds-lp5521: recovers previous driver patch for
 return value
Thread-Index: Ac3YcWeF1jfuxxVNQmWL4W1oJXp2pQ==
Date: Wed, 12 Dec 2012 14:03:05 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E0ABFF@DQHE02.ent.ti.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 During the cleanup, Dan Carpenter's patch was removed.
 This patch recovers his patch based on the latest lp5521 driver.

  [PATCH] leds: leds-lp5521: return an error code on error in probe()
  If "buf" wasn't equal to LP5521_REG_R_CURR_DEFAULT the probe fails but
  we still return zero.  I've changed it to print an error message and
  return -EINVAL.

Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5521.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index 23d0bee..9de5aec 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -278,11 +278,18 @@ static int lp5521_post_init_device(struct lp55xx_chip *chip)
 	 * LP5521_REG_ENABLE register will not have any effect - strange!
 	 */
 	ret = lp55xx_read(chip, LP5521_REG_R_CURRENT, &val);
-	if (ret || val != LP5521_REG_R_CURR_DEFAULT) {
+	if (ret) {
 		dev_err(&chip->cl->dev, "error in resetting chip\n");
 		return ret;
 	}
 
+	if (val != LP5521_REG_R_CURR_DEFAULT) {
+		dev_err(&chip->cl->dev,
+			"unexpected data in register (expected 0x%x got 0x%x)\n",
+			LP5521_REG_R_CURR_DEFAULT, val);
+		return -EINVAL;
+	}
+
 	usleep_range(10000, 20000);
 
 	/* Set all PWMs to direct control mode */
-- 
1.7.9.5


Best Regards,
Milo


