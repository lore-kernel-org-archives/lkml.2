Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758558Ab1KVLn2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 06:43:28 -0500
Received: from www17.your-server.de ([213.133.104.17]:40349 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758442Ab1KVLml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 06:42:41 -0500
Subject: [PATCH] aoe: Use kmemdup rather than duplicating its implementation
From: Thomas Meyer <thomas@m3y3r.de>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Thu, 17 Nov 2011 23:43:40 +0100
Message-ID: <1321569820.1624.279.camel@localhost.localdomain>
X-Mailer: Evolution 3.2.1 (3.2.1-2.fc16) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The semantic patch that makes this change is available
in scripts/coccinelle/api/memdup.cocci.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/block/aoe/aoechr.c b/drivers/block/aoe/aoechr.c
--- a/drivers/block/aoe/aoechr.c 2011-11-07 19:39:05.287793252 +0100
+++ b/drivers/block/aoe/aoechr.c 2011-11-08 10:37:35.225430670 +0100
@@ -134,13 +134,12 @@ bail:		spin_unlock_irqrestore(&emsgs_loc
 		return;
 	}
 
-	mp = kmalloc(n, GFP_ATOMIC);
+	mp = kmemdup(msg, n, GFP_ATOMIC);
 	if (mp == NULL) {
 		printk(KERN_ERR "aoe: allocation failure, len=%ld\n", n);
 		goto bail;
 	}
 
-	memcpy(mp, msg, n);
 	em->msg = mp;
 	em->flags |= EMFL_VALID;
 	em->len = n;
