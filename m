Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab1FOB31 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 21:29:27 -0400
Received: from mta11.charter.net ([216.33.127.80]:33037 "EHLO
	mta11.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245Ab1FOB30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 21:29:26 -0400
X-Authority-Analysis: v=1.1 cv=vT9vkN3vVXssH3Ov7r/wQUs/sfIFjNPEFFf4aeKIi4A=
 c=1 sm=1 a=uU8PZlKoZGMA:10 a=lDGNyK2vIvEA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:17
 a=xNjWJ0b5AAAA:8 a=kAfBJRREyENIO28VJZoA:9 a=xzrYXqw+0zwiO4gHSXHcAg==:117
From: Greg Dietsche <Gregory.Dietsche@cuw.edu>
To: julia@diku.dk
Cc: Gilles.Muller@lip6.fr, npalix.work@gmail.com, cocci@diku.dk,
        linux-kernel@vger.kernel.org, Greg Dietsche <Gregory.Dietsche@cuw.edu>
Subject: [PATCH v3] coccinelle: if (ret) return ret; return ret; semantic patch
Date: Tue, 14 Jun 2011 20:29:15 -0500
Message-Id: <1308101355-5009-1-git-send-email-Gregory.Dietsche@cuw.edu>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <Pine.LNX.4.64.1106132033460.24125@ask.diku.dk>
References: <Pine.LNX.4.64.1106132033460.24125@ask.diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Semantic patch to find code that matches this pattern:
	if (...) return ret;
	return ret;

Version 2:
	Incorporate review comments from Julia Lawall
	Add matches for a number of other similar patterns.

Version 3:
	Incorporating more review comments from Julia.

Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
---
 scripts/coccinelle/misc/doublereturn.cocci |   31 ++++++++++++++++++++++++++++
 1 files changed, 31 insertions(+), 0 deletions(-)
 create mode 100644 scripts/coccinelle/misc/doublereturn.cocci

diff --git a/scripts/coccinelle/misc/doublereturn.cocci b/scripts/coccinelle/misc/doublereturn.cocci
new file mode 100644
index 0000000..2de8564
--- /dev/null
+++ b/scripts/coccinelle/misc/doublereturn.cocci
@@ -0,0 +1,31 @@
+// Removing unecessary code that matches this core pattern:
+//	-if(...) return ret;
+//	return ret;
+//
+// Confidence: High
+// Copyright: (C) 2011 Greg Dietsche GPLv2.
+// URL: http://www.gregd.org
+// Comments:
+// Options: -no_includes
+
+virtual patch
+
+@depends on patch@
+expression ret;
+identifier x, y;
+identifier f;
+identifier is_ordinal_table ~= "IS_ORDINAL_TABLE_\(ONE\|TWO\)";
+@@
+(
+//via an isomorphism this also covers x and unlikely(x)
+-if (likely(x)) return ret;
+|
+-if (\(IS_ERR\|IS_ZERO\)(x)) return ret;
+|
+-if (is_ordinal_table(x,y)) return ret;
+|
+if(<+...f(...)...+>) return ret;
+|
+-if (...) return ret;
+)
+return ret;
-- 
1.7.2.5

