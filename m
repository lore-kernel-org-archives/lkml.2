Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606Ab2HOUbf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:31:35 -0400
Received: from mail1.windriver.com ([147.11.146.13]:62800 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756403Ab2HOTtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:49:43 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 037/165] fs/9p: Fid is not valid after a failed clunk.
Date: Wed, 15 Aug 2012 15:46:21 -0400
Message-ID: <1345060109-9187-38-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 5034990e28efb2d232ee82443a9edd62defd17ba upstream.

free the fid even in case of failed clunk.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/9p/client.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/9p/client.c b/net/9p/client.c
index 583fd03..bd30c3b 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -1114,9 +1114,11 @@ int p9_client_clunk(struct p9_fid *fid)
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
1.7.12.rc2

