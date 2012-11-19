Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908Ab2KSF3F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:29:05 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:51549 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874Ab2KSF3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:29:02 -0500
X-Originating-IP: 217.70.178.151
X-Originating-IP: 50.43.39.152
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Alexander Gordeev <agordeev@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org
Cc: Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 05/58] x86: Only define default_init_apic_ldr for 32-bit
Date: Sun, 18 Nov 2012 21:27:44 -0800
Message-Id: <1353302917-13995-6-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

default_init_apic_ldr only exists for use in the 32-bit-only
arch/x86/kernel/apic/probe_32.c, and asm/apic.h prototypes it in an
ifdef CONFIG_X86_32 block, but arch/x86/kernel/apic/apic.c defines the
function unconditionally.  Wrap the definition in an ifdef CONFIG_X86_32
block.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 arch/x86/kernel/apic/apic.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 5a92aeb..bce0492 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -2113,6 +2113,7 @@ int hard_smp_processor_id(void)
 	return read_apic_id();
 }
 
+#ifdef CONFIG_X86_32
 void default_init_apic_ldr(void)
 {
 	unsigned long val;
@@ -2122,6 +2123,7 @@ void default_init_apic_ldr(void)
 	val |= SET_APIC_LOGICAL_ID(1UL << smp_processor_id());
 	apic_write(APIC_LDR, val);
 }
+#endif
 
 int default_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 				   const struct cpumask *andmask,
-- 
1.7.10.4

