Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965232Ab2CMAck (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:32:40 -0400
Received: from mail.windriver.com ([147.11.1.11]:48794 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965141Ab2CMAYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:24:40 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Timo Warns <Warns@pre-sense.de>,
        Timo Warns <warns@pre-sense.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 172/196] Validate size of EFI GUID partition entries.
Date: Mon, 12 Mar 2012 20:21:25 -0400
Message-Id: <1331598109-31424-127-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Timo Warns <Warns@pre-sense.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit fa039d5f6b126fbd65eefa05db2f67e44df8f121 upstream.

Otherwise corrupted EFI partition tables can cause total confusion.

Signed-off-by: Timo Warns <warns@pre-sense.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/partitions/efi.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/partitions/efi.c b/fs/partitions/efi.c
index 91babda..ee59684 100644
--- a/fs/partitions/efi.c
+++ b/fs/partitions/efi.c
@@ -350,6 +350,12 @@ is_gpt_valid(struct block_device *bdev, u64 lba,
 		goto fail;
 	}
 
+	/* Check that sizeof_partition_entry has the correct value */
+	if (le32_to_cpu((*gpt)->sizeof_partition_entry) != sizeof(gpt_entry)) {
+		pr_debug("GUID Partitition Entry Size check failed.\n");
+		goto fail;
+	}
+
 	if (!(*ptes = alloc_read_gpt_entries(bdev, *gpt)))
 		goto fail;
 
-- 
1.7.9.3

