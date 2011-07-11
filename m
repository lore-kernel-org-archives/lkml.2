Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758141Ab1GKQlP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 12:41:15 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:46107 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758102Ab1GKQlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 12:41:14 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 1/3] fs/9p: Fid is not valid after a failed clunk.
Date: Mon, 11 Jul 2011 22:10:58 +0530
Message-Id: <1310402460-5098-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

free the fid even in case of failed clunk.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 net/9p/client.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/9p/client.c b/net/9p/client.c
index d225158..71b7749 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -1249,9 +1249,11 @@ int p9_client_clunk(struct p9_fid *fid)
 	P9_DPRINTK(P9_DEBUG_9P, "<<< RCLUNK fid %d\n", fid->fid);
 
 	p9_free_req(clnt, req);
-	p9_fid_destroy(fid);
-
 error:
+	/*
+	 * Fid is not valid even after a failed clunk
+	 */
+	p9_fid_destroy(fid);
 	return err;
 }
 EXPORT_SYMBOL(p9_client_clunk);
-- 
1.7.4.1

