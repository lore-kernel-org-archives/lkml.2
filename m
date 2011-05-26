Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab1EZFEo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 01:04:44 -0400
Received: from mailx.hitachi.co.jp ([133.145.228.49]:51319 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207Ab1EZFEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 01:04:42 -0400
X-AuditID: b753bd60-a0ac3ba000003bac-c2-4ddddee24b39
X-AuditID: b753bd60-a0ac3ba000003bac-c2-4ddddee24b39
From: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Subject: [PATCH -tip v4 6/7] perf branch trace: add print all option
To: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        pp-manager@sdl.hitachi.co.jp,
        Akihiro Nagai <akihiro.nagai.hw@hitachi.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Date: Thu, 26 May 2011 14:03:34 +0900
Message-ID: <20110526050333.30011.47781.stgit@localhost6.localdomain6>
In-Reply-To: <20110526050246.30011.86048.stgit@localhost6.localdomain6>
References: <20110526050246.30011.86048.stgit@localhost6.localdomain6>
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
index 9b7b1e1..a034f12 100644
--- a/tools/perf/Documentation/perf-branch.txt
+++ b/tools/perf/Documentation/perf-branch.txt
@@ -48,6 +48,9 @@ OPTIONS
 -s::
 --symbol::
 	Print function name and offset. (default)
+-A::
+--all::
+	Print all information.
 
 SEE ALSO
 --------
diff --git a/tools/perf/builtin-branch.c b/tools/perf/builtin-branch.c
index 708b056..51cdcd4 100644
--- a/tools/perf/builtin-branch.c
+++ b/tools/perf/builtin-branch.c
@@ -36,6 +36,9 @@ struct exec_info {
 #define EI_FLAG_PRINT_ELFPATH		(1 << 3)
 #define EI_FLAG_PRINT_SYMBOL		(1 << 4)
 
+/* all print flags are enabled */
+#define	 EI_FLAG_PRINT_ALL		-1UL
+
 /*
  * It's used when no print item specified.
  * It must be selected from EI_FLAG_REQUIRED.
@@ -114,6 +117,9 @@ static const struct option branch_options[] = {
 				   "print function+offset (default)",
 				   set_print_flags,
 				   (void *)EI_FLAG_PRINT_SYMBOL),
+	OPT_CALLBACK_DEFAULT_NOOPT('A', "all", NULL, NULL,
+				   "print all items", set_print_flags,
+				   (void *)EI_FLAG_PRINT_ALL),
 	OPT_END()
 };
 

