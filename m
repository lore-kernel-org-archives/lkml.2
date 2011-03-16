Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751607Ab1CPGpO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 02:45:14 -0400
Received: from asset.uwaterloo.ca ([129.97.92.29]:55711 "EHLO
	asset.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315Ab1CPGpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 02:45:11 -0400
Date: Wed, 16 Mar 2011 02:45:09 -0400
From: j223yang@asset.uwaterloo.ca
To: linux-nfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch]xprt: remove redundant checks
Message-ID: <20110316064509.GA1498@asset.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'req' is already dereferenced in 
'struct rpc_xprt *xprt = req->rq_xprt;',
but check again later in the function.
The patch removes these redundant checks.

Signed-off-by: Jinqiu Yang <crindy646@gmail.com>
---
 xprt.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/sunrpt/xprt.c b/net/sunrpt/xprt.c
--- a/net/sunrpc/xprt.c	2011-03-16 00:10:08.764164573 -0400
+++ b/net/sunrpt/xprt.c	2011-03-16 02:33:38.559164414 -0400
@@ -202,10 +202,8 @@ int xprt_reserve_xprt(struct rpc_task *t
 		goto out_sleep;
 	}
 	xprt->snd_task = task;
-	if (req) {
-		req->rq_bytes_sent = 0;
-		req->rq_ntrans++;
-	}
+	req->rq_bytes_sent = 0;
+	req->rq_ntrans++;
 	return 1;
 
 out_sleep:
@@ -213,7 +211,7 @@ out_sleep:
 			task->tk_pid, xprt);
 	task->tk_timeout = 0;
 	task->tk_status = -EAGAIN;
-	if (req && req->rq_ntrans)
+	if (req->rq_ntrans)
 		rpc_sleep_on(&xprt->resend, task, NULL);
 	else
 		rpc_sleep_on(&xprt->sending, task, NULL);
