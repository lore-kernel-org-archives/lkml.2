Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932650Ab2HGDpF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 23:45:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59863 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964819Ab2HGDiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 23:38:55 -0400
Message-Id: <20120807032802.644504679@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 07 Aug 2012 04:28:40 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 45/70] SUNRPC: return negative value in case rpcbind client creation error
In-Reply-To: <20120807032755.803571133@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Kinsbursky <skinsbursky@parallels.com>

commit caea33da898e4e14f0ba58173e3b7689981d2c0b upstream.

Without this patch kernel will panic on LockD start, because lockd_up() checks
lockd_up_net() result for negative value.
>From my pow it's better to return negative value from rpcbind routines instead
of replacing all such checks like in lockd_up().

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/sunrpc/rpcb_clnt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/rpcb_clnt.c b/net/sunrpc/rpcb_clnt.c
index 92509ff..a70acae 100644
--- a/net/sunrpc/rpcb_clnt.c
+++ b/net/sunrpc/rpcb_clnt.c
@@ -251,7 +251,7 @@ static int rpcb_create_local_unix(struct net *net)
 	if (IS_ERR(clnt)) {
 		dprintk("RPC:       failed to create AF_LOCAL rpcbind "
 				"client (errno %ld).\n", PTR_ERR(clnt));
-		result = -PTR_ERR(clnt);
+		result = PTR_ERR(clnt);
 		goto out;
 	}
 
@@ -298,7 +298,7 @@ static int rpcb_create_local_net(struct net *net)
 	if (IS_ERR(clnt)) {
 		dprintk("RPC:       failed to create local rpcbind "
 				"client (errno %ld).\n", PTR_ERR(clnt));
-		result = -PTR_ERR(clnt);
+		result = PTR_ERR(clnt);
 		goto out;
 	}
 


