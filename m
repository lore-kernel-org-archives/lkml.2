Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538Ab1E1N73 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 09:59:29 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:57248 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753447Ab1E1N71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 09:59:27 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: [PATCH] kgdbts: only use new asm-generic/ptrace.h api when needed
Date: Sat, 28 May 2011 10:04:25 -0400
Message-Id: <1306591465-9622-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.5.rc3
In-Reply-To: <20110527151135.cd6f758a.sfr@canb.auug.org.au>
References: <20110527151135.cd6f758a.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new instruction_pointer_set helper is defined for people who have
converted to asm-generic/ptrace.h, so don't use it generally unless
the arch needs it (in which case it has been converted).  This should
fix building of kgdb tests for arches not yet converted.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/misc/kgdbts.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/kgdbts.c b/drivers/misc/kgdbts.c
index b0c5631..8cebec5 100644
--- a/drivers/misc/kgdbts.c
+++ b/drivers/misc/kgdbts.c
@@ -304,7 +304,10 @@ static int check_and_rewind_pc(char *put_str, char *arg)
 		return 1;
 	}
 	/* Readjust the instruction pointer if needed */
-	instruction_pointer_set(&kgdbts_regs, ip + offset);
+	ip += offset;
+#ifdef GDB_ADJUSTS_BREAK_OFFSET
+	instruction_pointer_set(&kgdbts_regs, ip);
+#endif
 	return 0;
 }
 
-- 
1.7.5.rc3

