Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935085Ab2JaIGG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 04:06:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56674 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935002Ab2JaIFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 04:05:43 -0400
From: Xiaotian Feng <xtfeng@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Xiaotian Feng <xtfeng@gmail.com>, Xiaotian Feng <dannyfeng@tencent.com>,
        Jon Maloy <jon.maloy@ericsson.com>,
        Allan Stephens <allan.stephens@windriver.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: [PATCH 3/3] tipc: do not use tasklet_disable before tasklet_kill
Date: Wed, 31 Oct 2012 16:06:01 +0800
Message-Id: <1351670761-26749-3-git-send-email-xtfeng@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351670761-26749-1-git-send-email-xtfeng@gmail.com>
References: <1351670761-26749-1-git-send-email-xtfeng@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If tasklet_disable() is called before related tasklet handled,
tasklet_kill will never be finished. tasklet_kill is enough.

Signed-off-by: Xiaotian Feng <dannyfeng@tencent.com>
Cc: Jon Maloy <jon.maloy@ericsson.com>
Cc: Allan Stephens <allan.stephens@windriver.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Cc: tipc-discussion@lists.sourceforge.net
---
 net/tipc/handler.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/net/tipc/handler.c b/net/tipc/handler.c
index 111ff83..b36f0fc 100644
--- a/net/tipc/handler.c
+++ b/net/tipc/handler.c
@@ -116,7 +116,6 @@ void tipc_handler_stop(void)
 		return;
 
 	handler_enabled = 0;
-	tasklet_disable(&tipc_tasklet);
 	tasklet_kill(&tipc_tasklet);
 
 	spin_lock_bh(&qitem_lock);
-- 
1.7.9.5

