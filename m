Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585Ab1F1MDr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 08:03:47 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:56670 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757477Ab1F1L5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 07:57:40 -0400
X-AuditID: b753bd60-a3cafba0000019f4-e5-4e09c1b11d96
X-AuditID: b753bd60-a3cafba0000019f4-e5-4e09c1b11d96
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip 06/13] [RESEND][CLEANUP]perf probe: Rename
 DIE_FIND_CB_FOUND to DIE_FIND_CB_END
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Date: Mon, 27 Jun 2011 16:27:09 +0900
Message-ID: <20110627072709.6528.45706.stgit@fedora15>
In-Reply-To: <20110627072626.6528.41792.stgit@fedora15>
References: <20110627072626.6528.41792.stgit@fedora15>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since die_find/walk* callbacks use DIE_FIND_CB_FOUND for
both of failed and found cases, it should be "END"
instead "FOUND" for avoiding confusion.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Reported-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
---

 tools/perf/util/probe-finder.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 3b9d0b8..7b78904 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -435,7 +435,7 @@ static int die_get_data_member_location(Dwarf_Die *mb_die, Dwarf_Word *offs)
 
 /* Return values for die_find callbacks */
 enum {
-	DIE_FIND_CB_FOUND = 0,		/* End of Search */
+	DIE_FIND_CB_END = 0,		/* End of Search */
 	DIE_FIND_CB_CHILD = 1,		/* Search only children */
 	DIE_FIND_CB_SIBLING = 2,	/* Search only siblings */
 	DIE_FIND_CB_CONTINUE = 3,	/* Search children and siblings */
@@ -455,7 +455,7 @@ static Dwarf_Die *die_find_child(Dwarf_Die *rt_die,
 
 	do {
 		ret = callback(die_mem, data);
-		if (ret == DIE_FIND_CB_FOUND)
+		if (ret == DIE_FIND_CB_END)
 			return die_mem;
 
 		if ((ret & DIE_FIND_CB_CHILD) &&
@@ -507,7 +507,7 @@ static int __die_find_inline_cb(Dwarf_Die *die_mem, void *data)
 
 	if (dwarf_tag(die_mem) == DW_TAG_inlined_subroutine &&
 	    dwarf_haspc(die_mem, *addr))
-		return DIE_FIND_CB_FOUND;
+		return DIE_FIND_CB_END;
 
 	return DIE_FIND_CB_CONTINUE;
 }
@@ -555,7 +555,7 @@ static int __die_walk_funclines_cb(Dwarf_Die *in_die, void *data)
 			lw->retval = lw->handler(lw->fname, lineno, addr,
 						 lw->data);
 			if (lw->retval != 0)
-				return DIE_FIND_CB_FOUND;
+				return DIE_FIND_CB_END;
 		}
 	}
 	return DIE_FIND_CB_SIBLING;
@@ -691,7 +691,7 @@ static int __die_find_variable_cb(Dwarf_Die *die_mem, void *data)
 	if ((tag == DW_TAG_formal_parameter ||
 	     tag == DW_TAG_variable) &&
 	    die_compare_name(die_mem, fvp->name))
-		return DIE_FIND_CB_FOUND;
+		return DIE_FIND_CB_END;
 
 	if (dwarf_haspc(die_mem, fvp->addr))
 		return DIE_FIND_CB_CONTINUE;
@@ -715,7 +715,7 @@ static int __die_find_member_cb(Dwarf_Die *die_mem, void *data)
 
 	if ((dwarf_tag(die_mem) == DW_TAG_member) &&
 	    die_compare_name(die_mem, name))
-		return DIE_FIND_CB_FOUND;
+		return DIE_FIND_CB_END;
 
 	return DIE_FIND_CB_SIBLING;
 }

