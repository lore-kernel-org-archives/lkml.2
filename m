Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259Ab2DPIfM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 04:35:12 -0400
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:56002
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752077Ab2DPIfJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 04:35:09 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M2KD6B-01-6B3-02
X-M-MSG: 
From: "Chen, Dennis (SRDC SW)" <Dennis1.Chen@amd.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 2/2] tools perf: Add a new benchmark tool for semaphore/mutex
Thread-Topic: [PATCH 2/2] tools perf: Add a new benchmark tool for
 semaphore/mutex
Thread-Index: Ac0bq80rFoR1i1MPSmaMIYR+oX9rXA==
Date: Mon, 16 Apr 2012 08:34:56 +0000
Message-ID: <491D6B4EAD0A714894D8AD22F4BDE043B158D5@SCYBEXDAG03.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.74.102]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A new performance benchmark tool for semaphore or mutex lock.

Signed-off-by: Dennis Chen <dennis1.chen@amd.com>
---
diff --git a/tools/perf/builtin-bench.c b/tools/perf/builtin-bench.c
index fcb9626..354a133 100644
--- a/tools/perf/builtin-bench.c
+++ b/tools/perf/builtin-bench.c
@@ -58,6 +58,16 @@ static struct bench_suite mem_suites[] = {
          NULL             }
 };
 
+static struct bench_suite lock_suites[] = {
+       { "mutex",
+         "Simple performance measurement for semaphore/mutex lock",
+         bench_lock_mutex },
+       suite_all,
+       { NULL,
+         NULL,
+         NULL             }
+};
+
 struct bench_subsys {
        const char *name;
        const char *summary;
@@ -71,6 +81,9 @@ static struct bench_subsys subsystems[] = {
        { "mem",
          "memory access performance",
          mem_suites },
+       { "locking",
+         "lock method performance",
+         lock_suites },
        { "all",                /* sentinel: easy for help */
          "test all subsystem (pseudo subsystem)",
          NULL },

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 8a4b9bc..a947396 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -363,6 +363,7 @@ ifeq ($(RAW_ARCH),x86_64)
 BUILTIN_OBJS += $(OUTPUT)bench/mem-memcpy-x86-64-asm.o
 endif
 BUILTIN_OBJS += $(OUTPUT)bench/mem-memcpy.o
+BUILTIN_OBJS += $(OUTPUT)bench/lock-mutex.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-diff.o
 BUILTIN_OBJS += $(OUTPUT)builtin-evlist.o

diff --git a/tools/perf/bench/bench.h b/tools/perf/bench/bench.h
index f7781c6..57f1170 100644
--- a/tools/perf/bench/bench.h
+++ b/tools/perf/bench/bench.h
@@ -4,6 +4,8 @@
 extern int bench_sched_messaging(int argc, const char **argv, const char *prefix);
 extern int bench_sched_pipe(int argc, const char **argv, const char *prefix);
 extern int bench_mem_memcpy(int argc, const char **argv, const char *prefix __used);
+extern int bench_lock_mutex(int argc, const char **argv,
+                               const char *prefix __used);
 
 #define BENCH_FORMAT_DEFAULT_STR       "default"
 #define BENCH_FORMAT_DEFAULT           0


