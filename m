Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759034Ab1LOQAQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 11:00:16 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:3096 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759019Ab1LOQAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 11:00:13 -0500
Subject: [PATCH 3/7] SUNRPC: use proper network namespace in rpcbind
 RPCBPROC_GETADDR procedure
To: Trond.Myklebust@netapp.com
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: linux-nfs@vger.kernel.org, xemul@parallels.com, neilb@suse.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jbottomley@parallels.com, bfields@fieldses.org, davem@davemloft.net,
        devel@openvz.org
Date: Thu, 15 Dec 2011 20:00:07 +0300
Message-ID: <20111215160007.2434.30287.stgit@localhost6.localdomain6>
In-Reply-To: <20111215155252.2434.39434.stgit@localhost6.localdomain6>
References: <20111215155252.2434.39434.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pass request socket network namespace to rpc_uaddr2sockaddr() instead of
hardcoded init_net,  when decoding address in RPCBPROC_GETADDR procedure.

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>

---
 net/sunrpc/rpcb_clnt.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/sunrpc/rpcb_clnt.c b/net/sunrpc/rpcb_clnt.c
index ea87b0c..d94f188 100644
--- a/net/sunrpc/rpcb_clnt.c
+++ b/net/sunrpc/rpcb_clnt.c
@@ -935,7 +935,8 @@ static int rpcb_dec_getaddr(struct rpc_rqst *req, struct xdr_stream *xdr,
 	dprintk("RPC: %5u RPCB_%s reply: %s\n", task->tk_pid,
 			task->tk_msg.rpc_proc->p_name, (char *)p);
 
-	if (rpc_uaddr2sockaddr(&init_net, (char *)p, len, sap, sizeof(address)) == 0)
+	if (rpc_uaddr2sockaddr(req->rq_xprt->xprt_net, (char *)p, len,
+				sap, sizeof(address)) == 0)
 		goto out_fail;
 	rpcb->r_port = rpc_get_port(sap);
 

