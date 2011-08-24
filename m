Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab1HXSeY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 14:34:24 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:44375 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753885Ab1HXSeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 14:34:20 -0400
Subject: [PATCH 5/5] SUNRPC: remove rpcbind clients destruction on module
	cleanup
To: Trond.Myklebust@netapp.com
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: linux-nfs@vger.kernel.org, xemul@parallels.com, neilb@suse.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bfields@fieldses.org, davem@davemloft.net
Date: Wed, 24 Aug 2011 22:34:15 +0400
Message-ID: <20110824183415.4924.36067.stgit@localhost6.localdomain6>
In-Reply-To: <20110824183304.4924.94670.stgit@localhost6.localdomain6>
References: <20110824183304.4924.94670.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need this anymore since now rpcbind clients are destroying during last
RPC service shutdown.

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>

---
 net/sunrpc/rpcb_clnt.c   |   12 ------------
 net/sunrpc/sunrpc_syms.c |    3 ---
 2 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/net/sunrpc/rpcb_clnt.c b/net/sunrpc/rpcb_clnt.c
index f363efe..94a310d 100644
--- a/net/sunrpc/rpcb_clnt.c
+++ b/net/sunrpc/rpcb_clnt.c
@@ -1098,15 +1098,3 @@ static struct rpc_program rpcb_program = {
 	.version	= rpcb_version,
 	.stats		= &rpcb_stats,
 };
-
-/**
- * cleanup_rpcb_clnt - remove xprtsock's sysctls, unregister
- *
- */
-void cleanup_rpcb_clnt(void)
-{
-	if (rpcb_local_clnt4)
-		rpc_shutdown_client(rpcb_local_clnt4);
-	if (rpcb_local_clnt)
-		rpc_shutdown_client(rpcb_local_clnt);
-}
diff --git a/net/sunrpc/sunrpc_syms.c b/net/sunrpc/sunrpc_syms.c
index 9d08091..8ec9778 100644
--- a/net/sunrpc/sunrpc_syms.c
+++ b/net/sunrpc/sunrpc_syms.c
@@ -61,8 +61,6 @@ static struct pernet_operations sunrpc_net_ops = {
 
 extern struct cache_detail unix_gid_cache;
 
-extern void cleanup_rpcb_clnt(void);
-
 static int __init
 init_sunrpc(void)
 {
@@ -102,7 +100,6 @@ out:
 static void __exit
 cleanup_sunrpc(void)
 {
-	cleanup_rpcb_clnt();
 	rpcauth_remove_module();
 	cleanup_socket_xprt();
 	svc_cleanup_xprt_sock();

