Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab0DBRDx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 13:03:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36021 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755525Ab0DBRDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 13:03:40 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 1/4] [BUGFIX] perf probe: Fix --line syntax help and
	document
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Fri, 02 Apr 2010 12:50:39 -0400
Message-ID: <20100402165038.23551.62590.stgit@localhost6.localdomain6>
In-Reply-To: <20100402165031.23551.14034.stgit@localhost6.localdomain6>
References: <20100402165031.23551.14034.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just fix typos. --line option accepts ':START-END' syntax,
not ':START:END'.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---

 tools/perf/Documentation/perf-probe.txt |    2 +-
 tools/perf/builtin-probe.c              |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-probe.txt b/tools/perf/Documentation/perf-probe.txt
index 0f944b3..bb671b3 100644
--- a/tools/perf/Documentation/perf-probe.txt
+++ b/tools/perf/Documentation/perf-probe.txt
@@ -85,7 +85,7 @@ LINE SYNTAX
 -----------
 Line range is descripted by following syntax.
 
- "FUNC[:RLN[+NUM|:RLN2]]|SRC:ALN[+NUM|:ALN2]"
+ "FUNC[:RLN[+NUM|-RLN2]]|SRC:ALN[+NUM|-ALN2]"
 
 FUNC specifies the function name of showing lines. 'RLN' is the start line
 number from function entry line, and 'RLN2' is the end line number. As same as
diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index cf2ffa5..b3ba25a 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -167,7 +167,7 @@ static const struct option options[] = {
 		    " with existing name"),
 #ifdef DWARF_SUPPORT
 	OPT_CALLBACK('L', "line", NULL,
-		     "FUNC[:RLN[+NUM|:RLN2]]|SRC:ALN[+NUM|:ALN2]",
+		     "FUNC[:RLN[+NUM|-RLN2]]|SRC:ALN[+NUM|-ALN2]",
 		     "Show source code lines.", opt_show_lines),
 	OPT_STRING('k', "vmlinux", &symbol_conf.vmlinux_name,
 		   "file", "vmlinux pathname"),


-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
