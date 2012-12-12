Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274Ab2LLSVU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 13:21:20 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:57415 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754914Ab2LLSVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 13:21:16 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>, Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        cbe-oss-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [TRIVIAL PATCH 11/26] powerpc: Convert print_symbol to %pSR
Date: Wed, 12 Dec 2012 10:19:00 -0800
Message-Id: <8c901014a0f571011023ed98b9a22bc690925b73.1355335228.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.112.g3fd21
In-Reply-To: <cover.1355335227.git.joe@perches.com>
References: <cover.1355335227.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new vsprintf extension to avoid any possible
message interleaving.

Convert the #ifdef DEBUG block to a single pr_debug.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/powerpc/platforms/cell/spu_callbacks.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/platforms/cell/spu_callbacks.c b/arch/powerpc/platforms/cell/spu_callbacks.c
index 75d6133..c5fe6d2 100644
--- a/arch/powerpc/platforms/cell/spu_callbacks.c
+++ b/arch/powerpc/platforms/cell/spu_callbacks.c
@@ -60,13 +60,11 @@ long spu_sys_callback(struct spu_syscall_block *s)
 
 	syscall = spu_syscall_table[s->nr_ret];
 
-#ifdef DEBUG
-	print_symbol(KERN_DEBUG "SPU-syscall %s:", (unsigned long)syscall);
-	printk("syscall%ld(%lx, %lx, %lx, %lx, %lx, %lx)\n",
-			s->nr_ret,
-			s->parm[0], s->parm[1], s->parm[2],
-			s->parm[3], s->parm[4], s->parm[5]);
-#endif
+	pr_debug("SPU-syscall %pSR:syscall%ld(%lx, %lx, %lx, %lx, %lx, %lx)\n",
+		 syscall,
+		 s->nr_ret,
+		 s->parm[0], s->parm[1], s->parm[2],
+		 s->parm[3], s->parm[4], s->parm[5]);
 
 	return syscall(s->parm[0], s->parm[1], s->parm[2],
 		       s->parm[3], s->parm[4], s->parm[5]);
-- 
1.7.8.112.g3fd21

