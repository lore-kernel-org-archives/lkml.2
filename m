Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932618Ab1DMQLY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:11:24 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:33646 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932194Ab1DMQLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:11:21 -0400
From: Frank Arnold <farnold@amd64.org>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: Clean up mwait_play_dead
Date: Wed, 13 Apr 2011 18:11:13 +0200
Message-Id: <1302711073-31985-1-git-send-email-farnold@amd64.org>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frank Arnold <frank.arnold@amd.com>

Commit 93789b32dbf355e70f18b17a82e8661677a7f7fb introduced
cpuinfo_x86 *c for brevity. It is used to check for the
mwait feature flag. The same can be done with a subsequent
check for clflsh and save us a second per-cpu pointer
dereference.

Signed-off-by: Frank Arnold <frank.arnold@amd.com>
Acked-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/smpboot.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index c2871d3..93a0066 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1334,7 +1334,7 @@ static inline void mwait_play_dead(void)
 
 	if (!(cpu_has(c, X86_FEATURE_MWAIT) && mwait_usable(c)))
 		return;
-	if (!cpu_has(__this_cpu_ptr(&cpu_info), X86_FEATURE_CLFLSH))
+	if (!cpu_has(c, X86_FEATURE_CLFLSH))
 		return;
 	if (__this_cpu_read(cpu_info.cpuid_level) < CPUID_MWAIT_LEAF)
 		return;
-- 
1.7.3.4

