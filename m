Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533Ab0DBTIs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 15:08:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:38545 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753778Ab0DBTIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 15:08:42 -0400
Date: Fri, 2 Apr 2010 19:08:03 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       dle-develop@lists.sourceforge.net, fweisbec@gmail.com,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu,
       systemtap@sources.redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, peterz@infradead.org, efault@gmx.de,
       dle-develop@lists.sourceforge.net, fweisbec@gmail.com,
       tglx@linutronix.de, mhiramat@redhat.com, systemtap@sources.redhat.com,
       mingo@elte.hu
In-Reply-To: <20100402165038.23551.62590.stgit@localhost6.localdomain6>
References: <20100402165038.23551.62590.stgit@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Fix --line syntax help and document
Message-ID: <tip-085ea739adf107b5a5d131f3625e517ff4a5181e@git.kernel.org>
Git-Commit-ID: 085ea739adf107b5a5d131f3625e517ff4a5181e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 02 Apr 2010 19:08:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  085ea739adf107b5a5d131f3625e517ff4a5181e
Gitweb:     http://git.kernel.org/tip/085ea739adf107b5a5d131f3625e517ff4a5181e
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Fri, 2 Apr 2010 12:50:39 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 2 Apr 2010 19:35:42 +0200

perf probe: Fix --line syntax help and document

Just fix typos. --line option accepts ':START-END' syntax,
not ':START:END'.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
LKML-Reference: <20100402165038.23551.62590.stgit@localhost6.localdomain6>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
