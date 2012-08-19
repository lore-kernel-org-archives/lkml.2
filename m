Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017Ab2HSDBW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 23:01:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:36894 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753819Ab2HSC5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 22:57:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,792,1336374000"; 
   d="scan'208";a="182422057"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 24/74] lto: Mark do_exit asmlinkage
Date: Sat, 18 Aug 2012 19:56:20 -0700
Message-Id: <1345345030-22211-25-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

... since it can be called from assembler code

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/kernel.h |    2 +-
 kernel/exit.c          |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 6043821..73a1a54 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -209,7 +209,7 @@ extern void oops_enter(void);
 extern void oops_exit(void);
 void print_oops_end_marker(void);
 extern int oops_may_print(void);
-void do_exit(long error_code)
+asmlinkage void do_exit(long error_code)
 	__noreturn;
 void complete_and_exit(struct completion *, long)
 	__noreturn;
diff --git a/kernel/exit.c b/kernel/exit.c
index f65345f..7de9a3e 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -902,7 +902,7 @@ static void check_stack_usage(void)
 static inline void check_stack_usage(void) {}
 #endif
 
-void do_exit(long code)
+asmlinkage void do_exit(long code)
 {
 	struct task_struct *tsk = current;
 	int group_dead;
-- 
1.7.7.6

