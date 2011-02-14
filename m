Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab1BNKAq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 05:00:46 -0500
Received: from server103.greatnet.de ([83.133.97.6]:38350 "EHLO
	server103.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab1BNKAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 05:00:25 -0500
From: Henrik Kretzschmar <henne@nachtwindheim.de>
To: mingo@readhat.com
Cc: tglx@linutronix.de, hpa@zytor.com, x86@kernel.org, tj@kernel.org,
        yinghai@kernel.org, ak@linux.intel.com, robert.richter@amd.com,
        linux-kernel@vger.kernel.org, henne@nachtwindheim.de
Subject: [PATCH 5/6] x86: ifdef ioapic related function out
Date: Mon, 14 Feb 2011 11:00:11 +0100
Message-Id: <1297677612-12405-5-git-send-email-henne@nachtwindheim.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297677612-12405-1-git-send-email-henne@nachtwindheim.de>
References: <1297677612-12405-1-git-send-email-henne@nachtwindheim.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch_disable_smp_config() is an IO-APIC related function on x86,
and should only be needed if SMP is enabled.
But the IO-APIC code calls it when the parameter "noapic" is given to
the kernel, which doesn't mean SMP is enabled.

Anyway this fixes compilation on x86_32 UP systems with APIC and no IO-APIC.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
---
 arch/x86/kernel/apic/apic.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 999c531..4998f0a 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1218,7 +1218,9 @@ void __cpuinit setup_local_APIC(void)
 		rdtscll(tsc);
 
 	if (disable_apic) {
+#ifdef CONFIG_X86_IO_APIC
 		arch_disable_smp_support();
+#endif
 		return;
 	}
 
-- 
1.7.2.3

