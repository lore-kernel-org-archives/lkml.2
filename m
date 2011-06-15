Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847Ab1FOPui (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 11:50:38 -0400
Received: from mta11.charter.net ([216.33.127.80]:42089 "EHLO
	mta11.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602Ab1FOPuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 11:50:35 -0400
X-Authority-Analysis: v=1.1 cv=G6Q69DB3AUoJKS2BpLRaz8MQ2NORN7h5HRzrJMPOhRw=
 c=1 sm=1 a=1NVEaLgIGKwA:10 a=lDGNyK2vIvEA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:17
 a=xNjWJ0b5AAAA:8 a=sfixp58IecoE5NrtG7sA:9 a=xzrYXqw+0zwiO4gHSXHcAg==:117
From: Greg Dietsche <Gregory.Dietsche@cuw.edu>
To: julia@diku.dk
Cc: Gilles.Muller@lip6.fr, npalix.work@gmail.com, cocci@diku.dk,
        linux-kernel@vger.kernel.org, Greg Dietsche <Gregory.Dietsche@cuw.edu>
Subject: [PATCH v4] coccinelle: if (ret) return ret; return ret; semantic patch
Date: Wed, 15 Jun 2011 10:50:11 -0500
Message-Id: <1308153011-8089-1-git-send-email-Gregory.Dietsche@cuw.edu>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1308101355-5009-1-git-send-email-Gregory.Dietsche@cuw.edu>
References: <1308101355-5009-1-git-send-email-Gregory.Dietsche@cuw.edu>
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
	Incorporate more review comments from Julia.

Version 4:
	Add -return ret; +return ret; back to the script
	as this improves Coccinelle's handling of white
	space for this patch.

Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
---
 scripts/coccinelle/misc/doublereturn.cocci |   32 ++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)
 create mode 100644 scripts/coccinelle/misc/doublereturn.cocci

diff --git a/scripts/coccinelle/misc/doublereturn.cocci b/scripts/coccinelle/misc/doublereturn.cocci
new file mode 100644
index 0000000..3fe40f8
--- /dev/null
+++ b/scripts/coccinelle/misc/doublereturn.cocci
@@ -0,0 +1,32 @@
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
+-return ret;
++return ret;
-- 
1.7.2.5

