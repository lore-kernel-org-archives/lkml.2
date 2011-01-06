Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab1AFAbY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:31:24 -0500
Received: from kroah.org ([198.145.64.141]:36016 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754636Ab1AFAbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:31:21 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:08 2011
Message-Id: <20110106002308.152264353@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:23:40 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Wolfram Sang <w.sang@pengutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: [121/152] rtc: rs5c372: fix buffer size
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Wolfram Sang <w.sang@pengutronix.de>

commit 118364948fad7b6c0469ef2d3ddaee447d7a0b5f upstream.

Match the buffer size to the amount of initialized values.  Before, it was
one too big and thus destroyed the neighbouring register causing the clock
to run at false speeds.

Reported-by: Andre van Rooyen <a.v.rooyen@sercom.nl>
Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/rtc/rtc-rs5c372.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/rtc/rtc-rs5c372.c
+++ b/drivers/rtc/rtc-rs5c372.c
@@ -207,7 +207,7 @@ static int rs5c372_get_datetime(struct i
 static int rs5c372_set_datetime(struct i2c_client *client, struct rtc_time *tm)
 {
 	struct rs5c372	*rs5c = i2c_get_clientdata(client);
-	unsigned char	buf[8];
+	unsigned char	buf[7];
 	int		addr;
 
 	dev_dbg(&client->dev, "%s: tm is secs=%d, mins=%d, hours=%d "


