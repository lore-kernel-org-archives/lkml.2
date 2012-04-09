Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057Ab2DIUvR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 16:51:17 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:21039 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758032Ab2DIUvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 16:51:13 -0400
Date: Mon, 9 Apr 2012 22:51:12 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: trivial@kernel.org, netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 14/26] wireless, mwifiex: drop redundant NULL test before
 call to release_firmware()
In-Reply-To: <alpine.LNX.2.00.1204092157340.13925@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1204092224080.13925@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1204092157340.13925@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since release_firmware() does its own test for NULL it is redundant to
do so before calling it.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/net/wireless/mwifiex/main.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 9d1b3ca..2ee6162 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -342,8 +342,7 @@ static int mwifiex_init_hw_fw(struct mwifiex_adapter *adapter)
 	ret = 0;
 
 done:
-	if (adapter->firmware)
-		release_firmware(adapter->firmware);
+	release_firmware(adapter->firmware);
 	if (ret)
 		ret = -1;
 	return ret;
-- 
1.7.10


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

