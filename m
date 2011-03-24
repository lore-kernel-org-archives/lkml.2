Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933799Ab1CXLcP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 07:32:15 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:49853 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933711Ab1CXLcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 07:32:09 -0400
X-AuditID: b753bd60-a1d49ba0000001d0-c7-4d8b2bb68224
X-AuditID: b753bd60-a1d49ba0000001d0-c7-4d8b2bb68224
From: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Subject: [PATCH -tip v3 6/6] perf branch trace: add print all option
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
Date: Thu, 24 Mar 2011 20:32:38 +0900
Message-ID: <20110324113238.20235.85860.stgit@localhost6.localdomain6>
In-Reply-To: <20110324113137.20235.42265.stgit@localhost6.localdomain6>
References: <20110324113137.20235.42265.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
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

 tools/perf/Documentation/perf-branch.txt |    3 +++
 tools/perf/builtin-branch.c              |    6 ++++++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Documentation/perf-branch.txt b/tools/perf/Documentation/perf-branch.txt
index 9c7e100..dd06090 100644
--- a/tools/perf/Documentation/perf-branch.txt
+++ b/tools/perf/Documentation/perf-branch.txt
@@ -45,6 +45,9 @@ OPTIONS
 -s::
 --symbol::
 	Print function name and offset. (default)
+-A::
+--all::
+	Print all information.
 
 SEE ALSO
 --------
diff --git a/tools/perf/builtin-branch.c b/tools/perf/builtin-branch.c
index 819443e..efbd8d8 100644
--- a/tools/perf/builtin-branch.c
+++ b/tools/perf/builtin-branch.c
@@ -36,6 +36,9 @@ struct exec_info {
 #define EI_FLAG_PRINT_ELFPATH		(1 << 3)
 #define EI_FLAG_PRINT_SYMBOL		(1 << 4)
 
+/* all print flags are enabled */
+#define	 EI_FLAG_PRINT_ALL		-1UL
+
 /* it's used when no print item specified */
 #define EI_FLAG_PRINT_DEFAULT		EI_FLAG_PRINT_SYMBOL
 
@@ -94,6 +97,9 @@ static const struct option branch_options[] = {
 				   "print function+offset (default)",
 				   set_print_flags,
 				   (void *)EI_FLAG_PRINT_SYMBOL),
+	OPT_CALLBACK_DEFAULT_NOOPT('A', "all", NULL, NULL,
+				   "print all items", set_print_flags,
+				   (void *)EI_FLAG_PRINT_ALL),
 	OPT_END()
 };
 

