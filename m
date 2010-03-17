Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab0CQL3o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 07:29:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:36085 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754510Ab0CQL3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 07:29:40 -0400
Date: Wed, 17 Mar 2010 11:28:48 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       dle-develop@lists.sourceforge.net, fweisbec@gmail.com,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu,
       systemtap@sources.redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       dle-develop@lists.sourceforge.net, fweisbec@gmail.com,
       tglx@linutronix.de, mhiramat@redhat.com, systemtap@sources.redhat.com,
       mingo@elte.hu
In-Reply-To: <20100316220551.32050.36181.stgit@localhost6.localdomain6>
References: <20100316220551.32050.36181.stgit@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Rename some die_get_* functions
Message-ID: <tip-95a3e4c4e21de1920a2ddb54bfc57c0af7e2561e@git.kernel.org>
Git-Commit-ID: 95a3e4c4e21de1920a2ddb54bfc57c0af7e2561e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 17 Mar 2010 11:28:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  95a3e4c4e21de1920a2ddb54bfc57c0af7e2561e
Gitweb:     http://git.kernel.org/tip/95a3e4c4e21de1920a2ddb54bfc57c0af7e2561e
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Tue, 16 Mar 2010 18:05:51 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 17 Mar 2010 11:32:30 +0100

perf probe: Rename some die_get_* functions

Rename die_get_real_subprogram and die_get_inlinefunc to
die_find_real_subprogram and die_find_inlinefunc respectively,
because these functions search its children. After that,
'die_get_' means getting a property of that die, and
'die_find_' means searching DIE-tree to get an appropriate
child die.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20100316220551.32050.36181.stgit@localhost6.localdomain6>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/probe-finder.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index e887bb6..c91a960 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -204,8 +204,8 @@ static int __die_search_func_cb(Dwarf_Die *fn_die, void *data)
 }
 
 /* Search a real subprogram including this line, */
-static Dwarf_Die *die_get_real_subprogram(Dwarf_Die *cu_die, Dwarf_Addr addr,
-					  Dwarf_Die *die_mem)
+static Dwarf_Die *die_find_real_subprogram(Dwarf_Die *cu_die, Dwarf_Addr addr,
+					   Dwarf_Die *die_mem)
 {
 	struct __addr_die_search_param ad;
 	ad.addr = addr;
@@ -218,8 +218,8 @@ static Dwarf_Die *die_get_real_subprogram(Dwarf_Die *cu_die, Dwarf_Addr addr,
 }
 
 /* Similar to dwarf_getfuncs, but returns inlined_subroutine if exists. */
-static Dwarf_Die *die_get_inlinefunc(Dwarf_Die *sp_die, Dwarf_Addr addr,
-				     Dwarf_Die *die_mem)
+static Dwarf_Die *die_find_inlinefunc(Dwarf_Die *sp_die, Dwarf_Addr addr,
+				      Dwarf_Die *die_mem)
 {
 	Dwarf_Die child_die;
 	int ret;
@@ -233,7 +233,7 @@ static Dwarf_Die *die_get_inlinefunc(Dwarf_Die *sp_die, Dwarf_Addr addr,
 		    dwarf_haspc(die_mem, addr))
 			return die_mem;
 
-		if (die_get_inlinefunc(die_mem, addr, &child_die)) {
+		if (die_find_inlinefunc(die_mem, addr, &child_die)) {
 			memcpy(die_mem, &child_die, sizeof(Dwarf_Die));
 			return die_mem;
 		}
@@ -401,7 +401,7 @@ static void show_probe_point(Dwarf_Die *sp_die, struct probe_finder *pf)
 
 	/* If no real subprogram, find a real one */
 	if (!sp_die || dwarf_tag(sp_die) != DW_TAG_subprogram) {
-		sp_die = die_get_real_subprogram(&pf->cu_die,
+		sp_die = die_find_real_subprogram(&pf->cu_die,
 						 pf->addr, &die_mem);
 		if (!sp_die)
 			die("Probe point is not found in subprograms.");
@@ -564,7 +564,7 @@ static void find_probe_point_lazy(Dwarf_Die *sp_die, struct probe_finder *pf)
 			if (!dwarf_haspc(sp_die, addr))
 				continue;
 			/* Address filtering 2: No child include addr? */
-			if (die_get_inlinefunc(sp_die, addr, &die_mem))
+			if (die_find_inlinefunc(sp_die, addr, &die_mem))
 				continue;
 		}
 
@@ -714,7 +714,7 @@ static void find_line_range_by_line(Dwarf_Die *sp_die, struct line_finder *lf)
 				continue;
 
 			/* Address filtering 2: No child include addr? */
-			if (die_get_inlinefunc(sp_die, addr, &die_mem))
+			if (die_find_inlinefunc(sp_die, addr, &die_mem))
 				continue;
 		}
 
