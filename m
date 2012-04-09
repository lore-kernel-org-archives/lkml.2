Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757852Ab2DIUu4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 16:50:56 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:20965 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757770Ab2DIUuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 16:50:54 -0400
Date: Mon, 9 Apr 2012 22:50:53 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: trivial@kernel.org, netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        Simon Kelley <simon@thekelleys.org.uk>
Subject: [PATCH 11/26] wireless, atmel: remove pointless test for NULL before
 release_firmware() call
In-Reply-To: <alpine.LNX.2.00.1204092157340.13925@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1204092219310.13925@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1204092157340.13925@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

release_firmware() does its own test. Explicitly checking before the
call is redundant.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/net/wireless/atmel.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/atmel.c b/drivers/net/wireless/atmel.c
index 6c87a82..d07c030 100644
--- a/drivers/net/wireless/atmel.c
+++ b/drivers/net/wireless/atmel.c
@@ -3989,8 +3989,7 @@ static int reset_atmel_card(struct net_device *dev)
 			atmel_copy_to_card(priv->dev, 0x8000, &fw[0x6000], len - 0x6000);
 		}
 
-		if (fw_entry)
-			release_firmware(fw_entry);
+		release_firmware(fw_entry);
 	}
 
 	err = atmel_wakeup_firmware(priv);
-- 
1.7.10


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

