Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626Ab0IBFDW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 01:03:22 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44502 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab0IBFC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 01:02:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer:in-reply-to:references;
        b=iEHVwzQ7G3QFOJPcm1ARH4hzHjHoePSKN1y3HK6UN/38CXip87/gxn010cgjwdi8H8
         dYFHPbUHvwD8RqM9WfJYoYoVZbinkLp2kESuEwxIXEz/pZWXjStQZc6Vamd3W5nEIkJm
         QHJ1XvsPOHKyYFnjT6ZvbgfZh/QrHA8DcScZs=
From: Namhyung Kim <namhyung@gmail.com>
To: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4/5] kprobes: remove __dummy_buf
Date: Thu,  2 Sep 2010 14:02:37 +0900
Message-Id: <1283403758-3827-5-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1283403758-3827-1-git-send-email-namhyung@gmail.com>
References: <1283403758-3827-1-git-send-email-namhyung@gmail.com>
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

