Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524Ab1FMUZP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 16:25:15 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:23053 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab1FMUZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 16:25:13 -0400
Date: Mon, 13 Jun 2011 22:16:44 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        trivial@kernel.org
Subject: [PATCH/Trivial] jffs2: Avoid unneeded 'if' before kfree
Message-ID: <alpine.LNX.2.00.1106132213500.30934@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kfree() deals gracefully with NULL pointers, so it's pointless to test for 
one prior to calling it.
This removes such a test from jffs2_scan_medium().

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 scan.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/jffs2/scan.c b/fs/jffs2/scan.c
index 8d8cd34..28107ca 100644
--- a/fs/jffs2/scan.c
+++ b/fs/jffs2/scan.c
@@ -275,9 +275,7 @@ int jffs2_scan_medium(struct jffs2_sb_info *c)
 	else
 		c->mtd->unpoint(c->mtd, 0, c->mtd->size);
 #endif
-	if (s)
-		kfree(s);
-
+	kfree(s);
 	return ret;
 }
 

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

