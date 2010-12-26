Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390Ab0LZQmh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Dec 2010 11:42:37 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:46309 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294Ab0LZQmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Dec 2010 11:42:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ZNpOSnUiiblznBlMs8y1ZXSHoji9ndEx3hIgchLBKFnt+vtQsElgYq9Flrof6KnJ5g
         +jG9vg2Gnc5ECV+DQBQvuGDKOyjMquapk4t6mO6zocikgvwSK1Sx2bH8j0Zq2DZE+mFc
         ddxwu2aNN8b3TkH8c5shpgSniwo/4ICobsSX8=
From: Namhyung Kim <namhyung@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 1/3] compat: remove unnecessary assignment in compat_rw_copy_check_uvector()
Date: Mon, 27 Dec 2010 01:41:52 +0900
Message-Id: <1293381714-5264-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.3.4.600.g982838b0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

*@ret_pointer is initialized to @fast_pointer thus the assignment is
redundant.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
---
 fs/compat.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index b074e9f79148..0a22f973f4b5 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -597,10 +597,8 @@ ssize_t compat_rw_copy_check_uvector(int type,
 	if (nr_segs > fast_segs) {
 		ret = -ENOMEM;
 		iov = kmalloc(nr_segs*sizeof(struct iovec), GFP_KERNEL);
-		if (iov == NULL) {
-			*ret_pointer = fast_pointer;
+		if (iov == NULL)
 			goto out;
-		}
 	}
 	*ret_pointer = iov;
 
-- 
1.7.3.4.600.g982838b0

