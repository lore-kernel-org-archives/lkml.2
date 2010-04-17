Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589Ab0DQTNV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 15:13:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:35224 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753829Ab0DQTNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 15:13:20 -0400
Date: Sat, 17 Apr 2010 19:12:47 GMT
From: tip-bot for Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       travis@sgi.com, holt@sgi.com, cpw@sgi.com, sivanich@sgi.com,
       randy.dunlap@oracle.com, rja@sgi.com, steiner@sgi.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       travis@sgi.com, holt@sgi.com, cpw@sgi.com, randy.dunlap@oracle.com,
       sivanich@sgi.com, rja@sgi.com, steiner@sgi.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20100416175142.f4b59683.randy.dunlap@oracle.com>
References: <20100416175142.f4b59683.randy.dunlap@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/uv] x86, UV: uv_irq.c: Fix all sparse warnings
Message-ID: <tip-a289cc7c70da784a2d370b91885cab4f966dcb0f@git.kernel.org>
Git-Commit-ID: a289cc7c70da784a2d370b91885cab4f966dcb0f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 17 Apr 2010 19:12:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a289cc7c70da784a2d370b91885cab4f966dcb0f
Gitweb:     http://git.kernel.org/tip/a289cc7c70da784a2d370b91885cab4f966dcb0f
Author:     Randy Dunlap <randy.dunlap@oracle.com>
AuthorDate: Fri, 16 Apr 2010 17:51:42 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 17 Apr 2010 10:37:20 +0200

x86, UV: uv_irq.c: Fix all sparse warnings

Fix all sparse warnings in building uv_irq.c.

 arch/x86/kernel/uv_irq.c:46:17: warning: symbol 'uv_irq_chip' was not declared. Should it be static?
 arch/x86/kernel/uv_irq.c:143:50: error: no identifier for function argument
 arch/x86/kernel/uv_irq.c:162:13: error: typename in expression
 arch/x86/kernel/uv_irq.c:162:13: error: undefined identifier 'restrict'
 arch/x86/kernel/uv_irq.c:250:44: error: no identifier for function argument
 arch/x86/kernel/uv_irq.c:260:17: error: typename in expression
 arch/x86/kernel/uv_irq.c:260:17: error: undefined identifier 'restrict'
 arch/x86/kernel/uv_irq.c:233:50: warning: incorrect type in argument 3 (different signedness)
 arch/x86/kernel/uv_irq.c:233:50:    expected int *pnode
 arch/x86/kernel/uv_irq.c:233:50:    got unsigned int *<noident>
 arch/x86/include/asm/uv/uv_hub.h:318:44: warning: incorrect type in argument 2 (different address spaces)
 arch/x86/include/asm/uv/uv_hub.h:318:44:    expected void volatile [noderef] <asn:2>*addr
 arch/x86/include/asm/uv/uv_hub.h:318:44:    got unsigned long *

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Dimitri Sivanich <sivanich@sgi.com>
Cc: Russ Anderson <rja@sgi.com>
Cc: Robin Holt <holt@sgi.com>
Cc: Mike Travis <travis@sgi.com>
Cc: Cliff Wickman <cpw@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>
LKML-Reference: <20100416175142.f4b59683.randy.dunlap@oracle.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/uv/uv_hub.h |    2 +-
 arch/x86/kernel/uv_irq.c         |   12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/uv/uv_hub.h b/arch/x86/include/asm/uv/uv_hub.h
index 14cc74b..bf6b88e 100644
--- a/arch/x86/include/asm/uv/uv_hub.h
+++ b/arch/x86/include/asm/uv/uv_hub.h
@@ -307,7 +307,7 @@ static inline unsigned long uv_read_global_mmr32(int pnode, unsigned long offset
  * Access Global MMR space using the MMR space located at the top of physical
  * memory.
  */
-static inline unsigned long *uv_global_mmr64_address(int pnode, unsigned long offset)
+static inline volatile void __iomem *uv_global_mmr64_address(int pnode, unsigned long offset)
 {
 	return __va(UV_GLOBAL_MMR64_BASE |
 		    UV_GLOBAL_MMR64_PNODE_BITS(pnode) | offset);
diff --git a/arch/x86/kernel/uv_irq.c b/arch/x86/kernel/uv_irq.c
index ece73d8..1a9f55a 100644
--- a/arch/x86/kernel/uv_irq.c
+++ b/arch/x86/kernel/uv_irq.c
@@ -43,7 +43,7 @@ static void uv_ack_apic(unsigned int irq)
 	ack_APIC_irq();
 }
 
-struct irq_chip uv_irq_chip = {
+static struct irq_chip uv_irq_chip = {
 	.name		= "UV-CORE",
 	.startup	= uv_noop_ret,
 	.shutdown	= uv_noop,
@@ -140,7 +140,7 @@ int uv_irq_2_mmr_info(int irq, unsigned long *offset, int *pnode)
  */
 static int
 arch_enable_uv_irq(char *irq_name, unsigned int irq, int cpu, int mmr_blade,
-		       unsigned long mmr_offset, int restrict)
+		       unsigned long mmr_offset, int limit)
 {
 	const struct cpumask *eligible_cpu = cpumask_of(cpu);
 	struct irq_desc *desc = irq_to_desc(irq);
@@ -159,7 +159,7 @@ arch_enable_uv_irq(char *irq_name, unsigned int irq, int cpu, int mmr_blade,
 	if (err != 0)
 		return err;
 
-	if (restrict == UV_AFFINITY_CPU)
+	if (limit == UV_AFFINITY_CPU)
 		desc->status |= IRQ_NO_BALANCING;
 	else
 		desc->status |= IRQ_MOVE_PCNTXT;
@@ -213,7 +213,7 @@ static int uv_set_irq_affinity(unsigned int irq, const struct cpumask *mask)
 	unsigned long mmr_value;
 	struct uv_IO_APIC_route_entry *entry;
 	unsigned long mmr_offset;
-	unsigned mmr_pnode;
+	int mmr_pnode;
 
 	if (set_desc_affinity(desc, mask, &dest))
 		return -1;
@@ -247,7 +247,7 @@ static int uv_set_irq_affinity(unsigned int irq, const struct cpumask *mask)
  * interrupt is raised.
  */
 int uv_setup_irq(char *irq_name, int cpu, int mmr_blade,
-		 unsigned long mmr_offset, int restrict)
+		 unsigned long mmr_offset, int limit)
 {
 	int irq, ret;
 
@@ -257,7 +257,7 @@ int uv_setup_irq(char *irq_name, int cpu, int mmr_blade,
 		return -EBUSY;
 
 	ret = arch_enable_uv_irq(irq_name, irq, cpu, mmr_blade, mmr_offset,
-		restrict);
+		limit);
 	if (ret == irq)
 		uv_set_irq_2_mmr_info(irq, mmr_offset, mmr_blade);
 	else
