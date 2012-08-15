Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244Ab2HOUbM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:31:12 -0400
Received: from mail1.windriver.com ([147.11.146.13]:62802 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756411Ab2HOTtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:49:45 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: "Venkateswararao Jujjuri (JV)" <jvrao@linux.vnet.ibm.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 038/165] net/9p: Fix the msize calculation.
Date: Wed, 15 Aug 2012 15:46:22 -0400
Message-ID: <1345060109-9187-39-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Venkateswararao Jujjuri (JV)" <jvrao@linux.vnet.ibm.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit c9ffb05ca5b5098d6ea468c909dd384d90da7d54 upstream.

msize represents the maximum PDU size that includes P9_IOHDRSZ.

Signed-off-by: Venkateswararao Jujjuri "<jvrao@linux.vnet.ibm.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/9p/client.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/9p/client.c b/net/9p/client.c
index bd30c3b..1a1e6d5 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -775,8 +775,8 @@ struct p9_client *p9_client_create(const char *dev_name, char *options)
 	if (err)
 		goto destroy_fidpool;
 
-	if ((clnt->msize+P9_IOHDRSZ) > clnt->trans_mod->maxsize)
-		clnt->msize = clnt->trans_mod->maxsize-P9_IOHDRSZ;
+	if (clnt->msize > clnt->trans_mod->maxsize)
+		clnt->msize = clnt->trans_mod->maxsize;
 
 	err = p9_client_version(clnt);
 	if (err)
-- 
1.7.12.rc2

