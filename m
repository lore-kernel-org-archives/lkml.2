Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933686Ab0LUJFv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 04:05:51 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:55207 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758135Ab0LUJF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 04:05:27 -0500
X-AuditID: b753bd60-a55a3ba000003e7d-f1-4d106dd4efc5
From: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Subject: [PATCH -tip v2 6/6] perf bts trace: add print all option
To: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        2nddept-manager@sdl.hitachi.co.jp,
        Akihiro Nagai <akihiro.nagai.hw@hitachi.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Date: Tue, 21 Dec 2010 18:06:15 +0900
Message-ID: <20101221090615.8552.36006.stgit@localhost6.localdomain6>
In-Reply-To: <20101221090527.8552.41486.stgit@localhost6.localdomain6>
References: <20101221090527.8552.41486.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For ease of use, add option printing all information '-A' or '--all'.
This option can print following information.
  - pid
  - command name
  - address
  - function+offset
  - elf file path

Signed-off-by: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
---

 tools/perf/Documentation/perf-bts.txt |    3 +++
 tools/perf/builtin-bts.c              |    6 ++++++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Documentation/perf-bts.txt b/tools/perf/Documentation/perf-bts.txt
index 13ee862..c598dd2 100644
--- a/tools/perf/Documentation/perf-bts.txt
+++ b/tools/perf/Documentation/perf-bts.txt
@@ -44,6 +44,9 @@ OPTIONS
 -s::
 --symbol::
 	Print function name and offset. (default)
+-A::
+--all::
+	Print all information.
 
 SEE ALSO
 --------
diff --git a/tools/perf/builtin-bts.c b/tools/perf/builtin-bts.c
index be57571..bac4e83 100644
--- a/tools/perf/builtin-bts.c
+++ b/tools/perf/builtin-bts.c
@@ -34,6 +34,9 @@ struct exec_info {
 #define EI_FLAG_PRINT_ELFPATH		(1 << 3)
 #define EI_FLAG_PRINT_SYMBOL		(1 << 4)
 
+/* all print flags are enabled */
+#define	 EI_FLAG_PRINT_ALL		-1UL
+
 /* it's used when no print item specified */
 #define EI_FLAG_PRINT_DEFAULT		EI_FLAG_PRINT_SYMBOL
 
@@ -92,6 +95,9 @@ static const struct option bts_options[] = {
 				   "print function+offset (default)",
 				   set_print_flags,
 				   (void *)EI_FLAG_PRINT_SYMBOL),
+	OPT_CALLBACK_DEFAULT_NOOPT('A', "all", NULL, NULL,
+				   "print all items", set_print_flags,
+				   (void *)EI_FLAG_PRINT_ALL),
 	OPT_END()
 };
 

