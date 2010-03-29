Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab0C2Uaw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 16:30:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15048 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753051Ab0C2Uat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 16:30:49 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 1/7] [BUGFIX] perf probe: Fix to close dwarf when failing
	to analyze it
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Frederic Weisbecker <fweisbec@gmail.com>
Date: Mon, 29 Mar 2010 16:37:45 -0400
Message-ID: <20100329203744.2577.35691.stgit@localhost6.localdomain6>
In-Reply-To: <20100329203736.2577.56018.stgit@localhost6.localdomain6>
References: <20100329203736.2577.56018.stgit@localhost6.localdomain6>
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
index db52ec2..5f6cecc 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -812,8 +812,10 @@ int find_perf_probe_point(int fd, unsigned long addr,
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
