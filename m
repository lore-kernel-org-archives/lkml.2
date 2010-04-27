Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab0D0M7o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 08:59:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:41215 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754091Ab0D0M7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 08:59:41 -0400
Date: Tue, 27 Apr 2010 12:58:44 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       efault@gmx.de, tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <20100421195632.24664.42598.stgit@localhost6.localdomain6>
References: <20100421195632.24664.42598.stgit@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Fix to exit callback soon after finding too many probe points
Message-ID: <tip-5d1ee0413c8e2e0aa48510b1edfb3c4d2d43455b@git.kernel.org>
Git-Commit-ID: 5d1ee0413c8e2e0aa48510b1edfb3c4d2d43455b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 27 Apr 2010 12:58:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5d1ee0413c8e2e0aa48510b1edfb3c4d2d43455b
Gitweb:     http://git.kernel.org/tip/5d1ee0413c8e2e0aa48510b1edfb3c4d2d43455b
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Wed, 21 Apr 2010 15:56:32 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 26 Apr 2010 15:33:08 -0300

perf probe: Fix to exit callback soon after finding too many probe points

Fix to exit callback soon after finding too many probe points.
Don't try to continue searching because it already failed.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <20100421195632.24664.42598.stgit@localhost6.localdomain6>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-finder.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index e7ee52f..0d795bc 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -871,6 +871,8 @@ static int probe_point_inline_cb(Dwarf_Die *in_die, void *data)
 			 (uintmax_t)pf->addr);
 
 		param->retval = convert_probe_point(in_die, pf);
+		if (param->retval < 0)
+			return DWARF_CB_ABORT;
 	}
 
 	return DWARF_CB_OK;
@@ -1106,6 +1108,8 @@ static int line_range_funcdecl_cb(Dwarf_Die *sp_die, void *data)
 		return DWARF_CB_OK;
 
 	param->retval = line_range_add_line(src, lineno, lf->lr);
+	if (param->retval < 0)
+		return DWARF_CB_ABORT;
 	return DWARF_CB_OK;
 }
 
