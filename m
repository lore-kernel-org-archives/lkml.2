Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab0IOKFp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 06:05:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:40042 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753309Ab0IOKFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 06:05:43 -0400
Date: Wed, 15 Sep 2010 10:05:17 GMT
From: tip-bot for Namhyung Kim <namhyung@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de,
        namhyung@gmail.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de,
        namhyung@gmail.com, mingo@elte.hu
In-Reply-To: <1284512670-2369-5-git-send-email-namhyung@gmail.com>
References: <1284512670-2369-5-git-send-email-namhyung@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] kprobes: Remove __dummy_buf
Message-ID: <tip-6abded71d730322df96c5b7f4ab952ffd5a0080d@git.kernel.org>
Git-Commit-ID: 6abded71d730322df96c5b7f4ab952ffd5a0080d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 15 Sep 2010 10:05:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6abded71d730322df96c5b7f4ab952ffd5a0080d
Gitweb:     http://git.kernel.org/tip/6abded71d730322df96c5b7f4ab952ffd5a0080d
Author:     Namhyung Kim <namhyung@gmail.com>
AuthorDate: Wed, 15 Sep 2010 10:04:29 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 15 Sep 2010 10:44:02 +0200

kprobes: Remove __dummy_buf

Remove __dummy_buf which is needed for kallsyms_lookup only.
use kallsysm_lookup_size_offset instead.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
LKML-Reference: <1284512670-2369-5-git-send-email-namhyung@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/kprobes.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 05c20a4..e05952a 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -230,9 +230,6 @@ static int recover_probed_instruction(kprobe_opcode_t *buf, unsigned long addr)
 	return 0;
 }
 
-/* Dummy buffers for kallsyms_lookup */
-static char __dummy_buf[KSYM_NAME_LEN];
-
 /* Check if paddr is at an instruction boundary */
 static int __kprobes can_probe(unsigned long paddr)
 {
@@ -241,7 +238,7 @@ static int __kprobes can_probe(unsigned long paddr)
 	struct insn insn;
 	kprobe_opcode_t buf[MAX_INSN_SIZE];
 
-	if (!kallsyms_lookup(paddr, NULL, &offset, NULL, __dummy_buf))
+	if (!kallsyms_lookup_size_offset(paddr, NULL, &offset))
 		return 0;
 
 	/* Decode instructions */
@@ -1269,11 +1266,9 @@ static int __kprobes can_optimize(unsigned long paddr)
 	unsigned long addr, size = 0, offset = 0;
 	struct insn insn;
 	kprobe_opcode_t buf[MAX_INSN_SIZE];
-	/* Dummy buffers for lookup_symbol_attrs */
-	static char __dummy_buf[KSYM_NAME_LEN];
 
 	/* Lookup symbol including addr */
-	if (!kallsyms_lookup(paddr, &size, &offset, NULL, __dummy_buf))
+	if (!kallsyms_lookup_size_offset(paddr, &size, &offset))
 		return 0;
 
 	/* Check there is enough space for a relative jump. */
