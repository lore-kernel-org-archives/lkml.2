Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650Ab2ECONE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 10:13:04 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:38951 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754773Ab2ECONA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 10:13:00 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: reiserfs-devel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] fs/reiserfs/journal.c: add missing brelse
Date: Thu,  3 May 2012 16:12:53 +0200
Message-Id: <1336054373-13293-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Brelse is called to put bhjh on every way out of the function except this one.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 fs/reiserfs/journal.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index b1a0857..1ef9cbc 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -2757,8 +2757,10 @@ int journal_init(struct super_block *sb, const char *j_dev_name,
 	    le32_to_cpu(jh->jh_journal.jp_journal_max_commit_age);
 	journal->j_max_trans_age = JOURNAL_MAX_TRANS_AGE;
 
-	if (check_advise_trans_params(sb, journal) != 0)
+	if (check_advise_trans_params(sb, journal) != 0) {
+		brelse(bhjh);
 	        goto free_and_return;
+	}
 	journal->j_default_max_commit_age = journal->j_max_commit_age;
 
 	if (commit_max_age != 0) {

