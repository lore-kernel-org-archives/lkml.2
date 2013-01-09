Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758193Ab3AIXKv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 18:10:51 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:36331 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758100Ab3AIXKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 18:10:44 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, rostedt@goodmis.org,
        fweisbec@gmail.com, rusty@rustcorp.com.au, ananth@in.ibm.com,
        anil.s.keshavamurthy@intel.com, masami.hiramatsu.pt@hitachi.com,
        jbaron@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH 4/5] alternatives: constify alternatives_text_reserved
Date: Wed,  9 Jan 2013 18:09:19 -0500
Message-Id: <1357772960-4436-4-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1357772960-4436-1-git-send-email-sasha.levin@oracle.com>
References: <1357772960-4436-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 arch/x86/include/asm/alternative.h | 4 ++--
 arch/x86/kernel/alternative.c      | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index 58ed6d9..4d0d2fb 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -61,7 +61,7 @@ extern void alternatives_smp_module_add(struct module *mod, char *name,
 					void *text, void *text_end);
 extern void alternatives_smp_module_del(struct module *mod);
 extern void alternatives_enable_smp(void);
-extern int alternatives_text_reserved(void *start, void *end);
+extern int alternatives_text_reserved(const void *start, const void *end);
 extern bool skip_smp_alternatives;
 #else
 static inline void alternatives_smp_module_add(struct module *mod, char *name,
@@ -69,7 +69,7 @@ static inline void alternatives_smp_module_add(struct module *mod, char *name,
 					       void *text, void *text_end) {}
 static inline void alternatives_smp_module_del(struct module *mod) {}
 static inline void alternatives_enable_smp(void) {}
-static inline int alternatives_text_reserved(void *start, void *end)
+static inline int alternatives_text_reserved(const void *start, const void *end)
 {
 	return 0;
 }
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index ef5ccca..0994e41 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -431,12 +431,12 @@ void alternatives_enable_smp(void)
 }
 
 /* Return 1 if the address range is reserved for smp-alternatives */
-int alternatives_text_reserved(void *start, void *end)
+int alternatives_text_reserved(const void *start, const void *end)
 {
 	struct smp_alt_module *mod;
 	const s32 *poff;
-	u8 *text_start = start;
-	u8 *text_end = end;
+	const u8 *text_start = start;
+	const u8 *text_end = end;
 
 	list_for_each_entry(mod, &smp_alt_modules, next) {
 		if (mod->text > text_end || mod->text_end < text_start)
-- 
1.8.1

