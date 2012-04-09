Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165Ab2DIUvw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 16:51:52 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:21198 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755264Ab2DIUvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 16:51:49 -0400
Date: Mon, 9 Apr 2012 22:51:48 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: trivial@kernel.org, devel@driverdev.osuosl.org,
        linux-media@vger.kernel.org,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Piotr Chmura <chmooreck@poczta.onet.pl>,
        Sylwester Nawrocki <snjw23@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 20/26] [media] staging: as102: Remove redundant NULL check
 before release_firmware() and pointless comments
In-Reply-To: <alpine.LNX.2.00.1204092157340.13925@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1204092231330.13925@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1204092157340.13925@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

release_firmware() deals gracefullt with NULL pointers - it's
redundant to check for them before calling the function.

Also remove a few pointless comments - it's rather obvious from the
code that kfree() free's a buffer and that release_firmware() releases
firmware - comments just stating that add no value.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/media/as102/as102_fw.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/staging/media/as102/as102_fw.c b/drivers/staging/media/as102/as102_fw.c
index 43ebc43..9db275e 100644
--- a/drivers/staging/media/as102/as102_fw.c
+++ b/drivers/staging/media/as102/as102_fw.c
@@ -230,11 +230,8 @@ int as102_fw_upload(struct as10x_bus_adapter_t *bus_adap)
 	pr_info("%s: firmware: %s loaded with success\n",
 		DRIVER_NAME, fw2);
 error:
-	/* free data buffer */
 	kfree(cmd_buf);
-	/* release firmware if needed */
-	if (firmware != NULL)
-		release_firmware(firmware);
+	release_firmware(firmware);
 
 	LEAVE();
 	return errno;
-- 
1.7.10


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

