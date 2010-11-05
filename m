Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab0KEXNg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 19:13:36 -0400
Received: from mail.perches.com ([173.55.12.10]:4357 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755074Ab0KEXMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 19:12:43 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] arch/x86/kernel/pci-iommu_table.c: Convert sprintf_symbol to %pS
Date: Fri,  5 Nov 2010 16:12:35 -0700
Message-Id: <1288998760-11775-3-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1288998760-11775-1-git-send-email-joe@perches.com>
References: <1288998760-11775-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Coalesce format as well.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/x86/kernel/pci-iommu_table.c |   18 ++++--------------
 1 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/pci-iommu_table.c b/arch/x86/kernel/pci-iommu_table.c
index 55d745e..35ccf75 100644
--- a/arch/x86/kernel/pci-iommu_table.c
+++ b/arch/x86/kernel/pci-iommu_table.c
@@ -50,20 +50,14 @@ void __init check_iommu_entries(struct iommu_table_entry *start,
 				struct iommu_table_entry *finish)
 {
 	struct iommu_table_entry *p, *q, *x;
-	char sym_p[KSYM_SYMBOL_LEN];
-	char sym_q[KSYM_SYMBOL_LEN];
 
 	/* Simple cyclic dependency checker. */
 	for (p = start; p < finish; p++) {
 		q = find_dependents_of(start, finish, p);
 		x = find_dependents_of(start, finish, q);
 		if (p == x) {
-			sprint_symbol(sym_p, (unsigned long)p->detect);
-			sprint_symbol(sym_q, (unsigned long)q->detect);
-
-			printk(KERN_ERR "CYCLIC DEPENDENCY FOUND! %s depends" \
-					" on %s and vice-versa. BREAKING IT.\n",
-					sym_p, sym_q);
+			printk(KERN_ERR "CYCLIC DEPENDENCY FOUND! %pS depends on %pS and vice-versa. BREAKING IT.\n",
+			       p->detect, q->detect);
 			/* Heavy handed way..*/
 			x->depend = 0;
 		}
@@ -72,12 +66,8 @@ void __init check_iommu_entries(struct iommu_table_entry *start,
 	for (p = start; p < finish; p++) {
 		q = find_dependents_of(p, finish, p);
 		if (q && q > p) {
-			sprint_symbol(sym_p, (unsigned long)p->detect);
-			sprint_symbol(sym_q, (unsigned long)q->detect);
-
-			printk(KERN_ERR "EXECUTION ORDER INVALID! %s "\
-					"should be called before %s!\n",
-					sym_p, sym_q);
+			printk(KERN_ERR "EXECUTION ORDER INVALID! %pS should be called before %pS!\n",
+			       p->detect, q->detect);
 		}
 	}
 }
-- 
1.7.3.2.146.gca209

