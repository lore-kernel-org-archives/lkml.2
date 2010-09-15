Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab0IOBFH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 21:05:07 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:36702 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871Ab0IOBFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 21:05:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=nX0+smUYGxeUpefNIyKv4WOVdvU1/3t5C8UUgd9gpjS4g+FzMpCm78o9JIgWAv397d
         hlNGi0h9qnbYJYW5ZTxV1JYjqfpif5UmOuF+SzqDRfIhj98w+4L3pmlv6HUiiUKctfSj
         pC80wEZ5MFnnQRRg3gYrGZ6xowx0c+HrJTS2A=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] kprobes: remove __dummy_buf
Date: Wed, 15 Sep 2010 10:04:29 +0900
Message-Id: <1284512670-2369-5-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1284512670-2369-1-git-send-email-namhyung@gmail.com>
References: <1284512670-2369-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove __dummy_buf which is needed for kallsyms_lookup only.
use kallsysm_lookup_size_offset instead.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
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
-- 
1.7.2.2

