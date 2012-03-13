Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758427Ab2CMAVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:21:53 -0400
Received: from mail.windriver.com ([147.11.1.11]:46776 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758248Ab2CMAR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:17:58 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 030/196] UBIFS: do not read flash unnecessarily
Date: Mon, 12 Mar 2012 20:12:38 -0400
Message-Id: <1331597724-31358-31-git-send-email-paul.gortmaker@windriver.com>
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

commit 8b229c76765816796eec7ccd428f03bd8de8b525 upstream.

This fix makes the 'dbg_check_old_index()' function return
immediately if debugging is disabled, instead of executing
incorrect 'goto out' which causes UBIFS to:

1. Allocate memory
2. Read the flash

On every commit. OK, we do not commit that often, but it is
still silly to do unneeded I/O anyway.

Credits to coverity for spotting this silly issue.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/ubifs/commit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ubifs/commit.c b/fs/ubifs/commit.c
index 37fa7ed..de01f28 100644
--- a/fs/ubifs/commit.c
+++ b/fs/ubifs/commit.c
@@ -519,7 +519,7 @@ int dbg_check_old_index(struct ubifs_info *c, struct ubifs_zbranch *zroot)
 	size_t sz;
 
 	if (!(ubifs_chk_flags & UBIFS_CHK_OLD_IDX))
-		goto out;
+		return 0;
 
 	INIT_LIST_HEAD(&list);
 
-- 
1.7.9.3

