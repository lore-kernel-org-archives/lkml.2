Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932420Ab1HFAMA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 20:12:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39657 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932407Ab1HFALy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 20:11:54 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug  5 17:04:12 2011
Message-Id: <20110806000412.152474044@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 05 Aug 2011 17:03:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ben Greear <greearb@candelatech.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [06/50] SUNRPC: Fix use of static variable in rpcb_getport_async
In-Reply-To: <20110806000419.GA28392@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Ben Greear <greearb@candelatech.com>

commit ec0dd267bf7d08cb30e321e45a75fd40edd7e528 upstream.

Because struct rpcbind_args *map was declared static, if two
threads entered this method at the same time, the values
assigned to map could be sent two two differen tasks.
This could cause all sorts of problems, include use-after-free
and double-free of memory.

Fix this by removing the static declaration so that the map
pointer is on the stack.

Signed-off-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sunrpc/rpcb_clnt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sunrpc/rpcb_clnt.c
+++ b/net/sunrpc/rpcb_clnt.c
@@ -579,7 +579,7 @@ void rpcb_getport_async(struct rpc_task
 	u32 bind_version;
 	struct rpc_xprt *xprt;
 	struct rpc_clnt	*rpcb_clnt;
-	static struct rpcbind_args *map;
+	struct rpcbind_args *map;
 	struct rpc_task	*child;
 	struct sockaddr_storage addr;
 	struct sockaddr *sap = (struct sockaddr *)&addr;


