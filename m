Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966529Ab0CPPaG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 11:30:06 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:41675 "EHLO
	mail.jetsystems.cz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S966476Ab0CPPaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 11:30:04 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Daniel Borkmann <danborkmann@googlemail.com>
Subject: [PATCH 1/1] NET: netpoll, fix potential NULL ptr dereference
Date: Tue, 16 Mar 2010 16:29:54 +0100
Message-Id: <1268753394-17765-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanse found that one error path in netpoll_setup dereferences npinfo
even though it is NULL. Avoid that by adding new label and go to that
instead.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Daniel Borkmann <danborkmann@googlemail.com>
Cc: David S. Miller <davem@davemloft.net>
---
 net/core/netpoll.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 7aa6972..d4ec38f 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -735,7 +735,7 @@ int netpoll_setup(struct netpoll *np)
 		npinfo = kmalloc(sizeof(*npinfo), GFP_KERNEL);
 		if (!npinfo) {
 			err = -ENOMEM;
-			goto release;
+			goto put;
 		}
 
 		npinfo->rx_flags = 0;
@@ -845,7 +845,7 @@ int netpoll_setup(struct netpoll *np)
 
 		kfree(npinfo);
 	}
-
+put:
 	dev_put(ndev);
 	return err;
 }
-- 
1.7.0.1


