Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498Ab1GUKD7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 06:03:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:55958 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752282Ab1GUKD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 06:03:57 -0400
Date: Thu, 21 Jul 2011 10:03:27 GMT
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Message-ID: <tip-baad2d3e69ba154dae340904a47ae12414f1894f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, acme@ghostprotocols.net,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110627072709.6528.45706.stgit@fedora15>
References: <20110627072709.6528.45706.stgit@fedora15>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Rename DIE_FIND_CB_FOUND to DIE_FIND_CB_END
Git-Commit-ID: baad2d3e69ba154dae340904a47ae12414f1894f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Jul 2011 10:03:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  baad2d3e69ba154dae340904a47ae12414f1894f
Gitweb:     http://git.kernel.org/tip/baad2d3e69ba154dae340904a47ae12414f1894f
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Mon, 27 Jun 2011 16:27:09 +0900
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Fri, 15 Jul 2011 15:55:57 -0400

perf probe: Rename DIE_FIND_CB_FOUND to DIE_FIND_CB_END

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
