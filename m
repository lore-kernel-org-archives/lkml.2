Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758261Ab0EDMJ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 08:09:28 -0400
Received: from mx1.emlix.com ([193.175.82.87]:34297 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137Ab0EDMJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 08:09:26 -0400
X-Greylist: delayed 806 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 May 2010 08:09:25 EDT
Date: Tue, 4 May 2010 13:59:57 +0200
From: Johannes Weiner <jw@emlix.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Alexandros Batsakis <batsakis@netapp.com>, linux-nfs@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch] sunrpc: add missing return statement
Message-ID: <20100504115759.266396633@emlix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
User-Agent: quilt/0.48-1
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

f300bab "nfsd41: sunrpc: add new xprt class for nfsv4.1 backchannel"
introduced an error case branch that lacks an actual `return' keyword
before the return value.  Add it.

Signed-off-by: Johannes Weiner <jw@emlix.com>
Cc: Alexandros Batsakis <batsakis@netapp.com>
---
 net/sunrpc/xprtsock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -2444,7 +2444,7 @@ static struct rpc_xprt *xs_setup_bc_tcp(
 	struct svc_sock *bc_sock;
 
 	if (!args->bc_xprt)
-		ERR_PTR(-EINVAL);
+		return ERR_PTR(-EINVAL);
 
 	xprt = xs_setup_xprt(args, xprt_tcp_slot_table_entries);
 	if (IS_ERR(xprt))
