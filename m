Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614Ab0HXPkf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 11:40:35 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:47829 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755455Ab0HXPj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 11:39:57 -0400
From: Nicolas Palix <npalix@diku.dk>
To: Julia Lawall <julia@diku.dk>, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <npalix@diku.dk>, Michal Marek <mmarek@suse.cz>
Cc: cocci@diku.dk, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Nicolas Palix <npalix@diku.dk>
Subject: [PATCH 12/18] Coccinelle: Add api/memdup.cocci
Date: Tue, 24 Aug 2010 17:39:06 +0200
Message-Id: <1282664352-15882-13-git-send-email-npalix@diku.dk>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282664352-15882-1-git-send-email-npalix@diku.dk>
References: <1282664352-15882-1-git-send-email-npalix@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kmemdup rather than duplicating its implementation

Signed-off-by: Nicolas Palix <npalix@diku.dk>
Signed-off-by: Julia Lawall <julia@diku.dk>
---
 scripts/coccinelle/api/memdup.cocci |   40 +++++++++++++++++++++++++++++++++++
 1 files changed, 40 insertions(+), 0 deletions(-)
 create mode 100644 scripts/coccinelle/api/memdup.cocci

diff --git a/scripts/coccinelle/api/memdup.cocci b/scripts/coccinelle/api/memdup.cocci
new file mode 100644
index 0000000..b5d7220
--- /dev/null
+++ b/scripts/coccinelle/api/memdup.cocci
@@ -0,0 +1,40 @@
+/// Use kmemdup rather than duplicating its implementation
+///
+// Confidence: High
+// Copyright: (C) 2010 Nicolas Palix, DIKU.  GPLv2.
+// Copyright: (C) 2010 Julia Lawall, DIKU.  GPLv2.
+// Copyright: (C) 2010 Gilles Muller, INRIA/LiP6.  GPLv2.
+// URL: http://coccinelle.lip6.fr/
+// Comments:
+// Options: -no_includes -include_headers
+
+virtual patch
+
+@r1@
+expression from,to;
+expression flag;
+position p;
+@@
+
+   to = \(kmalloc@p\|kzalloc@p\)(strlen(from) + 1,flag);
+
+@r2@
+expression x,from,to;
+expression flag,E1;
+position p;
+@@
+
+    x = strlen(from) + 1;
+    ... when != \( x = E1 \| from = E1 \)
+    to = \(kmalloc@p\|kzalloc@p\)(x,flag);
+
+@@
+expression from,to,size,flag;
+position p != {r1.p,r2.p};
+statement S;
+@@
+
+-  to = \(kmalloc@p\|kzalloc@p\)(size,flag);
++  to = kmemdup(from,size,flag);
+   if (to==NULL || ...) S
+-  memcpy(to, from, size);
-- 
1.7.0.4

