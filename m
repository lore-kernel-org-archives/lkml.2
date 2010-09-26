Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758077Ab0IZS3Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 14:29:16 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50382 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757177Ab0IZS3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 14:29:13 -0400
Date: Sun, 26 Sep 2010 19:29:12 +0100
To: linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] mn10300: check __get_user/__put_user results...
Cc: dhowells@redhat.com, torvalds@linux-foundation.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1OzvyK-0002qC-AS@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/mn10300/kernel/signal.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/mn10300/kernel/signal.c b/arch/mn10300/kernel/signal.c
index ae36480..d4de05a 100644
--- a/arch/mn10300/kernel/signal.c
+++ b/arch/mn10300/kernel/signal.c
@@ -65,10 +65,10 @@ asmlinkage long sys_sigaction(int sig,
 		old_sigset_t mask;
 		if (verify_area(VERIFY_READ, act, sizeof(*act)) ||
 		    __get_user(new_ka.sa.sa_handler, &act->sa_handler) ||
-		    __get_user(new_ka.sa.sa_restorer, &act->sa_restorer))
+		    __get_user(new_ka.sa.sa_restorer, &act->sa_restorer) ||
+		    __get_user(new_ka.sa.sa_flags, &act->sa_flags) ||
+		    __get_user(mask, &act->sa_mask))
 			return -EFAULT;
-		__get_user(new_ka.sa.sa_flags, &act->sa_flags);
-		__get_user(mask, &act->sa_mask);
 		siginitset(&new_ka.sa.sa_mask, mask);
 	}
 
@@ -77,10 +77,10 @@ asmlinkage long sys_sigaction(int sig,
 	if (!ret && oact) {
 		if (verify_area(VERIFY_WRITE, oact, sizeof(*oact)) ||
 		    __put_user(old_ka.sa.sa_handler, &oact->sa_handler) ||
-		    __put_user(old_ka.sa.sa_restorer, &oact->sa_restorer))
+		    __put_user(old_ka.sa.sa_restorer, &oact->sa_restorer) ||
+		    __put_user(old_ka.sa.sa_flags, &oact->sa_flags) ||
+		    __put_user(old_ka.sa.sa_mask.sig[0], &oact->sa_mask))
 			return -EFAULT;
-		__put_user(old_ka.sa.sa_flags, &oact->sa_flags);
-		__put_user(old_ka.sa.sa_mask.sig[0], &oact->sa_mask);
 	}
 
 	return ret;
-- 
1.5.6.5

