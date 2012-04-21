Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009Ab2DUSPK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 14:15:10 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:45908 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751769Ab2DUSPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 14:15:06 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: cocci@diku.dk, mmarek@suse.cz, linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Subject: [PATCH] scripts/coccinelle: address test is always true
Date: Sat, 21 Apr 2012 20:14:57 +0200
Message-Id: <1335032098-4966-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 scripts/coccinelle/misc/noderef.cocci |   65 ++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/scripts/coccinelle/misc/noderef.cocci b/scripts/coccinelle/misc/noderef.cocci
new file mode 100644
index 0000000..c170721
--- /dev/null
+++ b/scripts/coccinelle/misc/noderef.cocci
@@ -0,0 +1,65 @@
+/// sizeof when applied to a pointer typed expression gives the size of
+/// the pointer
+///
+// Confidence: High
+// Copyright: (C) 2012 Julia Lawall, INRIA/LIP6.  GPLv2.
+// Copyright: (C) 2012 Gilles Muller, INRIA/LiP6.  GPLv2.
+// URL: http://coccinelle.lip6.fr/
+// Comments:
+// Options: -no_includes -include_headers
+
+virtual org
+virtual report
+virtual context
+virtual patch
+
+@depends on patch@
+expression *x;
+expression f;
+type T;
+@@
+
+(
+x = <+... sizeof(
+- x
++ *x
+   ) ...+>
+|
+f(...,(T)(x),...,sizeof(
+- x
++ *x
+   ),...)
+|
+f(...,sizeof(x),...,(T)(
+- x
++ *x
+   ),...)
+)
+
+@r depends on !patch@
+expression *x;
+expression f;
+position p;
+type T;
+@@
+
+(
+*x = <+... sizeof@p(x) ...+>
+|
+*f(...,(T)(x),...,sizeof@p(x),...)
+|
+*f(...,sizeof@p(x),...,(T)(x),...)
+)
+
+@script:python depends on org@
+p << r.p;
+@@
+
+cocci.print_main("application of sizeof to pointer",p)
+
+@script:python depends on report@
+p << r.p;
+@@
+
+msg = "ERROR: application of sizeof to pointer"
+coccilib.report.print_report(p[0],msg)

