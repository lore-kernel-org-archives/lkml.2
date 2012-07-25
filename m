Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030247Ab2GYPNY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 11:13:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:44939 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933404Ab2GYPK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 11:10:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="171267658"
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 09/16] jbd/jbd2: nuke write_super from comments
Date: Wed, 25 Jul 2012 18:12:07 +0300
Message-Id: <1343229134-29487-10-git-send-email-artem.bityutskiy@linux.intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1343229134-29487-1-git-send-email-artem.bityutskiy@linux.intel.com>
References: <1343229134-29487-1-git-send-email-artem.bityutskiy@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

The '->write_super' superblock method is gone, and this patch removes all the
references to 'write_super' from various jbd and jbd2.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---

I expect this patch to be merged via Al Viro's VFS tree.

 fs/jbd/journal.c  |    4 ++--
 fs/jbd2/journal.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 425c2f2..0935750 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -534,8 +534,8 @@ int journal_start_commit(journal_t *journal, tid_t *ptid)
 		ret = 1;
 	} else if (journal->j_committing_transaction) {
 		/*
-		 * If ext3_write_super() recently started a commit, then we
-		 * have to wait for completion of that transaction
+		 * If commit has been started, then we have to wait for
+		 * completion of that transaction.
 		 */
 		if (ptid)
 			*ptid = journal->j_committing_transaction->t_tid;
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index e9a3c4c..8625da2 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -612,8 +612,8 @@ int jbd2_journal_start_commit(journal_t *journal, tid_t *ptid)
 		ret = 1;
 	} else if (journal->j_committing_transaction) {
 		/*
-		 * If ext3_write_super() recently started a commit, then we
-		 * have to wait for completion of that transaction
+		 * If commit has been started, then we have to wait for
+		 * completion of that transaction.
 		 */
 		if (ptid)
 			*ptid = journal->j_committing_transaction->t_tid;
-- 
1.7.10

