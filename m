Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763Ab1ERUpO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 16:45:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:58613 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752379Ab1ERUpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 16:45:11 -0400
Date: Wed, 18 May 2011 20:44:47 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Message-ID: <tip-c5d41xibgullk8h2280q4gv0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf bench, x86: Add alternatives-asm.h wrapper
Git-Commit-ID: b313207286a78abac19f1dd2721292eae598b0f5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 18 May 2011 20:44:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b313207286a78abac19f1dd2721292eae598b0f5
Gitweb:     http://git.kernel.org/tip/b313207286a78abac19f1dd2721292eae598b0f5
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 18 May 2011 21:00:44 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 18 May 2011 21:00:44 +0200

perf bench, x86: Add alternatives-asm.h wrapper

perf bench needs this to build the kernel's memcpy routine:

In file included from bench/mem-memcpy-x86-64-asm.S:2:0:
bench/../../../arch/x86/lib/memcpy_64.S:7:33: fatal error: asm/alternative-asm.h: No such file or directory

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/n/tip-c5d41xibgullk8h2280q4gv0@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/include/asm/alternative-asm.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/include/asm/alternative-asm.h b/tools/perf/util/include/asm/alternative-asm.h
new file mode 100644
index 0000000..6789d78
--- /dev/null
+++ b/tools/perf/util/include/asm/alternative-asm.h
@@ -0,0 +1,8 @@
+#ifndef _PERF_ASM_ALTERNATIVE_ASM_H
+#define _PERF_ASM_ALTERNATIVE_ASM_H
+
+/* Just disable it so we can build arch/x86/lib/memcpy_64.S for perf bench: */
+
+#define altinstruction_entry #
+
+#endif
