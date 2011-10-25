Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932684Ab1JYKRD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 06:17:03 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:40198 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932600Ab1JYKQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 06:16:59 -0400
Subject: [PATCH v6 7/8] SUNRPC: remove rpcbind clients creation during service
	registering
To: Trond.Myklebust@netapp.com
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: linux-nfs@vger.kernel.org, xemul@parallels.com, neilb@suse.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bfields@fieldses.org, davem@davemloft.net, devel@openvz.org
Date: Tue, 25 Oct 2011 14:17:38 +0300
Message-ID: <20111025101736.12689.66253.stgit@localhost6.localdomain6>
In-Reply-To: <20111025100826.12689.46944.stgit@localhost6.localdomain6>
References: <20111025100826.12689.46944.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need this code since rpcbind clients are creating during RPC service
creation.

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>

---
 net/sunrpc/rpcb_clnt.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/net/sunrpc/rpcb_clnt.c b/net/sunrpc/rpcb_clnt.c
index dba2331..088e4e2 100644
--- a/net/sunrpc/rpcb_clnt.c
+++ b/net/sunrpc/rpcb_clnt.c
@@ -432,11 +432,6 @@ int rpcb_register(u32 prog, u32 vers, int prot, unsigned short port)
 	struct rpc_message msg = {
 		.rpc_argp	= &map,
 	};
-	int error;
-
-	error = rpcb_create_local();
-	if (error)
-		return error;
 
 	dprintk("RPC:       %sregistering (%u, %u, %d, %u) with local "
 			"rpcbind\n", (port ? "" : "un"),
@@ -572,11 +567,7 @@ int rpcb_v4_register(const u32 program, const u32 version,
 	struct rpc_message msg = {
 		.rpc_argp	= &map,
 	};
-	int error;
 
-	error = rpcb_create_local();
-	if (error)
-		return error;
 	if (rpcb_local_clnt4 == NULL)
 		return -EPROTONOSUPPORT;
 

