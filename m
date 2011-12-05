Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664Ab1LEIUs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 03:20:48 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55975 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768Ab1LEIUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 03:20:46 -0500
From: Daniel J Blueman <daniel@numascale-asia.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steffen Persvold <sp@numascale.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Daniel J Blueman <daniel@numascale-asia.com>
Subject: [PATCH 1/3] Make flat_init_apic_ldr available
Date: Mon,  5 Dec 2011 16:20:36 +0800
Message-Id: <1323073238-32686-1-git-send-email-daniel@numascale-asia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <4ED9199A.3060108@numascale-asia.com>
References: <4ED9199A.3060108@numascale-asia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow flat_init_apic_ldr() to be used outside the compilation unit for
similar APIC implementations.

Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
---
 arch/x86/include/asm/apic_flat_64.h |    7 +++++++
 arch/x86/kernel/apic/apic_flat_64.c |    2 +-
 2 files changed, 8 insertions(+), 1 deletions(-)
 create mode 100644 arch/x86/include/asm/apic_flat_64.h

diff --git a/arch/x86/include/asm/apic_flat_64.h b/arch/x86/include/asm/apic_flat_64.h
new file mode 100644
index 0000000..a2d3127
--- /dev/null
+++ b/arch/x86/include/asm/apic_flat_64.h
@@ -0,0 +1,7 @@
+#ifndef _ASM_X86_APIC_FLAT_64_H
+#define _ASM_X86_APIC_FLAT_64_H
+
+extern void flat_init_apic_ldr(void);
+
+#endif
+
diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index f7a41e4..57c1f41 100644
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -62,7 +62,7 @@ static void flat_vector_allocation_domain(int cpu, struct cpumask *retmask)
  * an APIC.  See e.g. "AP-388 82489DX User's Manual" (Intel
  * document number 292116).  So here it goes...
  */
-static void flat_init_apic_ldr(void)
+void flat_init_apic_ldr(void)
 {
 	unsigned long val;
 	unsigned long num, id;
-- 
1.7.5.4

