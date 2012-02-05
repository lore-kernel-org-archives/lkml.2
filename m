Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab2BEWiJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:38:09 -0500
Received: from 1wt.eu ([62.212.114.60]:62062 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754406Ab2BEW0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:26:51 -0500
Message-Id: <20120205220950.727161059@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:10:19 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 30/91] SUNRPC: Fix use of static variable in rpcb_getport_async
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

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
 1 files changed, 1 insertions(+), 1 deletions(-)

Index: longterm-2.6.27/net/sunrpc/rpcb_clnt.c
===================================================================
--- longterm-2.6.27.orig/net/sunrpc/rpcb_clnt.c	2012-02-05 22:34:34.111915926 +0100
+++ longterm-2.6.27/net/sunrpc/rpcb_clnt.c	2012-02-05 22:34:39.126915071 +0100
@@ -505,7 +505,7 @@
 	u32 bind_version;
 	struct rpc_xprt *xprt;
 	struct rpc_clnt	*rpcb_clnt;
-	static struct rpcbind_args *map;
+	struct rpcbind_args *map;
 	struct rpc_task	*child;
 	struct sockaddr_storage addr;
 	struct sockaddr *sap = (struct sockaddr *)&addr;


