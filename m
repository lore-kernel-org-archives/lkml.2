Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933651Ab1CXH6g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 03:58:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:40842 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933612Ab1CXH6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 03:58:35 -0400
Date: Thu, 24 Mar 2011 07:58:17 GMT
From: tip-bot for Namhyung Kim <namhyung@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, namhyung@gmail.com, fweisbec@gmail.com,
        rostedt@goodmis.org, akpm@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, namhyung@gmail.com, fweisbec@gmail.com,
        rostedt@goodmis.org, akpm@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1300934550-21394-2-git-send-email-namhyung@gmail.com>
References: <1300934550-21394-2-git-send-email-namhyung@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] x86, dumpstack: Use %pB format specifier for stack trace
Message-ID: <tip-71f9e59800e5ad4e6b683348424c9fe54306cd43@git.kernel.org>
Git-Commit-ID: 71f9e59800e5ad4e6b683348424c9fe54306cd43
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 24 Mar 2011 07:58:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  71f9e59800e5ad4e6b683348424c9fe54306cd43
Gitweb:     http://git.kernel.org/tip/71f9e59800e5ad4e6b683348424c9fe54306cd43
Author:     Namhyung Kim <namhyung@gmail.com>
AuthorDate: Thu, 24 Mar 2011 11:42:30 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 24 Mar 2011 08:36:10 +0100

x86, dumpstack: Use %pB format specifier for stack trace

Improve noreturn function entries in call traces:

Before:

 Call Trace:
  [<ffffffff812a8502>] panic+0x8c/0x18d
  [<ffffffffa000012a>] deep01+0x0/0x38 [test_panic]  <--- bad
  [<ffffffff81104666>] proc_file_write+0x73/0x8d
  [<ffffffff811000b3>] proc_reg_write+0x8d/0xac
  [<ffffffff810c7d32>] vfs_write+0xa1/0xc5
  [<ffffffff810c7e0f>] sys_write+0x45/0x6c
  [<ffffffff8f02943b>] system_call_fastpath+0x16/0x1b

After:

 Call Trace:
  [<ffffffff812bce69>] panic+0x8c/0x18d
  [<ffffffffa000012a>] panic_write+0x20/0x20 [test_panic] <--- good
  [<ffffffff81115fab>] proc_file_write+0x73/0x8d
  [<ffffffff81111a5f>] proc_reg_write+0x8d/0xac
  [<ffffffff810d90ee>] vfs_write+0xa1/0xc5
  [<ffffffff810d91cb>] sys_write+0x45/0x6c
  [<ffffffff812c07fb>] system_call_fastpath+0x16/0x1b

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <1300934550-21394-2-git-send-email-namhyung@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/dumpstack.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 999e279..24d0479 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -27,7 +27,7 @@ static int die_counter;
 
 void printk_address(unsigned long address, int reliable)
 {
-	printk(" [<%p>] %s%pS\n", (void *) address,
+	printk(" [<%p>] %s%pB\n", (void *) address,
 			reliable ? "" : "? ", (void *) address);
 }
 
