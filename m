Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301Ab1GLR2D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 13:28:03 -0400
Received: from mail.candelatech.com ([208.74.158.172]:56160 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab1GLR2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 13:28:02 -0400
From: greearb@candelatech.com
To: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH] SUNRPC:  Fix use of static variable in rpcb_getport_async
Date: Tue, 12 Jul 2011 10:27:55 -0700
Message-Id: <1310491675-1699-1-git-send-email-greearb@candelatech.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Greear <greearb@candelatech.com>

Because struct rpcbind_args *map was declared static, if two
threads entered this method at the same time, the values
assigned to map could be sent two two differen tasks.
This could cause all sorts of problems, include use-after-free
and double-free of memory.

Fix this by removing the static declaration so that the map
pointer is on the stack.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 353234c... 1695c73... M	net/sunrpc/rpcb_clnt.c
 net/sunrpc/rpcb_clnt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/sunrpc/rpcb_clnt.c b/net/sunrpc/rpcb_clnt.c
index 353234c..1695c73 100644
--- a/net/sunrpc/rpcb_clnt.c
+++ b/net/sunrpc/rpcb_clnt.c
@@ -600,7 +600,7 @@ void rpcb_getport_async(struct rpc_task *task)
 	u32 bind_version;
 	struct rpc_xprt *xprt;
 	struct rpc_clnt	*rpcb_clnt;
-	static struct rpcbind_args *map;
+	struct rpcbind_args *map;
 	struct rpc_task	*child;
 	struct sockaddr_storage addr;
 	struct sockaddr *sap = (struct sockaddr *)&addr;
-- 
1.7.3.4

