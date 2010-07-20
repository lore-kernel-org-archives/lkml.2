Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932647Ab0GTS7t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 14:59:49 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:59487 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932364Ab0GTS6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 14:58:16 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i2a8h87h43h64h)
X-Spam-TCS-SCL: 3:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L5VE0V-01-LM4-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 02/10] x86, xsave: 32/64 bit boot cpu check unification in initialization
Date: Tue, 20 Jul 2010 20:50:49 +0200
Message-ID: <1279651857-24639-3-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1279651857-24639-1-git-send-email-robert.richter@amd.com>
References: <1279651857-24639-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boot cpu id is always 0, thus simplifying and unifying boot cpu check.

boot_cpu_id is there for historical reasons and was renamed to
boot_cpu_physical_apicid in patch:

 c70dcb7 x86: change boot_cpu_id to boot_cpu_physical_apicid

However, there are some remaining occurrences of boot_cpu_id that are
never touched in the kernel and thus its value is always 0.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/common.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 3f715ef..26804b2 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1273,7 +1273,7 @@ void __cpuinit cpu_init(void)
 	/*
 	 * Boot processor to setup the FP and extended state context info.
 	 */
-	if (smp_processor_id() == boot_cpu_id)
+	if (!smp_processor_id())
 		init_thread_xstate();
 
 	xsave_init();
-- 
1.7.1.1


