Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733Ab2GIUlF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 16:41:05 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:31834
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753235Ab2GIUlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 16:41:03 -0400
X-IronPort-AV: E=Sophos;i="4.77,555,1336341600"; 
   d="scan'208";a="150116025"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <npalix.work@gmail.com>, cocci@diku.dk,
        linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>
Subject: [PATCH] scripts/coccinelle/iterators/use_after_iter.cocci: list iterator variable semantic patch
Date: Mon,  9 Jul 2012 22:40:51 +0200
Message-Id: <1341866451-24290-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

If list_for_each_entry, etc complete a traversal of the list, the iterator
variable ends up pointing to an address at an offset from the list head,
and not a meaningful structure.  Thus this value should not be used after
the end of the iterator.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 scripts/coccinelle/iterators/use_after_iter.cocci |  147 ++++++++++++++++++++++
 1 file changed, 147 insertions(+)

diff --git a/scripts/coccinelle/iterators/use_after_iter.cocci b/scripts/coccinelle/iterators/use_after_iter.cocci
new file mode 100644
index 0000000..06284c5
--- /dev/null
+++ b/scripts/coccinelle/iterators/use_after_iter.cocci
@@ -0,0 +1,147 @@
+/// If list_for_each_entry, etc complete a traversal of the list, the iterator
+/// variable ends up pointing to an address at an offset from the list head,
+/// and not a meaningful structure.  Thus this value should not be used after
+/// the end of the iterator.
+//#False positives arise when there is a goto in the iterator and the
+//#reported reference is at the label of this goto.  Some flag tests
+//#may also cause a report to be a false positive.
+///
+// Confidence: Moderate
+// Copyright: (C) 2012 Julia Lawall, INRIA/LIP6.  GPLv2.
+// Copyright: (C) 2012 Gilles Muller, INRIA/LIP6.  GPLv2.
+// URL: http://coccinelle.lip6.fr/
+// Comments:
+// Options: -no_includes -include_headers
+
+virtual context
+virtual org
+virtual report
+
+@r exists@
+identifier c,member;
+expression E,x;
+iterator name list_for_each_entry;
+iterator name list_for_each_entry_reverse;
+iterator name list_for_each_entry_continue;
+iterator name list_for_each_entry_continue_reverse;
+iterator name list_for_each_entry_from;
+iterator name list_for_each_entry_safe;
+iterator name list_for_each_entry_safe_continue;
+iterator name list_for_each_entry_safe_from;
+iterator name list_for_each_entry_safe_reverse;
+iterator name hlist_for_each_entry;
+iterator name hlist_for_each_entry_continue;
+iterator name hlist_for_each_entry_from;
+iterator name hlist_for_each_entry_safe;
+statement S;
+position p1,p2;
+@@
+
+(
+list_for_each_entry@p1(c,...,member) { ... when != break;
+                                 when forall
+                                 when strict
+}
+|
+list_for_each_entry_reverse@p1(c,...,member) { ... when != break;
+                                 when forall
+                                 when strict
+}
+|
+list_for_each_entry_continue@p1(c,...,member) { ... when != break;
+                                 when forall
+                                 when strict
+}
+|
+list_for_each_entry_continue_reverse@p1(c,...,member) { ... when != break;
+                                 when forall
+                                 when strict
+}
+|
+list_for_each_entry_from@p1(c,...,member) { ... when != break;
+                                 when forall
+                                 when strict
+}
+|
+list_for_each_entry_safe@p1(c,...,member) { ... when != break;
+                                 when forall
+                                 when strict
+}
+|
+list_for_each_entry_safe_continue@p1(c,...,member) { ... when != break;
+                                 when forall
+                                 when strict
+}
+|
+list_for_each_entry_safe_from@p1(c,...,member) { ... when != break;
+                                 when forall
+                                 when strict
+}
+|
+list_for_each_entry_safe_reverse@p1(c,...,member) { ... when != break;
+                                 when forall
+                                 when strict
+}
+)
+...
+(
+list_for_each_entry(c,...) S
+|
+list_for_each_entry_reverse(c,...) S
+|
+list_for_each_entry_continue(c,...) S
+|
+list_for_each_entry_continue_reverse(c,...) S
+|
+list_for_each_entry_from(c,...) S
+|
+list_for_each_entry_safe(c,...) S
+|
+list_for_each_entry_safe(x,c,...) S
+|
+list_for_each_entry_safe_continue(c,...) S
+|
+list_for_each_entry_safe_continue(x,c,...) S
+|
+list_for_each_entry_safe_from(c,...) S
+|
+list_for_each_entry_safe_from(x,c,...) S
+|
+list_for_each_entry_safe_reverse(c,...) S
+|
+list_for_each_entry_safe_reverse(x,c,...) S
+|
+hlist_for_each_entry(c,...) S
+|
+hlist_for_each_entry_continue(c,...) S
+|
+hlist_for_each_entry_from(c,...) S
+|
+hlist_for_each_entry_safe(c,...) S
+|
+list_remove_head(x,c,...)
+|
+sizeof(<+...c...+>)
+|
+&c->member
+|
+c = E
+|
+*c@p2
+)
+
+@script:python depends on org@
+p1 << r.p1;
+p2 << r.p2;
+@@
+
+cocci.print_main("invalid iterator index reference",p2)
+cocci.print_secs("iterator",p1)
+
+@script:python depends on report@
+p1 << r.p1;
+p2 << r.p2;
+@@
+
+msg = "ERROR: invalid reference to the index variable of the iterator on line %s" % (p1[0].line)
+coccilib.report.print_report(p2[0], msg)

