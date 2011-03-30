Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932377Ab1C3Jc7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 05:32:59 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:42025 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932356Ab1C3Jc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 05:32:56 -0400
X-AuditID: b753bd60-a6350ba0000001d0-53-4d92f8c6e852
X-AuditID: b753bd60-a6350ba0000001d0-53-4d92f8c6e852
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip 06/12] [CLEANUP]perf probe: Rename DIE_FIND_CB_FOUND to
	DIE_FIND_CB_END
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        2nddept-manager@sdl.hitachi.co.jp,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date: Wed, 30 Mar 2011 18:26:11 +0900
Message-ID: <20110330092611.2132.37204.stgit@ltc236.sdl.hitachi.co.jp>
In-Reply-To: <20110330092533.2132.35412.stgit@ltc236.sdl.hitachi.co.jp>
References: <20110330092533.2132.35412.stgit@ltc236.sdl.hitachi.co.jp>
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
---

 tools/perf/util/probe-finder.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index c579e04..f6535d1 100644
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

