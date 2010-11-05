Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129Ab0KEXMq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 19:12:46 -0400
Received: from mail.perches.com ([173.55.12.10]:4352 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754058Ab0KEXMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 19:12:42 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] arch/arm/kernel/traps.c: Convert sprintf_symbol to %pS
Date: Fri,  5 Nov 2010 16:12:34 -0700
Message-Id: <1288998760-11775-2-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1288998760-11775-1-git-send-email-joe@perches.com>
References: <1288998760-11775-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/arm/kernel/traps.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index cda78d5..446aee9 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -53,10 +53,7 @@ static void dump_mem(const char *, const char *, unsigned long, unsigned long);
 void dump_backtrace_entry(unsigned long where, unsigned long from, unsigned long frame)
 {
 #ifdef CONFIG_KALLSYMS
-	char sym1[KSYM_SYMBOL_LEN], sym2[KSYM_SYMBOL_LEN];
-	sprint_symbol(sym1, where);
-	sprint_symbol(sym2, from);
-	printk("[<%08lx>] (%s) from [<%08lx>] (%s)\n", where, sym1, from, sym2);
+	printk("[<%08lx>] (%pS) from [<%08lx>] (%pS)\n", where, (void *)where, from, (void *)from);
 #else
 	printk("Function entered at [<%08lx>] from [<%08lx>]\n", where, from);
 #endif
-- 
1.7.3.2.146.gca209

