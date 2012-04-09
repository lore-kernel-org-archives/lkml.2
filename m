Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270Ab2DIUuO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 16:50:14 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:20840 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734Ab2DIUuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 16:50:11 -0400
Date: Mon, 9 Apr 2012 22:50:10 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: trivial@kernel.org, netdev@vger.kernel.org,
        David Dillow <dave@thedillows.org>
Subject: [PATCH 04/26] typhoon: get rid of redundant conditional before all
 to release_firmware()
In-Reply-To: <alpine.LNX.2.00.1204092157340.13925@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1204092208140.13925@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1204092157340.13925@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to test for a NULL pointer before calling
release_firmware() since the function does that check itself, so
remove the redundant test.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/net/ethernet/3com/typhoon.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/3com/typhoon.c b/drivers/net/ethernet/3com/typhoon.c
index 1234a14..b153666 100644
--- a/drivers/net/ethernet/3com/typhoon.c
+++ b/drivers/net/ethernet/3com/typhoon.c
@@ -2549,8 +2549,7 @@ typhoon_init(void)
 static void __exit
 typhoon_cleanup(void)
 {
-	if (typhoon_fw)
-		release_firmware(typhoon_fw);
+	release_firmware(typhoon_fw);
 	pci_unregister_driver(&typhoon_driver);
 }
 
-- 
1.7.10


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

