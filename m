Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397Ab2CXVbf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 17:31:35 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:55601 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035Ab2CXVbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 17:31:18 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <npalix.work@gmail.com>, cocci@diku.dk,
        linux-kernel@vger.kernel.org, mmarek@suse.cz
Cc: kernel-janitors@vger.kernel.org
Subject: [PATCH] scripts/coccinelle: semantic patch for ptr_err
Date: Sat, 24 Mar 2012 22:31:10 +0100
Message-Id: <1332624670-23679-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 scripts/coccinelle/api/ptr_ret.cocci |   70 +++++++++++++++++++++++++++++++++++
 1 file changed, 70 insertions(+)

diff --git a/scripts/coccinelle/api/ptr_ret.cocci b/scripts/coccinelle/api/ptr_ret.cocci
new file mode 100644
index 0000000..085120f
--- /dev/null
+++ b/scripts/coccinelle/api/ptr_ret.cocci
@@ -0,0 +1,70 @@
+///
+/// Use PTR_RET rather than if(IS_ERR(...)) + PTR_ERR
+///
+// Confidence: High
+// Copyright: (C) 2012 Julia Lawall, INRIA/LIP6.  GPLv2.
+// Copyright: (C) 2012 Gilles Muller, INRIA/LiP6.  GPLv2.
+// URL: http://coccinelle.lip6.fr/
+// Options: -no_includes -include_headers
+//
+// Keywords: ERR_PTR, PTR_ERR, PTR_RET
+// Version min: 2.6.39
+//
+
+virtual context
+virtual patch
+virtual org
+virtual report
+
+@depends on patch@
+expression ptr;
+@@
+
+- if (IS_ERR(ptr)) return PTR_ERR(ptr); else return 0;
++ return PTR_RET(ptr);
+
+@depends on patch@
+expression ptr;
+@@
+
+- if (IS_ERR(ptr)) return PTR_ERR(ptr); return 0;
++ return PTR_RET(ptr);
+
+@r1 depends on !patch@
+expression ptr;
+position p1;
+@@
+
+* if@p1 (IS_ERR(ptr)) return PTR_ERR(ptr); else return 0;
+
+@r2 depends on !patch@
+expression ptr;
+position p2;
+@@
+
+* if@p2 (IS_ERR(ptr)) return PTR_ERR(ptr); return 0;
+
+@script:python depends on org@
+p << r1.p1;
+@@
+
+coccilib.org.print_todo(p[0], "WARNING: PTR_ERR can be used")
+
+
+@script:python depends on org@
+p << r2.p2;
+@@
+
+coccilib.org.print_todo(p[0], "WARNING: PTR_ERR can be used")
+
+@script:python depends on report@
+p << r1.p1;
+@@
+
+coccilib.report.print_report(p[0], "WARNING: PTR_ERR can be used")
+
+@script:python depends on report@
+p << r2.p2;
+@@
+
+coccilib.report.print_report(p[0], "WARNING: PTR_ERR can be used")

