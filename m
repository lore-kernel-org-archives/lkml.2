Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526Ab0LZQmu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Dec 2010 11:42:50 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64249 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415Ab0LZQmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Dec 2010 11:42:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JNzKXOOfj7U+uqUEUvYFcn6CASjs9p08Dl7Lwb/DvgfWqnrM7+IJQ1HO/LHzFxLWuc
         vS02aTmA8/2ZHR2vIBUs6SACRItRT3h84wLC2uQnzWYRXAfZ5iA5ustb3fDWBlBt7zFT
         44FrnVMhPLJGViBdpbNUDDc7pVd2uKxUdzeKs=
From: Namhyung Kim <namhyung@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/3] compat: copy missing fields in compat_statfs64 to user
Date: Mon, 27 Dec 2010 01:41:54 +0900
Message-Id: <1293381714-5264-3-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.3.4.600.g982838b0
In-Reply-To: <1293381714-5264-1-git-send-email-namhyung@gmail.com>
References: <1293381714-5264-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

f_flags and f_spare fields were not copied to userspace when
compat_sys_[f]statfs64 called.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
---
It seems struct compat_statfs lacks the f_flags field in it but I'm not
sure whether it is intended or not. Is it useful if I make a patch for
it too?

 fs/compat.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index 037df434b038..2524511518e7 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -320,7 +320,9 @@ static int put_compat_statfs64(struct compat_statfs64 __user *ubuf, struct kstat
 	    __put_user(kbuf->f_namelen, &ubuf->f_namelen) ||
 	    __put_user(kbuf->f_fsid.val[0], &ubuf->f_fsid.val[0]) ||
 	    __put_user(kbuf->f_fsid.val[1], &ubuf->f_fsid.val[1]) ||
-	    __put_user(kbuf->f_frsize, &ubuf->f_frsize))
+	    __put_user(kbuf->f_frsize, &ubuf->f_frsize) ||
+	    __put_user(kbuf->f_flags, &ubuf->f_flags) ||
+	    __clear_user(ubuf->f_spare, sizeof(ubuf->f_spare)))
 		return -EFAULT;
 	return 0;
 }
-- 
1.7.3.4.600.g982838b0

