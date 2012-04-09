Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757620Ab2DIUus (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 16:50:48 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:45077 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224Ab2DIUun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 16:50:43 -0400
Date: Mon, 9 Apr 2012 22:50:42 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: trivial@kernel.org, netdev@vger.kernel.org,
        Andy Gospodarek <andy@greyhouse.net>
Subject: [PATCH 09/26] tehuti: delete redundant NULL check before
 release_firmware()
In-Reply-To: <alpine.LNX.2.00.1204092157340.13925@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1204092217250.13925@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1204092157340.13925@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

release_firmware() checks for NULL pointers - no need to test before
the call.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/net/ethernet/tehuti/tehuti.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/tehuti/tehuti.c b/drivers/net/ethernet/tehuti/tehuti.c
index ad973ff..a445e77 100644
--- a/drivers/net/ethernet/tehuti/tehuti.c
+++ b/drivers/net/ethernet/tehuti/tehuti.c
@@ -341,8 +341,8 @@ static int bdx_fw_load(struct bdx_priv *priv)
 out:
 	if (master)
 		WRITE_REG(priv, regINIT_SEMAPHORE, 1);
-	if (fw)
-		release_firmware(fw);
+
+	release_firmware(fw);
 
 	if (rc) {
 		netdev_err(priv->ndev, "firmware loading failed\n");
-- 
1.7.10


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

