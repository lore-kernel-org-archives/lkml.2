Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751371Ab1ABHV2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:21:28 -0500
Received: from mail.windriver.com ([147.11.1.11]:33952 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab1ABHV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:21:26 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Christian Borntraeger <borntraeger@de.ibm.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Akira Fujita <a-fujita@rs.jp.nec.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 008/260] ext4: allow defrag (EXT4_IOC_MOVE_EXT) in 32bit compat mode
Date: Sun,  2 Jan 2011 02:15:04 -0500
Message-Id: <1293952756-15010-9-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:20:15.0350 (UTC) FILETIME=[80650960:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

commit b684b2ee9409f2890a8b3aea98525bbe5f84e276 upstream.

I have an x86_64 kernel with i386 userspace. e4defrag fails on the
EXT4_IOC_MOVE_EXT ioctl because it is not wired up for the compat
case. It seems that struct move_extent is compat save, only types
with fixed widths are used:
{
        __u32 reserved;         /* should be zero */
        __u32 donor_fd;         /* donor file descriptor */
        __u64 orig_start;       /* logical start offset in block for orig */
        __u64 donor_start;      /* logical start offset in block for donor */
        __u64 len;              /* block length to be moved */
        __u64 moved_len;        /* moved block length */
};

Lets just wire up EXT4_IOC_MOVE_EXT for the compat case.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
CC: Akira Fujita <a-fujita@rs.jp.nec.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/ext4/ioctl.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 016d024..66fa0b0 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -375,6 +375,8 @@ long ext4_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		break;
 	case EXT4_IOC_GROUP_ADD:
 		break;
+	case EXT4_IOC_MOVE_EXT:
+		break;
 	default:
 		return -ENOIOCTLCMD;
 	}
-- 
1.7.3.3

