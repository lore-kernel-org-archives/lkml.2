Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456Ab1LER6U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 12:58:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58965 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755171Ab1LER6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 12:58:18 -0500
Date: Mon, 5 Dec 2011 09:57:53 -0800
From: tip-bot for Daniel J Blueman <daniel@numascale-asia.com>
Message-ID: <tip-9a0ebfbe3f1007008d198ccc6b86783cdb312fec@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        sp@numascale.com, jbarnes@virtuousgeek.org, tglx@linutronix.de,
        daniel@numascale-asia.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        sp@numascale.com, jbarnes@virtuousgeek.org, tglx@linutronix.de,
        daniel@numascale-asia.com, mingo@elte.hu
In-Reply-To: <1323073238-32686-1-git-send-email-daniel@numascale-asia.com>
References: <1323073238-32686-1-git-send-email-daniel@numascale-asia.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86: Make flat_init_apic_ldr() available
Git-Commit-ID: 9a0ebfbe3f1007008d198ccc6b86783cdb312fec
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 09:57:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9a0ebfbe3f1007008d198ccc6b86783cdb312fec
Gitweb:     http://git.kernel.org/tip/9a0ebfbe3f1007008d198ccc6b86783cdb312fec
Author:     Daniel J Blueman <daniel@numascale-asia.com>
AuthorDate: Mon, 5 Dec 2011 16:20:36 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 5 Dec 2011 17:17:07 +0100

x86: Make flat_init_apic_ldr() available

Allow flat_init_apic_ldr() to be used outside the compilation
unit for similar APIC implementations.

Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
Cc: Steffen Persvold <sp@numascale.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Link: http://lkml.kernel.org/r/1323073238-32686-1-git-send-email-daniel@numascale-asia.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/apic_flat_64.h |    7 +++++++
 arch/x86/kernel/apic/apic_flat_64.c |    2 +-
 2 files changed, 8 insertions(+), 1 deletions(-)

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
