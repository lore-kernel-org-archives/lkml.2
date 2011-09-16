Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab1IPG5p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 02:57:45 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:56892 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394Ab1IPG5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 02:57:42 -0400
From: Julia Lawall <julia@diku.dk>
To: Chris Zankel <chris@zankel.net>
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>, Arun Sharma <asharma@fb.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] arch/xtensa/kernel/process.c: take size of pointed value, not pointer
Date: Fri, 16 Sep 2011 08:57:35 +0200
Message-Id: <1316156255-19509-4-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Sizeof a pointer-typed expression returns the size of the pointer, not that
of the pointed data.

The semantic patch that fixes this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression *e;
type T;
identifier f;
@@

f(...,(T)e,...,
-sizeof(e)
+sizeof(*e)
,...)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 arch/xtensa/kernel/process.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/arch/xtensa/kernel/process.c b/arch/xtensa/kernel/process.c
--- a/arch/xtensa/kernel/process.c
+++ b/arch/xtensa/kernel/process.c
@@ -277,7 +277,7 @@ void xtensa_elf_core_copy_regs (xtensa_g
 
 	/* Don't leak any random bits. */
 
-	memset(elfregs, 0, sizeof (elfregs));
+	memset(elfregs, 0, sizeof(*elfregs));
 
 	/* Note:  PS.EXCM is not set while user task is running; its
 	 * being set in regs->ps is for exception handling convenience.

