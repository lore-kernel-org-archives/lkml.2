Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939Ab2KCUCV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 16:02:21 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:28193 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750915Ab2KCUCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 16:02:20 -0400
X-IronPort-AV: E=Sophos;i="4.80,705,1344204000"; 
   d="scan'208";a="180005632"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Michal Marek <mmarek@suse.cz>
Cc: kernel-janitors@vger.kernel.org, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, cocci@systeme.lip6.fr,
        linux-kernel@vger.kernel.org
Subject: [PATCH] scripts/coccinelle/misc/warn.cocci: use WARN
Date: Sat,  3 Nov 2012 21:02:09 +0100
Message-Id: <1351972929-7448-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Use WARN(1,...) rather than printk followed by WARN(1).

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 scripts/coccinelle/misc/warn.cocci |  109 +++++++++++++++++++++++++++++++++++++
 1 file changed, 109 insertions(+)

diff --git a/scripts/coccinelle/misc/warn.cocci b/scripts/coccinelle/misc/warn.cocci
new file mode 100644
index 0000000..fda8c35
--- /dev/null
+++ b/scripts/coccinelle/misc/warn.cocci
@@ -0,0 +1,109 @@
+/// Use WARN(1,...) rather than printk followed by WARN_ON(1)
+///
+// Confidence: High
+// Copyright: (C) 2012 Julia Lawall, INRIA/LIP6.  GPLv2.
+// Copyright: (C) 2012 Gilles Muller, INRIA/LiP6.  GPLv2.
+// URL: http://coccinelle.lip6.fr/
+// Comments:
+// Options: -no_includes -include_headers
+
+virtual patch
+virtual context
+virtual org
+virtual report
+
+@bad1@
+position p;
+@@
+
+printk(...);
+printk@p(...);
+WARN_ON(1);
+
+@r1 depends on context || report || org@
+position p != bad1.p;
+@@
+
+ printk@p(...);
+*WARN_ON(1);
+
+@script:python depends on org@
+p << r1.p;
+@@
+
+cocci.print_main("printk + WARN_ON can be just WARN",p)
+
+@script:python depends on report@
+p << r1.p;
+@@
+
+msg = "SUGGESTION: printk + WARN_ON can be just WARN"
+coccilib.report.print_report(p[0],msg)
+
+@ok1 depends on patch@
+expression list es;
+position p != bad1.p;
+@@
+
+-printk@p(
++WARN(1,
+  es);
+-WARN_ON(1);
+
+@depends on patch@
+expression list ok1.es;
+@@
+
+if (...)
+- {
+  WARN(1,es);
+- }
+
+// --------------------------------------------------------------------
+
+@bad2@
+position p;
+@@
+
+printk(...);
+printk@p(...);
+WARN_ON_ONCE(1);
+
+@r2 depends on context || report || org@
+position p != bad1.p;
+@@
+
+ printk@p(...);
+*WARN_ON_ONCE(1);
+
+@script:python depends on org@
+p << r2.p;
+@@
+
+cocci.print_main("printk + WARN_ON_ONCE can be just WARN_ONCE",p)
+
+@script:python depends on report@
+p << r2.p;
+@@
+
+msg = "SUGGESTION: printk + WARN_ON_ONCE can be just WARN_ONCE"
+coccilib.report.print_report(p[0],msg)
+
+@ok2 depends on patch@
+expression list es;
+position p != bad2.p;
+@@
+
+-printk@p(
++WARN_ONCE(1,
+  es);
+-WARN_ON_ONCE(1);
+
+@depends on patch@
+expression list ok2.es;
+@@
+
+if (...)
+- {
+  WARN_ONCE(1,es);
+- }

