Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308Ab0JDFuG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 01:50:06 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:63647 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab0JDFuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 01:50:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=GIYp2VYWT9CHWXuhtRlNthuEtVhSLLdXCif4cH/MzBowHSEa9wzTi1OS2acHmEqheo
         NAQbyGbMVRdYjPt0+Zl/f3zfAJlQuV5z+hGzQlWStwRh/GoXfbbkGICyxXX4m/+ieG39
         deTHnHJEtlKGIk+WrAXCnLqSOVBlDQ4Sz11S0=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] jbd: Simplify return path of journal_init_common()
Date: Mon,  4 Oct 2010 14:49:58 +0900
Message-Id: <1286171398-3479-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 fs/jbd/journal.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 2c4b1f1..6f20a75 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -698,7 +698,7 @@ static journal_t * journal_init_common (void)
 
 	journal = kzalloc(sizeof(*journal), GFP_KERNEL);
 	if (!journal)
-		goto fail;
+		goto out;
 
 	init_waitqueue_head(&journal->j_wait_transaction_locked);
 	init_waitqueue_head(&journal->j_wait_logspace);
@@ -721,11 +721,10 @@ static journal_t * journal_init_common (void)
 	err = journal_init_revoke(journal, JOURNAL_REVOKE_DEFAULT_HASH);
 	if (err) {
 		kfree(journal);
-		goto fail;
+		journal = NULL;
 	}
+out:
 	return journal;
-fail:
-	return NULL;
 }
 
 /* journal_init_dev and journal_init_inode:
-- 
1.7.0.4

