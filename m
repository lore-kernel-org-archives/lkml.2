Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab2BCFqW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 00:46:22 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:35191 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716Ab2BCFqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 00:46:21 -0500
X-AuditID: b753bd60-99661ba00000359c-07-4f2b74aae93a
X-AuditID: b753bd60-99661ba00000359c-07-4f2b74aae93a
From: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Subject: [RFC PATCH] vfs: return EINVAL when calling mknod(2) with S_IFDIR mode
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Date: Fri, 03 Feb 2012 14:52:13 +0900
Message-ID: <20120203055213.18864.9049.stgit@ltc219.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to a manual of mknod(2) and mknodat(2), it seems that they
should return EINVAL when called with S_IFDIR mode, although currently
they return EPERM. So, this patch changes it to EINVAL for S_IFDIR.

Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
---

 fs/namei.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 208c6aa..5d7ead1 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2483,8 +2483,6 @@ static int may_mknod(umode_t mode)
 	case S_IFSOCK:
 	case 0: /* zero mode translates to S_IFREG */
 		return 0;
-	case S_IFDIR:
-		return -EPERM;
 	default:
 		return -EINVAL;
 	}
@@ -2498,7 +2496,7 @@ SYSCALL_DEFINE4(mknodat, int, dfd, const char __user *, filename, umode_t, mode,
 	int error;
 
 	if (S_ISDIR(mode))
-		return -EPERM;
+		return -EINVAL;
 
 	dentry = user_path_create(dfd, filename, &path, 0);
 	if (IS_ERR(dentry))

