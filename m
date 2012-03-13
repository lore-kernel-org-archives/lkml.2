Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758736Ab2CMAWn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:22:43 -0400
Received: from mail.windriver.com ([147.11.1.11]:47792 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758693Ab2CMAWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:22:39 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Boris Ostrovsky <boris.ostrovsky@amd.com>,
        Ingo Molnar <mingo@elte.hu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 067/196] x86, AMD: Set ARAT feature on AMD processors
Date: Mon, 12 Mar 2012 20:19:40 -0400
Message-Id: <1331598109-31424-22-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boris Ostrovsky <boris.ostrovsky@amd.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit b87cf80af3ba4b4c008b4face3c68d604e1715c6 upstream.

Support for Always Running APIC timer (ARAT) was introduced in
commit db954b5898dd3ef3ef93f4144158ea8f97deb058. This feature
allows us to avoid switching timers from LAPIC to something else
(e.g. HPET) and go into timer broadcasts when entering deep
C-states.

AMD processors don't provide a CPUID bit for that feature but
they also keep APIC timers running in deep C-states (except for
cases when the processor is affected by erratum 400). Therefore
we should set ARAT feature bit on AMD CPUs.

Tested-by: Borislav Petkov <borislav.petkov@amd.com>
Acked-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Acked-by: Mark Langsdorf <mark.langsdorf@amd.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@amd.com>
LKML-Reference: <1300205624-4813-1-git-send-email-ostr@amd64.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/kernel/cpu/amd.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 08dd1be..6f834f8 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -565,6 +565,10 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		}
 	}
 #endif
+
+	/* As a rule processors have APIC timer running in deep C states */
+	if (c->x86 >= 0xf && !cpu_has_amd_erratum(amd_erratum_400))
+		set_cpu_cap(c, X86_FEATURE_ARAT);
 }
 
 #ifdef CONFIG_X86_32
-- 
1.7.9.3

