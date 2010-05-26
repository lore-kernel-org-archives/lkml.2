Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771Ab0EZIjk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 04:39:40 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:40459 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721Ab0EZIji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 04:39:38 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: uclinux-dev@uclinux.org, David Howells <dhowells@redhat.com>,
       David McCullough <davidm@snapgear.com>, Greg Ungerer <gerg@uclinux.org>,
       Paul Mundt <lethal@linux-sh.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] FLAT: fix unmap len in load error path
Date: Wed, 26 May 2010 04:43:41 -0400
Message-Id: <1274863421-14052-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The data chunk is mmaped with 'len' which remains unchanged, so use that
when unmapping in the error path rather than trying to recalculate (and
incorrectly so) the value used originally.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 fs/binfmt_flat.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
index 4959a0a..f7a4059 100644
--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -596,7 +596,7 @@ static int load_flat_file(struct linux_binprm * bprm,
 		if (IS_ERR_VALUE(result)) {
 			printk("Unable to read data+bss, errno %d\n", (int)-result);
 			do_munmap(current->mm, textpos, text_len);
-			do_munmap(current->mm, realdatastart, data_len + extra);
+			do_munmap(current->mm, realdatastart, len);
 			ret = result;
 			goto err;
 		}
-- 
1.7.1

