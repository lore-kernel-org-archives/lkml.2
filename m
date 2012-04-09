Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951Ab2DIUvG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 16:51:06 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:45088 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757343Ab2DIUvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 16:51:02 -0400
Date: Mon, 9 Apr 2012 22:51:01 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: trivial@kernel.org, netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>
Subject: [PATCH 12/26] ipw2200: remove a redundant NULL check before calling
 release_firmware()
In-Reply-To: <alpine.LNX.2.00.1204092157340.13925@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1204092220360.13925@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1204092157340.13925@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The release_firmware() function does its own NULL test, so testing
before calling it is rather redundant.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/net/wireless/ipw2x00/ipw2200.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
index 2b02257..77c5d2f 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -3657,8 +3657,7 @@ static int ipw_load(struct ipw_priv *priv)
 		priv->rxq = NULL;
 	}
 	ipw_tx_queue_free(priv);
-	if (raw)
-		release_firmware(raw);
+	release_firmware(raw);
 #ifdef CONFIG_PM
 	fw_loaded = 0;
 	raw = NULL;
-- 
1.7.10


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

