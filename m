Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814Ab1COWxa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 18:53:30 -0400
Received: from shutemov.name ([188.40.19.243]:49766 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754523Ab1COWx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 18:53:27 -0400
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: linux-kernel@vger.kernel.org
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, Julia Lawall <julia@diku.dk>,
        Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <npalix.work@gmail.com>, cocci@diku.dk
Subject: [PATCH 01/13] Coccinelle: introduce list_move.cocci
Date: Wed, 16 Mar 2011 00:53:13 +0200
Message-Id: <1300229605-14499-1-git-send-email-kirill@shutemov.name>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use list_move instead of combination of list_del() and list_add()

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Julia Lawall <julia@diku.dk>
Cc: Gilles Muller <Gilles.Muller@lip6.fr>
Cc: Nicolas Palix <npalix.work@gmail.com>
Cc: cocci@diku.dk
---
 scripts/coccinelle/api/list/list_move.cocci |   41 +++++++++++++++++++++++++++
 1 files changed, 41 insertions(+), 0 deletions(-)
 create mode 100644 scripts/coccinelle/api/list/list_move.cocci

diff --git a/scripts/coccinelle/api/list/list_move.cocci b/scripts/coccinelle/api/list/list_move.cocci
new file mode 100644
index 0000000..2691a8a
--- /dev/null
+++ b/scripts/coccinelle/api/list/list_move.cocci
@@ -0,0 +1,41 @@
+///
+/// Use list_move() instead of combination of list_del() and list_add()
+///
+// Confidence: High
+// Copyright: (C) 2011 Kirill A. Shutemov. GPLv2.
+// Options: -no_includes -include_headers
+
+virtual context
+virtual patch
+virtual org
+virtual report
+
+@depends on context@
+expression a, b;
+@@
+
+* list_del(a);
+* list_add(a, b);
+
+@depends on patch@
+expression a, b;
+@@
+
+- list_del(a);
+- list_add(a, b);
++ list_move(a, b);
+
+@r depends on report || org@
+expression a, b;
+position p;
+@@
+
+ list_del@p(a);
+ list_add(a, b);
+
+@script:python depends on org || report@
+p << r.p;
+@@
+
+msg = "WARNING: list_move() can be used"
+coccilib.report.print_report(p[0], msg)
-- 
1.7.4.1

