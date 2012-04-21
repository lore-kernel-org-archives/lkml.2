Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881Ab2DUSPI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 14:15:08 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:45909 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768Ab2DUSPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 14:15:06 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: cocci@diku.dk, mmarek@suse.cz, linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Subject: [PATCH] scripts/coccinelle: address test is always true
Date: Sat, 21 Apr 2012 20:14:58 +0200
Message-Id: <1335032098-4966-2-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 scripts/coccinelle/misc/ifaddr.cocci |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/scripts/coccinelle/misc/ifaddr.cocci b/scripts/coccinelle/misc/ifaddr.cocci
new file mode 100644
index 0000000..3e4089a
--- /dev/null
+++ b/scripts/coccinelle/misc/ifaddr.cocci
@@ -0,0 +1,35 @@
+/// the address of a variable or field is non-zero is likely always to bo
+/// non-zero
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
+
+@r@
+expression x;
+statement S1,S2;
+position p;
+@@
+
+*if@p (&x)
+ S1 else S2
+
+@script:python depends on org@
+p << r.p;
+@@
+
+cocci.print_main("test of a variable/field address",p)
+
+@script:python depends on report@
+p << r.p;
+@@
+
+msg = "ERROR: test of a variable/field address"
+coccilib.report.print_report(p[0],msg)

