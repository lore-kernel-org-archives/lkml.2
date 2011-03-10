Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab1CJRkd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 12:40:33 -0500
Received: from asset.uwaterloo.ca ([129.97.92.29]:51951 "EHLO
	asset.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481Ab1CJRkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 12:40:32 -0500
Date: Thu, 10 Mar 2011 12:40:28 -0500
From: j223yang@asset.uwaterloo.ca
To: linux-kernel@vger.kernel.org
Cc: Trond.Myklebust@netapp.com
Subject: [patch]xprt: remove redundant null check
Message-ID: <20110310174028.GA10914@asset.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'req' is dereferenced before checked for NULL.
The patch simply removes the check.

Signed-off-by: Jinqiu Yang<crindy646@gmail.com>
---
 xprt.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)
--- a/net/sunrpc/xprt.c	2011-03-10 11:20:16.408039185 -0500
+++ b/net/sunrpc/xprt.c	2011-03-10 11:32:28.132164761 -0500
@@ -202,10 +202,9 @@ int xprt_reserve_xprt(struct rpc_task *t
 		goto out_sleep;
 	}
 	xprt->snd_task = task;
-	if (req) {
-		req->rq_bytes_sent = 0;
-		req->rq_ntrans++;
-	}
+	req->rq_bytes_sent = 0;
+	req->rq_ntrans++;
+
 	return 1;
 
 out_sleep:
