Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098Ab1ABIMw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 03:12:52 -0500
Received: from mail.windriver.com ([147.11.1.11]:34076 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab1ABHVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:21:34 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Jan Kara <jack@suse.cz>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 019/260] ext4: Show journal_checksum option
Date: Sun,  2 Jan 2011 02:15:15 -0500
Message-Id: <1293952756-15010-20-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:20:27.0178 (UTC) FILETIME=[8771D8A0:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit 39a4bade8c1826b658316d66ee81c09b0a4d7d42 upstream.

We failed to show journal_checksum option in /proc/mounts. Fix it.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/ext4/super.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index f9e57e1..aa947e0 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -942,6 +942,8 @@ static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
 	seq_puts(seq, test_opt(sb, BARRIER) ? "1" : "0");
 	if (test_opt(sb, JOURNAL_ASYNC_COMMIT))
 		seq_puts(seq, ",journal_async_commit");
+	else if (test_opt(sb, JOURNAL_CHECKSUM))
+		seq_puts(seq, ",journal_checksum");
 	if (test_opt(sb, NOBH))
 		seq_puts(seq, ",nobh");
 	if (test_opt(sb, I_VERSION))
-- 
1.7.3.3

