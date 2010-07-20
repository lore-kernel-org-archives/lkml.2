Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932415Ab0GTS6R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 14:58:17 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:59395 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761430Ab0GTS6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 14:58:14 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i87h2a8h43h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L5VE0W-02-35T-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 07/10] x86, xsave: reduce cpu_has_xsave checks
Date: Tue, 20 Jul 2010 20:50:54 +0200
Message-ID: <1279651857-24639-8-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1279651857-24639-1-git-send-email-robert.richter@amd.com>
References: <1279651857-24639-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This moves the cpu_has_xsave check at the beginning of
xsave_init(). All other checks may removed then.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/xsave.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index a594f49..550bf45 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -362,9 +362,6 @@ unsigned int sig_xstate_size = sizeof(struct _fpstate);
  */
 static void __cpuinit __xsave_init(void)
 {
-	if (!cpu_has_xsave)
-		return;
-
 	set_in_cr4(X86_CR4_OSXSAVE);
 
 	/*
@@ -433,9 +430,6 @@ static void __cpuinit xsave_cntxt_init(void)
 {
 	unsigned int eax, ebx, ecx, edx;
 
-	if (!cpu_has_xsave)
-		return;
-
 	cpuid_count(0xd, 0, &eax, &ebx, &ecx, &edx);
 	pcntxt_mask = eax + ((u64)edx << 32);
 
@@ -469,6 +463,9 @@ static void __cpuinit xsave_cntxt_init(void)
 
 void __cpuinit xsave_init(void)
 {
+	if (!cpu_has_xsave)
+		return;
+
 	/*
 	 * Boot processor to setup the FP and extended state context info.
 	 */
-- 
1.7.1.1


