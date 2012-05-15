Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965700Ab2EOCSp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:18:45 -0400
Received: from mail.windriver.com ([147.11.1.11]:49368 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964912Ab2EOCQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:16:45 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 055/179] fat: Fix corrupt inode flags when remove ATTR_SYS flag
Date: Mon, 14 May 2012 22:12:31 -0400
Message-ID: <1337048075-6132-56-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 1adffbae22332bb558c2a29de19d9aca391869f6 upstream.

We are clearly missing '~' in fat_ioctl_set_attributes().

Reported-by: Dmitry Dmitriev <dimondmm@yandex.ru>
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/fat/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fat/file.c b/fs/fat/file.c
index e8c159d..279937b 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -101,7 +101,7 @@ static int fat_ioctl_set_attributes(struct file *file, u32 __user *user_attr)
 		if (attr & ATTR_SYS)
 			inode->i_flags |= S_IMMUTABLE;
 		else
-			inode->i_flags &= S_IMMUTABLE;
+			inode->i_flags &= ~S_IMMUTABLE;
 	}
 
 	fat_save_attrs(inode, attr);
-- 
1.7.9.6

