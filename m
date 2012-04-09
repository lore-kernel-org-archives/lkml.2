Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757726Ab2DIUuu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 16:50:50 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:20945 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757605Ab2DIUus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 16:50:48 -0400
Date: Mon, 9 Apr 2012 22:50:47 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: trivial@kernel.org, netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 10/26] wireless, at76c50x:: Don't needlessly test for NULL
 before calling release_firmware()
In-Reply-To: <alpine.LNX.2.00.1204092157340.13925@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1204092218300.13925@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1204092157340.13925@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The release_firmware() function deals gracefully with being passed a
NULL pointer, so explicit tests before the call are rather pointless.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/net/wireless/at76c50x-usb.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/at76c50x-usb.c b/drivers/net/wireless/at76c50x-usb.c
index 4045e5a..faa8bcb 100644
--- a/drivers/net/wireless/at76c50x-usb.c
+++ b/drivers/net/wireless/at76c50x-usb.c
@@ -2512,10 +2512,8 @@ static void __exit at76_mod_exit(void)
 
 	printk(KERN_INFO DRIVER_DESC " " DRIVER_VERSION " unloading\n");
 	usb_deregister(&at76_driver);
-	for (i = 0; i < ARRAY_SIZE(firmwares); i++) {
-		if (firmwares[i].fw)
-			release_firmware(firmwares[i].fw);
-	}
+	for (i = 0; i < ARRAY_SIZE(firmwares); i++)
+		release_firmware(firmwares[i].fw);
 	led_trigger_unregister_simple(ledtrig_tx);
 }
 
-- 
1.7.10


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

