Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560Ab2L1TUt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:20:49 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55733 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932488Ab2L1TUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:20:00 -0500
Message-Id: <20121228190334.206284646@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:03:50 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        "Milo(Woogyom) Kim" <milo.kim@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arun MURTHY <arun.murthy@stericsson.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 020/173] drivers/leds/leds-lp5521.c: ret may be uninitialized
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>

commit 42960b76d2c6a44d7e8000f4eb9a4ca1780059ff upstream.

Fix it by assigning the lp5521_read return value.

Signed-off-by: srinidhi kasagar <srinidhi.kasagar@stericsson.com>
Cc: Milo(Woogyom) Kim <milo.kim@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Arun MURTHY <arun.murthy@stericsson.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/leds/leds-lp5521.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index de7b8fe..410a723 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -784,7 +784,7 @@ static int __devinit lp5521_probe(struct i2c_client *client,
 	 * otherwise further access to the R G B channels in the
 	 * LP5521_REG_ENABLE register will not have any effect - strange!
 	 */
-	lp5521_read(client, LP5521_REG_R_CURRENT, &buf);
+	ret = lp5521_read(client, LP5521_REG_R_CURRENT, &buf);
 	if (buf != LP5521_REG_R_CURR_DEFAULT) {
 		dev_err(&client->dev, "error in resetting chip\n");
 		goto fail2;


