Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758261Ab2CMAR7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:17:59 -0400
Received: from mail.windriver.com ([147.11.1.11]:46767 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757642Ab2CMAR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:17:57 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 031/196] UBIFS: fix oops on error path in read_pnode
Date: Mon, 12 Mar 2012 20:12:39 -0400
Message-Id: <1331597724-31358-32-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 54acbaaa523ca0bd284a18f67ad213c379679e86 upstream.

Thanks to coverity which spotted that UBIFS will oops if 'kmalloc()'
in 'read_pnode()' fails and we dereference a NULL 'pnode' pointer
when we 'goto out'.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/ubifs/lpt.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/ubifs/lpt.c b/fs/ubifs/lpt.c
index ad7f67b..ead230e 100644
--- a/fs/ubifs/lpt.c
+++ b/fs/ubifs/lpt.c
@@ -1270,10 +1270,9 @@ static int read_pnode(struct ubifs_info *c, struct ubifs_nnode *parent, int iip)
 	lnum = branch->lnum;
 	offs = branch->offs;
 	pnode = kzalloc(sizeof(struct ubifs_pnode), GFP_NOFS);
-	if (!pnode) {
-		err = -ENOMEM;
-		goto out;
-	}
+	if (!pnode)
+		return -ENOMEM;
+
 	if (lnum == 0) {
 		/*
 		 * This pnode was not written which just means that the LEB
-- 
1.7.9.3

