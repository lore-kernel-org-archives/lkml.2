Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078Ab2DIUvX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 16:51:23 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:21076 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756930Ab2DIUvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 16:51:20 -0400
Date: Mon, 9 Apr 2012 22:51:19 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: trivial@kernel.org, netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Pavel Roskin <proski@gnu.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 15/26] wireless, orinoco: release_firmware() tests for NULL,
 remove explicit tests before calls
In-Reply-To: <alpine.LNX.2.00.1204092157340.13925@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1204092225140.13925@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1204092157340.13925@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is redundant to test for NULL pointers before calling
release_firmware() since the function does its own NULL test.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/net/wireless/orinoco/fw.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/orinoco/fw.c b/drivers/net/wireless/orinoco/fw.c
index 4df8cf6..400a352 100644
--- a/drivers/net/wireless/orinoco/fw.c
+++ b/drivers/net/wireless/orinoco/fw.c
@@ -379,11 +379,8 @@ void orinoco_cache_fw(struct orinoco_private *priv, int ap)
 
 void orinoco_uncache_fw(struct orinoco_private *priv)
 {
-	if (priv->cached_pri_fw)
-		release_firmware(priv->cached_pri_fw);
-	if (priv->cached_fw)
-		release_firmware(priv->cached_fw);
-
+	release_firmware(priv->cached_pri_fw);
+	release_firmware(priv->cached_fw);
 	priv->cached_pri_fw = NULL;
 	priv->cached_fw = NULL;
 }
-- 
1.7.10


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

