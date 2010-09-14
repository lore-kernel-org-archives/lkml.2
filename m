Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750743Ab0INEYm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 00:24:42 -0400
Received: from mail.perches.com ([173.55.12.10]:1977 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755Ab0INEYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 00:24:11 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, linux-alpha@vger.kernel.org
Subject: [PATCH next 01/16] arch/alpha: Use static const char * const where possible
Date: Mon, 13 Sep 2010 21:23:47 -0700
Message-Id: <3b211935182d8ac989fbdfde01fbdc25077151a9.1284435709.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.rc1
In-Reply-To: <cover.1284435709.git.joe@perches.com>
References: <cover.1284435709.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/alpha/kernel/err_ev6.c    |   12 +++++++-----
 arch/alpha/kernel/err_marvel.c |   33 +++++++++++++++++----------------
 arch/alpha/kernel/err_titan.c  |   35 ++++++++++++++++++++---------------
 arch/alpha/kernel/osf_sys.c    |    4 ++--
 4 files changed, 46 insertions(+), 38 deletions(-)

diff --git a/arch/alpha/kernel/err_ev6.c b/arch/alpha/kernel/err_ev6.c
index 8ca6345..253cf1a 100644
--- a/arch/alpha/kernel/err_ev6.c
+++ b/arch/alpha/kernel/err_ev6.c
@@ -90,11 +90,13 @@ static int
 ev6_parse_cbox(u64 c_addr, u64 c1_syn, u64 c2_syn, 
 	       u64 c_stat, u64 c_sts, int print)
 {
-	char *sourcename[] = { "UNKNOWN", "UNKNOWN", "UNKNOWN",
-			       "MEMORY", "BCACHE", "DCACHE", 
-			       "BCACHE PROBE", "BCACHE PROBE" };
-	char *streamname[] = { "D", "I" };
-	char *bitsname[] = { "SINGLE", "DOUBLE" };
+	static const char * const sourcename[] = {
+		"UNKNOWN", "UNKNOWN", "UNKNOWN",
+		"MEMORY", "BCACHE", "DCACHE",
+		"BCACHE PROBE", "BCACHE PROBE"
+	};
+	static const char * const streamname[] = { "D", "I" };
+	static const char * const bitsname[] = { "SINGLE", "DOUBLE" };
 	int status = MCHK_DISPOSITION_REPORT;
 	int source = -1, stream = -1, bits = -1;
 
diff --git a/arch/alpha/kernel/err_marvel.c b/arch/alpha/kernel/err_marvel.c
index 5c905aa..648ae88 100644
--- a/arch/alpha/kernel/err_marvel.c
+++ b/arch/alpha/kernel/err_marvel.c
@@ -589,22 +589,23 @@ marvel_print_pox_spl_cmplt(u64 spl_cmplt)
 static void
 marvel_print_pox_trans_sum(u64 trans_sum)
 {
-	char *pcix_cmd[] = { "Interrupt Acknowledge",
-			     "Special Cycle",
-			     "I/O Read",
-			     "I/O Write",
-			     "Reserved",
-			     "Reserved / Device ID Message",
-			     "Memory Read",
-			     "Memory Write",
-			     "Reserved / Alias to Memory Read Block",
-			     "Reserved / Alias to Memory Write Block",
-			     "Configuration Read",
-			     "Configuration Write",
-			     "Memory Read Multiple / Split Completion",
-			     "Dual Address Cycle",
-			     "Memory Read Line / Memory Read Block",
-			     "Memory Write and Invalidate / Memory Write Block"
+	static const char * const pcix_cmd[] = {
+		"Interrupt Acknowledge",
+		"Special Cycle",
+		"I/O Read",
+		"I/O Write",
+		"Reserved",
+		"Reserved / Device ID Message",
+		"Memory Read",
+		"Memory Write",
+		"Reserved / Alias to Memory Read Block",
+		"Reserved / Alias to Memory Write Block",
+		"Configuration Read",
+		"Configuration Write",
+		"Memory Read Multiple / Split Completion",
+		"Dual Address Cycle",
+		"Memory Read Line / Memory Read Block",
+		"Memory Write and Invalidate / Memory Write Block"
 	};
 
 #define IO7__POX_TRANSUM__PCI_ADDR__S		(0)
diff --git a/arch/alpha/kernel/err_titan.c b/arch/alpha/kernel/err_titan.c
index f7ed97c..c3b3781 100644
--- a/arch/alpha/kernel/err_titan.c
+++ b/arch/alpha/kernel/err_titan.c
@@ -75,8 +75,12 @@ titan_parse_p_serror(int which, u64 serror, int print)
 	int status = MCHK_DISPOSITION_REPORT;
 
 #ifdef CONFIG_VERBOSE_MCHECK
-	char *serror_src[] = {"GPCI", "APCI", "AGP HP", "AGP LP"};
-	char *serror_cmd[] = {"DMA Read", "DMA RMW", "SGTE Read", "Reserved"};
+	static const char * const serror_src[] = {
+		"GPCI", "APCI", "AGP HP", "AGP LP"
+	};
+	static const char * const serror_cmd[] = {
+		"DMA Read", "DMA RMW", "SGTE Read", "Reserved"
+	};
 #endif /* CONFIG_VERBOSE_MCHECK */
 
 #define TITAN__PCHIP_SERROR__LOST_UECC	(1UL << 0)
@@ -140,14 +144,15 @@ titan_parse_p_perror(int which, int port, u64 perror, int print)
 	int status = MCHK_DISPOSITION_REPORT;
 
 #ifdef CONFIG_VERBOSE_MCHECK
-	char *perror_cmd[] = { "Interrupt Acknowledge", "Special Cycle",
-			       "I/O Read",	       	"I/O Write",
-			       "Reserved",	       	"Reserved",
-			       "Memory Read",		"Memory Write",
-			       "Reserved",		"Reserved",
-			       "Configuration Read",	"Configuration Write",
-			       "Memory Read Multiple",	"Dual Address Cycle",
-			       "Memory Read Line","Memory Write and Invalidate"
+	static const char * const perror_cmd[] = {
+		"Interrupt Acknowledge", "Special Cycle",
+		"I/O Read",		"I/O Write",
+		"Reserved",		"Reserved",
+		"Memory Read",		"Memory Write",
+		"Reserved",		"Reserved",
+		"Configuration Read",	"Configuration Write",
+		"Memory Read Multiple",	"Dual Address Cycle",
+		"Memory Read Line",	"Memory Write and Invalidate"
 	};
 #endif /* CONFIG_VERBOSE_MCHECK */
 
@@ -273,11 +278,11 @@ titan_parse_p_agperror(int which, u64 agperror, int print)
 	int cmd, len;
 	unsigned long addr;
 
-	char *agperror_cmd[] = { "Read (low-priority)",	"Read (high-priority)",
-				 "Write (low-priority)",
-				 "Write (high-priority)",
-				 "Reserved",		"Reserved",
-				 "Flush",		"Fence"
+	static const char * const agperror_cmd[] = {
+		"Read (low-priority)",	"Read (high-priority)",
+		"Write (low-priority)",	"Write (high-priority)",
+		"Reserved",		"Reserved",
+		"Flush",		"Fence"
 	};
 #endif /* CONFIG_VERBOSE_MCHECK */
 
diff --git a/arch/alpha/kernel/osf_sys.c b/arch/alpha/kernel/osf_sys.c
index 5d1e6d6..16bc1f5 100644
--- a/arch/alpha/kernel/osf_sys.c
+++ b/arch/alpha/kernel/osf_sys.c
@@ -594,7 +594,7 @@ SYSCALL_DEFINE2(osf_sigstack, struct sigstack __user *, uss,
 
 SYSCALL_DEFINE3(osf_sysinfo, int, command, char __user *, buf, long, count)
 {
-	char *sysinfo_table[] = {
+	const char *sysinfo_table[] = {
 		utsname()->sysname,
 		utsname()->nodename,
 		utsname()->release,
@@ -606,7 +606,7 @@ SYSCALL_DEFINE3(osf_sysinfo, int, command, char __user *, buf, long, count)
 		"dummy",	/* secure RPC domain */
 	};
 	unsigned long offset;
-	char *res;
+	const char *res;
 	long len, err = -EINVAL;
 
 	offset = command-1;
-- 
1.7.3.rc1

