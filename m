Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab1BBAv4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:51:56 -0500
Received: from mga09.intel.com ([134.134.136.24]:35413 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753823Ab1BBApD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:45:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="703028608"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: w.sang@pengutronix.de, ak@linux.intel.com, a.zummo@towertech.it,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        gregkh@suse.de, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [114/139] rtc: rs5c372: fix buffer size
Message-Id: <20110202004513.19C453E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:45:13 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Wolfram Sang <w.sang@pengutronix.de>

commit 118364948fad7b6c0469ef2d3ddaee447d7a0b5f upstream.

Match the buffer size to the amount of initialized values.  Before, it was
one too big and thus destroyed the neighbouring register causing the clock
to run at false speeds.

Reported-by: Andre van Rooyen <a.v.rooyen@sercom.nl>
Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/rtc/rtc-rs5c372.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/drivers/rtc/rtc-rs5c372.c
===================================================================
--- linux-2.6.35.y.orig/drivers/rtc/rtc-rs5c372.c
+++ linux-2.6.35.y/drivers/rtc/rtc-rs5c372.c
@@ -207,7 +207,7 @@ static int rs5c372_get_datetime(struct i
 static int rs5c372_set_datetime(struct i2c_client *client, struct rtc_time *tm)
 {
 	struct rs5c372	*rs5c = i2c_get_clientdata(client);
-	unsigned char	buf[8];
+	unsigned char	buf[7];
 	int		addr;
 
 	dev_dbg(&client->dev, "%s: tm is secs=%d, mins=%d, hours=%d "
