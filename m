Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641Ab2GZPSd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 11:18:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38195 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144Ab2GZPSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 11:18:32 -0400
Date: Thu, 26 Jul 2012 08:18:10 -0700
From: tip-bot for Tony Luck <tony.luck@intel.com>
Message-ID: <tip-736edce5f395b8309a61aa62c36c4356abc83219@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        seto.hidetoshi@jp.fujitsu.com, tony.luck@intel.com,
        gong.chen@linux.intel.com, bp@amd64.org, ying.huang@intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        seto.hidetoshi@jp.fujitsu.com, tony.luck@intel.com, bp@amd64.org,
        gong.chen@linux.intel.com, ying.huang@intel.com, tglx@linutronix.de
In-Reply-To: <0ccfb1af5fe35e537b7cd8e4d448bf7d851dbfb9.1343078495.git.tony.luck@intel.com>
References: <0ccfb1af5fe35e537b7cd8e4d448bf7d851dbfb9.1343078495.git.tony.luck@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/mce: Move MCACOD defines from mce-severity.
 c to <asm/mce.h>
Git-Commit-ID: 736edce5f395b8309a61aa62c36c4356abc83219
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 26 Jul 2012 08:18:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  736edce5f395b8309a61aa62c36c4356abc83219
Gitweb:     http://git.kernel.org/tip/736edce5f395b8309a61aa62c36c4356abc83219
Author:     Tony Luck <tony.luck@intel.com>
AuthorDate: Thu, 19 Jul 2012 11:21:53 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 26 Jul 2012 15:05:47 +0200

x86/mce: Move MCACOD defines from mce-severity.c to <asm/mce.h>

We will need some of these values in mce.c. Move them to the
appropriate header file so they are available.

Acked-by: Borislav Petkov <bp@amd64.org>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Cc: Chen Gong <gong.chen@linux.intel.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Link: http://lkml.kernel.org/r/0ccfb1af5fe35e537b7cd8e4d448bf7d851dbfb9.1343078495.git.tony.luck@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/mce.h                |    8 ++++++++
 arch/x86/kernel/cpu/mcheck/mce-severity.c |    7 -------
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 441520e..a3ac52b 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -33,6 +33,14 @@
 #define MCI_STATUS_PCC   (1ULL<<57)  /* processor context corrupt */
 #define MCI_STATUS_S	 (1ULL<<56)  /* Signaled machine check */
 #define MCI_STATUS_AR	 (1ULL<<55)  /* Action required */
+#define MCACOD		  0xffff     /* MCA Error Code */
+
+/* Architecturally defined codes from SDM Vol. 3B Chapter 15 */
+#define MCACOD_SCRUB	0x00C0	/* 0xC0-0xCF Memory Scrubbing */
+#define MCACOD_SCRUBMSK	0xfff0
+#define MCACOD_L3WB	0x017A	/* L3 Explicit Writeback */
+#define MCACOD_DATA	0x0134	/* Data Load */
+#define MCACOD_INSTR	0x0150	/* Instruction Fetch */
 
 /* MCi_MISC register defines */
 #define MCI_MISC_ADDR_LSB(m)	((m) & 0x3f)
diff --git a/arch/x86/kernel/cpu/mcheck/mce-severity.c b/arch/x86/kernel/cpu/mcheck/mce-severity.c
index 413c2ce..1301762 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-severity.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-severity.c
@@ -55,13 +55,6 @@ static struct severity {
 #define MCI_UC_S (MCI_STATUS_UC|MCI_STATUS_S)
 #define MCI_UC_SAR (MCI_STATUS_UC|MCI_STATUS_S|MCI_STATUS_AR)
 #define	MCI_ADDR (MCI_STATUS_ADDRV|MCI_STATUS_MISCV)
-#define MCACOD 0xffff
-/* Architecturally defined codes from SDM Vol. 3B Chapter 15 */
-#define MCACOD_SCRUB	0x00C0	/* 0xC0-0xCF Memory Scrubbing */
-#define MCACOD_SCRUBMSK	0xfff0
-#define MCACOD_L3WB	0x017A	/* L3 Explicit Writeback */
-#define MCACOD_DATA	0x0134	/* Data Load */
-#define MCACOD_INSTR	0x0150	/* Instruction Fetch */
 
 	MCESEV(
 		NO, "Invalid",
