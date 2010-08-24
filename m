Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072Ab0HXPkt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 11:40:49 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:47853 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755459Ab0HXPkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 11:40:00 -0400
From: Nicolas Palix <npalix@diku.dk>
To: Julia Lawall <julia@diku.dk>, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <npalix@diku.dk>, Michal Marek <mmarek@suse.cz>
Cc: cocci@diku.dk, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Nicolas Palix <npalix@diku.dk>
Subject: [PATCH 14/18] Coccinelle: Move err_cast.cocci to the api directory
Date: Tue, 24 Aug 2010 17:39:08 +0200
Message-Id: <1282664352-15882-15-git-send-email-npalix@diku.dk>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282664352-15882-1-git-send-email-npalix@diku.dk>
References: <1282664352-15882-1-git-send-email-npalix@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nicolas Palix <npalix@diku.dk>
Signed-off-by: Julia Lawall <julia@diku.dk>
---
 scripts/coccinelle/api/err_cast.cocci |   56 +++++++++++++++++++++++++++++++++
 scripts/coccinelle/err_cast.cocci     |   56 ---------------------------------
 2 files changed, 56 insertions(+), 56 deletions(-)
 create mode 100644 scripts/coccinelle/api/err_cast.cocci
 delete mode 100644 scripts/coccinelle/err_cast.cocci

diff --git a/scripts/coccinelle/api/err_cast.cocci b/scripts/coccinelle/api/err_cast.cocci
new file mode 100644
index 0000000..2ce1150
--- /dev/null
+++ b/scripts/coccinelle/api/err_cast.cocci
@@ -0,0 +1,56 @@
+///
+/// Use ERR_CAST inlined function instead of ERR_PTR(PTR_ERR(...))
+///
+// Confidence: High
+// Copyright: (C) 2009, 2010 Nicolas Palix, DIKU.  GPLv2.
+// Copyright: (C) 2009, 2010 Julia Lawall, DIKU.  GPLv2.
+// Copyright: (C) 2009, 2010 Gilles Muller, INRIA/LiP6.  GPLv2.
+// URL: http://coccinelle.lip6.fr/
+// Options:
+//
+// Keywords: ERR_PTR, PTR_ERR, ERR_CAST
+// Version min: 2.6.25
+//
+
+virtual context
+virtual patch
+virtual org
+virtual report
+
+
+@ depends on context && !patch && !org && !report@
+expression x;
+@@
+
+* ERR_PTR(PTR_ERR(x))
+
+@ depends on !context && patch && !org && !report @
+expression x;
+@@
+
+- ERR_PTR(PTR_ERR(x))
++ ERR_CAST(x)
+
+@r depends on !context && !patch && (org || report)@
+expression x;
+position p;
+@@
+
+ ERR_PTR@p(PTR_ERR(x))
+
+@script:python depends on org@
+p << r.p;
+x << r.x;
+@@
+
+msg="WARNING ERR_CAST can be used with %s" % (x)
+msg_safe=msg.replace("[","@(").replace("]",")")
+coccilib.org.print_todo(p[0], msg_safe)
+
+@script:python depends on report@
+p << r.p;
+x << r.x;
+@@
+
+msg="WARNING: ERR_CAST can be used with %s" % (x)
+coccilib.report.print_report(p[0], msg)
diff --git a/scripts/coccinelle/err_cast.cocci b/scripts/coccinelle/err_cast.cocci
deleted file mode 100644
index 2ce1150..0000000
--- a/scripts/coccinelle/err_cast.cocci
+++ /dev/null
@@ -1,56 +0,0 @@
-///
-/// Use ERR_CAST inlined function instead of ERR_PTR(PTR_ERR(...))
-///
-// Confidence: High
-// Copyright: (C) 2009, 2010 Nicolas Palix, DIKU.  GPLv2.
-// Copyright: (C) 2009, 2010 Julia Lawall, DIKU.  GPLv2.
-// Copyright: (C) 2009, 2010 Gilles Muller, INRIA/LiP6.  GPLv2.
-// URL: http://coccinelle.lip6.fr/
-// Options:
-//
-// Keywords: ERR_PTR, PTR_ERR, ERR_CAST
-// Version min: 2.6.25
-//
-
-virtual context
-virtual patch
-virtual org
-virtual report
-
-
-@ depends on context && !patch && !org && !report@
-expression x;
-@@
-
-* ERR_PTR(PTR_ERR(x))
-
-@ depends on !context && patch && !org && !report @
-expression x;
-@@
-
-- ERR_PTR(PTR_ERR(x))
-+ ERR_CAST(x)
-
-@r depends on !context && !patch && (org || report)@
-expression x;
-position p;
-@@
-
- ERR_PTR@p(PTR_ERR(x))
-
-@script:python depends on org@
-p << r.p;
-x << r.x;
-@@
-
-msg="WARNING ERR_CAST can be used with %s" % (x)
-msg_safe=msg.replace("[","@(").replace("]",")")
-coccilib.org.print_todo(p[0], msg_safe)
-
-@script:python depends on report@
-p << r.p;
-x << r.x;
-@@
-
-msg="WARNING: ERR_CAST can be used with %s" % (x)
-coccilib.report.print_report(p[0], msg)
-- 
1.7.0.4

