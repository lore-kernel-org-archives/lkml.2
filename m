Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688Ab0DBREF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 13:04:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28940 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755713Ab0DBRDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 13:03:50 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 4/4] [BUGFIX][RESEND] perf probe: Fix to close dwarf when
	failing to analyze it
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Fri, 02 Apr 2010 12:50:59 -0400
Message-ID: <20100402165059.23551.95587.stgit@localhost6.localdomain6>
In-Reply-To: <20100402165031.23551.14034.stgit@localhost6.localdomain6>
References: <20100402165031.23551.14034.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix to close libdw routine when failing to analyze it in
find_perf_probe_point().

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---

 tools/perf/util/probe-finder.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 59b0115..a851377 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -818,8 +818,10 @@ int find_perf_probe_point(int fd, unsigned long addr,
 		return -ENOENT;
 
 	/* Find cu die */
-	if (!dwarf_addrdie(dbg, (Dwarf_Addr)addr, &cudie))
-		return -EINVAL;
+	if (!dwarf_addrdie(dbg, (Dwarf_Addr)addr, &cudie)) {
+		ret = -EINVAL;
+		goto end;
+	}
 
 	/* Find a corresponding line */
 	line = dwarf_getsrc_die(&cudie, (Dwarf_Addr)addr);


-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
