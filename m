Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966369Ab0CPOrb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 10:47:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:44543 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965256Ab0CPOr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 10:47:29 -0400
Date: Tue, 16 Mar 2010 14:46:46 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       dle-develop@lists.sourceforge.net, tglx@linutronix.de,
       mhiramat@redhat.com, systemtap@sources.redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       dle-develop@lists.sourceforge.net, tglx@linutronix.de,
       mhiramat@redhat.com, systemtap@sources.redhat.com, mingo@elte.hu
In-Reply-To: <20100315170228.31852.71946.stgit@localhost6.localdomain6>
References: <20100315170228.31852.71946.stgit@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf probe: Fix offset to allow signed value
Message-ID: <tip-67c7ff7c56f38a8ab338fbbfe366621ce6303ba1@git.kernel.org>
Git-Commit-ID: 67c7ff7c56f38a8ab338fbbfe366621ce6303ba1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 16 Mar 2010 14:46:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  67c7ff7c56f38a8ab338fbbfe366621ce6303ba1
Gitweb:     http://git.kernel.org/tip/67c7ff7c56f38a8ab338fbbfe366621ce6303ba1
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Mon, 15 Mar 2010 13:02:28 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 16 Mar 2010 10:02:18 +0100

perf probe: Fix offset to allow signed value

Fix dereference offset to intmax_t from uintmax_t, because
it can have negative values (for example local variable's offset
from frame pointer).

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
LKML-Reference: <20100315170228.31852.71946.stgit@localhost6.localdomain6>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/probe-finder.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index f9cbbf1..0e8c8f1 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -333,8 +333,8 @@ static void show_location(Dwarf_Op *op, struct probe_finder *pf)
 		die("%u exceeds max register number.", regn);
 
 	if (deref)
-		ret = snprintf(pf->buf, pf->len, " %s=+%ju(%s)",
-			       pf->var, (uintmax_t)offs, regs);
+		ret = snprintf(pf->buf, pf->len, " %s=%+jd(%s)",
+			       pf->var, (intmax_t)offs, regs);
 	else
 		ret = snprintf(pf->buf, pf->len, " %s=%s", pf->var, regs);
 	DIE_IF(ret < 0);
