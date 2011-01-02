Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472Ab1ABILi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 03:11:38 -0500
Received: from mail.windriver.com ([147.11.1.11]:34243 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab1ABHVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:21:49 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 024/260] ext4: Conditionally define compat ioctl numbers
Date: Sun,  2 Jan 2011 02:15:20 -0500
Message-Id: <1293952756-15010-25-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:20:32.0241 (UTC) FILETIME=[8A766610:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

commit 899ad0cea6ad7ff4ba24b16318edbc3cbbe03fad upstream.

It is unnecessary, and in general impossible, to define the compat
ioctl numbers except when building the filesystem with CONFIG_COMPAT
defined.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/ext4/ext4.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 7fe80c5..0419018 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -475,6 +475,7 @@ struct ext4_new_group_data {
 #define EXT4_IOC_ALLOC_DA_BLKS		_IO('f', 12)
 #define EXT4_IOC_MOVE_EXT		_IOWR('f', 15, struct move_extent)
 
+#if defined(__KERNEL__) && defined(CONFIG_COMPAT)
 /*
  * ioctl commands in 32 bit emulation
  */
@@ -490,6 +491,7 @@ struct ext4_new_group_data {
 #endif
 #define EXT4_IOC32_GETVERSION_OLD	FS_IOC32_GETVERSION
 #define EXT4_IOC32_SETVERSION_OLD	FS_IOC32_SETVERSION
+#endif
 
 
 /*
-- 
1.7.3.3

