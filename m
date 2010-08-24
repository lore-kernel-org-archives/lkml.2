Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510Ab0HXPkM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 11:40:12 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:47804 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755451Ab0HXPjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 11:39:53 -0400
From: Nicolas Palix <npalix@diku.dk>
To: Julia Lawall <julia@diku.dk>, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <npalix@diku.dk>, Michal Marek <mmarek@suse.cz>
Cc: cocci@diku.dk, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Nicolas Palix <npalix@diku.dk>
Subject: [PATCH 07/18] Coccinelle: Add iterators/fen.cocci
Date: Tue, 24 Aug 2010 17:39:01 +0200
Message-Id: <1282664352-15882-8-git-send-email-npalix@diku.dk>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282664352-15882-1-git-send-email-npalix@diku.dk>
References: <1282664352-15882-1-git-send-email-npalix@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

for_each_node iterators only exit normally when the loop cursor is
NULL, so there is no point to call of_node_put on the final value.

Signed-off-by: Nicolas Palix <npalix@diku.dk>
Signed-off-by: Julia Lawall <julia@diku.dk>
---
 scripts/coccinelle/iterators/fen.cocci |   64 ++++++++++++++++++++++++++++++++
 1 files changed, 64 insertions(+), 0 deletions(-)
 create mode 100644 scripts/coccinelle/iterators/fen.cocci

diff --git a/scripts/coccinelle/iterators/fen.cocci b/scripts/coccinelle/iterators/fen.cocci
new file mode 100644
index 0000000..77bc108
--- /dev/null
+++ b/scripts/coccinelle/iterators/fen.cocci
@@ -0,0 +1,64 @@
+/// These iterators only exit normally when the loop cursor is NULL, so there
+/// is no point to call of_node_put on the final value.
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
+@@
+iterator name for_each_node_by_name;
+expression np,E;
+identifier l;
+@@
+
+for_each_node_by_name(np,...) {
+  ... when != break;
+      when != goto l;
+}
+... when != np = E
+- of_node_put(np);
+
+@@
+iterator name for_each_node_by_type;
+expression np,E;
+identifier l;
+@@
+
+for_each_node_by_type(np,...) {
+  ... when != break;
+      when != goto l;
+}
+... when != np = E
+- of_node_put(np);
+
+@@
+iterator name for_each_compatible_node;
+expression np,E;
+identifier l;
+@@
+
+for_each_compatible_node(np,...) {
+  ... when != break;
+      when != goto l;
+}
+... when != np = E
+- of_node_put(np);
+
+@@
+iterator name for_each_matching_node;
+expression np,E;
+identifier l;
+@@
+
+for_each_matching_node(np,...) {
+  ... when != break;
+      when != goto l;
+}
+... when != np = E
+- of_node_put(np);
-- 
1.7.0.4

