Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab1GPLYu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 07:24:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:39371 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909Ab1GPLW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 07:22:59 -0400
X-Authority-Analysis: v=1.1 cv=yMxAJ7W7nAoPh8ZdbvCArpG6pAdHwgpzIvOq8QbMesM= c=1 sm=0 a=vhdKIqpQuCYA:10 a=dyGAplrz1dkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=3nbZYyFuAAAA:8 a=h3sCQ_blAAAA:8 a=pGLkceISAAAA:8 a=hGzw-44bAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=Y5ZifleuZhk8C3QQklQA:9 a=yeu1DMhn_SBPRvHXFJQA:7 a=EvKJbDF4Ut8A:10 a=fNChW5oJl9MA:10 a=MSl-tDqOz04A:10 a=dowx1zmaLagA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110716112255.007662133@goodmis.org>
User-Agent: quilt/0.48-1
Date: Sat, 16 Jul 2011 07:22:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>
Subject: [PATCH 14/20] perf probe: Rename DIE_FIND_CB_FOUND to DIE_FIND_CB_END
References: <20110716112200.096203519@goodmis.org>
Content-Disposition: inline; filename=0014-perf-probe-Rename-DIE_FIND_CB_FOUND-to-DIE_FIND_CB_E.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Since die_find/walk* callbacks use DIE_FIND_CB_FOUND for
both of failed and found cases, it should be "END"
instead "FOUND" for avoiding confusion.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Reported-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Link: http://lkml.kernel.org/r/20110627072709.6528.45706.stgit@fedora15
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
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
-- 
1.7.5.4


