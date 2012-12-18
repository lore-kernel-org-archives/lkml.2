Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab2LRVdo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 16:33:44 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:55648 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203Ab2LRVdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 16:33:41 -0500
From: Cong Ding <dinggnu@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Jiri Kosina <jkosina@suse.cz>,
        Jesper Juhl <jj@codesealer.com>, linux-kernel@vger.kernel.org
Cc: Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] usr/gen_init_cpio.c: remove unnecessary "if"
Date: Tue, 18 Dec 2012 22:26:38 +0100
Message-Id: <1355866000-18295-1-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usr/gen_init_cpio.c: remove unnecessary "if"

if it goes to fail, dname isn't allocated; otherwise, it is allocated
successfully. so we just free memory when it doesn't fail.

this patch also fix a trival trailing space warning by checkpatch

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 usr/gen_init_cpio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/usr/gen_init_cpio.c b/usr/gen_init_cpio.c
index af8c925..afebe09 100644
--- a/usr/gen_init_cpio.c
+++ b/usr/gen_init_cpio.c
@@ -372,7 +372,7 @@ static int cpio_mkfile(const char *name, const char *location,
 	}
 	ino++;
 	rc = 0;
-	
+
 error:
 	if (filebuf) free(filebuf);
 	if (file >= 0) close(file);
@@ -452,8 +452,8 @@ static int cpio_mkfile_line(const char *line)
 	}
 	rc = cpio_mkfile(dname, cpio_replace_env(location),
 	                 mode, uid, gid, nlinks);
+	free(dname);
  fail:
-	if (dname_len) free(dname);
 	return rc;
 }
 
-- 
1.7.10.4

