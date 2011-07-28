Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242Ab1G1Xu7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 19:50:59 -0400
Received: from mga14.intel.com ([143.182.124.37]:50848 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932087Ab1G1Xob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 19:44:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,285,1309762800"; 
   d="scan'208";a="32808982"
From: Andi Kleen <andi@firstfloor.org>
References: <20110728444.299940435@firstfloor.org>
In-Reply-To: <20110728444.299940435@firstfloor.org>
To: greearb@candelatech.com, Trond.Myklebust@netapp.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [26/50] SUNRPC: Fix use of static variable in rpcb_getport_async
Message-Id: <20110728234430.BFAF72403FF@tassilo.jf.intel.com>
Date: Thu, 28 Jul 2011 16:44:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Ben Greear <greearb@candelatech.com>

[ upstream commit ec0dd267bf7d08cb30e321e45a75fd40edd7e528 ]

Because struct rpcbind_args *map was declared static, if two
threads entered this method at the same time, the values
assigned to map could be sent two two differen tasks.
This could cause all sorts of problems, include use-after-free
and double-free of memory.

Fix this by removing the static declaration so that the map
pointer is on the stack.

Signed-off-by: Ben Greear <greearb@candelatech.com>
Cc: stable@kernel.org
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/net/sunrpc/rpcb_clnt.c
===================================================================
--- linux-2.6.35.y.orig/net/sunrpc/rpcb_clnt.c
+++ linux-2.6.35.y/net/sunrpc/rpcb_clnt.c
@@ -580,7 +580,7 @@ void rpcb_getport_async(struct rpc_task 
 	u32 bind_version;
 	struct rpc_xprt *xprt;
 	struct rpc_clnt	*rpcb_clnt;
-	static struct rpcbind_args *map;
+	struct rpcbind_args *map;
 	struct rpc_task	*child;
 	struct sockaddr_storage addr;
 	struct sockaddr *sap = (struct sockaddr *)&addr;
