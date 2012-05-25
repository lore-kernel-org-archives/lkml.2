Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab2EYKj3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 06:39:29 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42261 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752362Ab2EYKj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 06:39:28 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-kernel@vger.kernel.org
Cc: Will Deacon <will.deacon@arm.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] pipe: return -ENOIOCTLCMD instead of -EINVAL on unknown ioctl command
Date: Fri, 25 May 2012 11:39:13 +0100
Message-Id: <1337942353-30979-1-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As described in commit 07d106d0a ("vfs: fix up ENOIOCTLCMD error
handling"), drivers should return -ENOIOCTLCMD if they receive an ioctl
command which they don't understand. Doing so will result in -ENOTTY
being returned to userspace, which matches the behaviour of the compat
layer if it fails to translate an ioctl command.

This patch fixes the pipe ioctl to return -ENOIOCTLCMD instead of
-EINVAL when passed an unknown ioctl command.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 fs/pipe.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index fec5e4a..95ebb56 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -693,7 +693,7 @@ static long pipe_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 
 			return put_user(count, (int __user *)arg);
 		default:
-			return -EINVAL;
+			return -ENOIOCTLCMD;
 	}
 }
 
-- 
1.7.4.1

