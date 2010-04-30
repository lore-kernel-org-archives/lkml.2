Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758902Ab0EABFL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 21:05:11 -0400
Received: from mx7.orcon.net.nz ([219.88.242.57]:38721 "EHLO mx7.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758270Ab0EABFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 21:05:06 -0400
From: Michael Cree <mcree@orcon.net.nz>
To: linux-kernel@vger.kernel.org
Cc: Michael Cree <mcree@orcon.net.nz>, Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Matt Turner <mattst88@gmail.com>, linux-alpha@vger.kernel.org
Subject: [PATCH 2/3] alpha: Add wrperfmon.h header file to aid use of wrperfmon PALcall.
Date: Sat,  1 May 2010 11:55:39 +1200
Message-Id: <edbd26fc3ee32d4c7f7994ecd6738683a0a9f8d7.1272668361.git.mcree@orcon.net.nz>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <cover.1272668360.git.mcree@orcon.net.nz>
References: <cover.1272668360.git.mcree@orcon.net.nz>
In-Reply-To: <cover.1272668360.git.mcree@orcon.net.nz>
References: <cover.1272668360.git.mcree@orcon.net.nz>
X-DSPAM-Check: by mx7.orcon.net.nz on Sat, 01 May 2010 11:56:29 +1200
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Sat May  1 11:56:29 2010
X-DSPAM-Confidence: 0.9925
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Michael Cree <mcree@orcon.net.nz>
---
 arch/alpha/include/asm/wrperfmon.h |   93 ++++++++++++++++++++++++++++++++++++
 1 files changed, 93 insertions(+), 0 deletions(-)
 create mode 100644 arch/alpha/include/asm/wrperfmon.h

diff --git a/arch/alpha/include/asm/wrperfmon.h b/arch/alpha/include/asm/wrperfmon.h
new file mode 100644
index 0000000..319bf67
--- /dev/null
+++ b/arch/alpha/include/asm/wrperfmon.h
@@ -0,0 +1,93 @@
+/*
+ * Definitions for use with the Alpha wrperfmon PAL call.
+ */
+
+#ifndef __ALPHA_WRPERFMON_H
+#define __ALPHA_WRPERFMON_H
+
+/* Following commands are implemented on all CPUs */
+#define PERFMON_CMD_DISABLE 0
+#define PERFMON_CMD_ENABLE 1
+#define PERFMON_CMD_DESIRED_EVENTS 2
+#define PERFMON_CMD_LOGGING_OPTIONS 3
+/* Following commands on EV5/EV56/PCA56 only */
+#define PERFMON_CMD_INT_FREQ 4
+#define PERFMON_CMD_ENABLE_CLEAR 7
+/* Following commands are on EV5 and better CPUs */
+#define PERFMON_CMD_READ 5
+#define PERFMON_CMD_WRITE 6
+/* Following command are on EV6 and better CPUs */
+#define PERFMON_CMD_ENABLE_WRITE 7
+/* Following command are on EV67 and better CPUs */
+#define PERFMON_CMD_I_STAT 8
+#define PERFMON_CMD_PMPC 9
+
+
+/* EV5/EV56/PCA56 Counters */
+#define EV5_PCTR_0 (1UL<<0)
+#define EV5_PCTR_1 (1UL<<1)
+#define EV5_PCTR_2 (1UL<<2)
+
+#define EV5_PCTR_0_COUNT_SHIFT 48
+#define EV5_PCTR_1_COUNT_SHIFT 32
+#define EV5_PCTR_2_COUNT_SHIFT 16
+
+#define EV5_PCTR_0_COUNT_MASK 0xffffUL
+#define EV5_PCTR_1_COUNT_MASK 0xffffUL
+#define EV5_PCTR_2_COUNT_MASK 0x3fffUL
+
+/* EV6 Counters */
+#define EV6_PCTR_0 (1UL<<0)
+#define EV6_PCTR_1 (1UL<<1)
+
+#define EV6_PCTR_0_COUNT_SHIFT 28
+#define EV6_PCTR_1_COUNT_SHIFT 6
+
+#define EV6_PCTR_0_COUNT_MASK 0xfffffUL
+#define EV6_PCTR_1_COUNT_MASK 0xfffffUL
+
+/* EV67 (and subsequent) counters */
+#define EV67_PCTR_0 (1UL<<0)
+#define EV67_PCTR_1 (1UL<<1)
+
+#define EV67_PCTR_0_COUNT_SHIFT 28
+#define EV67_PCTR_1_COUNT_SHIFT 6
+
+#define EV67_PCTR_0_COUNT_MASK 0xfffffUL
+#define EV67_PCTR_1_COUNT_MASK 0xfffffUL
+
+
+/*
+ * The Alpha Architecure Handbook, vers. 4 (1998) appears to have a misprint
+ *  in Table E-23 regarding the bits that set the event PCTR 1 counts.
+ *  Hopefully what we have here is correct.
+ */
+#define EV6_PCTR_0_EVENT_MASK 0x10UL
+#define EV6_PCTR_1_EVENT_MASK 0x0fUL
+
+/* EV6 Events */
+#define EV6_PCTR_0_CYCLES (0UL << 4)
+#define EV6_PCTR_0_INSTRUCTIONS (1UL << 4)
+
+#define EV6_PCTR_1_CYCLES 0
+#define EV6_PCTR_1_BRANCHES 1
+#define EV6_PCTR_1_BRANCH_MISPREDICTS 2
+#define EV6_PCTR_1_DTB_SINGLE_MISSES 3
+#define EV6_PCTR_1_DTB_DOUBLE_MISSES 4
+#define EV6_PCTR_1_ITB_MISSES 5
+#define EV6_PCTR_1_UNALIGNED_TRAPS 6
+#define EV6_PCTR_1_REPLY_TRAPS 7
+
+/* From the Alpha Architecture Reference Manual, 4th edn., 2002 */
+#define EV67_PCTR_MODE_MASK 0x10UL
+#define EV67_PCTR_EVENT_MASK 0x0CUL
+
+#define EV67_PCTR_MODE_PROFILEME (1UL<<4)
+#define EV67_PCTR_MODE_AGGREGATE (0UL<<4)
+
+#define EV67_PCTR_INSTR_CYCLES (0UL<<2)
+#define EV67_PCTR_CYCLES_UNDEF (1UL<<2)
+#define EV67_PCTR_INSTR_BCACHEMISS (2UL<<2)
+#define EV67_PCTR_CYCLES_MBOX (3UL<<2)
+
+#endif
-- 
1.7.0

