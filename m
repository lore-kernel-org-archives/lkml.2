Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735Ab0IOKEn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 06:04:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:39958 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429Ab0IOKEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 06:04:41 -0400
Date: Wed, 15 Sep 2010 10:04:11 GMT
From: tip-bot for Namhyung Kim <namhyung@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de,
        namhyung@gmail.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de,
        namhyung@gmail.com, mingo@elte.hu
In-Reply-To: <1284512670-2369-2-git-send-email-namhyung@gmail.com>
References: <1284512670-2369-2-git-send-email-namhyung@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] kprobes: Remove redundant address check
Message-ID: <tip-edbaadbe42b0b790618ec49d29626223529d8195@git.kernel.org>
Git-Commit-ID: edbaadbe42b0b790618ec49d29626223529d8195
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 15 Sep 2010 10:04:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  edbaadbe42b0b790618ec49d29626223529d8195
Gitweb:     http://git.kernel.org/tip/edbaadbe42b0b790618ec49d29626223529d8195
Author:     Namhyung Kim <namhyung@gmail.com>
AuthorDate: Wed, 15 Sep 2010 10:04:26 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 15 Sep 2010 10:44:00 +0200

kprobes: Remove redundant address check

Remove call to kernel_text_address() in register_jprobes()
because it is called right after in register_kprobe().

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
LKML-Reference: <1284512670-2369-2-git-send-email-namhyung@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/kprobes.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 282035f..8f96701 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1343,14 +1343,11 @@ int __kprobes register_jprobes(struct jprobe **jps, int num)
 		jp = jps[i];
 		addr = arch_deref_entry_point(jp->entry);
 
-		if (!kernel_text_address(addr))
-			ret = -EINVAL;
-		else {
-			/* Todo: Verify probepoint is a function entry point */
-			jp->kp.pre_handler = setjmp_pre_handler;
-			jp->kp.break_handler = longjmp_break_handler;
-			ret = register_kprobe(&jp->kp);
-		}
+		/* Todo: Verify probepoint is a function entry point */
+		jp->kp.pre_handler = setjmp_pre_handler;
+		jp->kp.break_handler = longjmp_break_handler;
+		ret = register_kprobe(&jp->kp);
+
 		if (ret < 0) {
 			if (i > 0)
 				unregister_jprobes(jps, i);
