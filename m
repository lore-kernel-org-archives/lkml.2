Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372Ab2DIUu0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 16:50:26 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:20863 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224Ab2DIUuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 16:50:22 -0400
Date: Mon, 9 Apr 2012 22:50:15 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: trivial@kernel.org, netdev@vger.kernel.org,
        Michael Chan <mchan@broadcom.com>,
        Matt Carlson <mcarlson@broadcom.com>
Subject: [PATCH 05/26] tg3: remove redundant NULL test before release_firmware()
 call
In-Reply-To: <alpine.LNX.2.00.1204092157340.13925@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1204092209360.13925@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1204092157340.13925@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to test for a NULL pointer before calling
release_firmware - the function does that on its own.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/net/ethernet/broadcom/tg3.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 062ac33..9fbf73e 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -15842,8 +15842,7 @@ static void __devexit tg3_remove_one(struct pci_dev *pdev)
 	if (dev) {
 		struct tg3 *tp = netdev_priv(dev);
 
-		if (tp->fw)
-			release_firmware(tp->fw);
+		release_firmware(tp->fw);
 
 		tg3_reset_task_cancel(tp);
 
-- 
1.7.10


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

