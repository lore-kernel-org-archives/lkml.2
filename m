Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109Ab1KPPAO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 10:00:14 -0500
Received: from damascus.uab.es ([158.109.168.135]:34629 "EHLO damascus.uab.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754408Ab1KPPAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 10:00:13 -0500
Date: Wed, 16 Nov 2011 18:02:22 +0100
From: Davidlohr Bueso <dave@gnu.org>
Subject: [PATCH] reiserfs: delete comments refering to the BKL
To: akpm@linux-foundation.org
Cc: reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Message-id: <1321462942.11902.2.camel@offworld>
Organization: GNU
MIME-version: 1.0
X-Mailer: Evolution 3.0.3-2
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
X-Spam-Tests: ALL_TRUSTED=-1
X-imss-version: 2.054
X-imss-result: Passed
X-imss-scanInfo: M:P L:N SM:0
X-imss-tmaseResult: TT:0 TS:0.0000 TC:00 TRN:0 TV:6.5.1024(18522.007)
X-imss-scores: Clean:79.25439 C:2 M:3 S:5 R:5
X-imss-settings: Baseline:3 C:3 M:3 S:3 R:3 (0.5000 0.5000)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <dave@gnu.org>

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 fs/reiserfs/journal.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index eb71106..cce8e87 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -2896,14 +2896,13 @@ int journal_transaction_should_end(struct reiserfs_transaction_handle *th,
 	    journal->j_cnode_free < (journal->j_trans_max * 3)) {
 		return 1;
 	}
-	/* protected by the BKL here */
+
 	journal->j_len_alloc += new_alloc;
 	th->t_blocks_allocated += new_alloc ;
 	return 0;
 }
 
-/* this must be called inside a transaction, and requires the
-** kernel_lock to be held
+/* this must be called inside a transaction
 */
 void reiserfs_block_writes(struct reiserfs_transaction_handle *th)
 {
@@ -2914,8 +2913,7 @@ void reiserfs_block_writes(struct reiserfs_transaction_handle *th)
 	return;
 }
 
-/* this must be called without a transaction started, and does not
-** require BKL
+/* this must be called without a transaction started
 */
 void reiserfs_allow_writes(struct super_block *s)
 {
@@ -2924,8 +2922,7 @@ void reiserfs_allow_writes(struct super_block *s)
 	wake_up(&journal->j_join_wait);
 }
 
-/* this must be called without a transaction started, and does not
-** require BKL
+/* this must be called without a transaction started
 */
 void reiserfs_wait_on_write_block(struct super_block *s)
 {
-- 
1.7.7.2



