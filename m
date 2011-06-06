Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab1FFA10 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 20:27:26 -0400
Received: from mta31.charter.net ([216.33.127.82]:45880 "EHLO
	mta31.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075Ab1FFA1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 20:27:25 -0400
X-Authority-Analysis: v=1.1 cv=vT9vkN3vVXssH3Ov7r/wQUs/sfIFjNPEFFf4aeKIi4A=
 c=1 sm=1 a=9up4Fw51I5kA:10 a=lDGNyK2vIvEA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:17
 a=xNjWJ0b5AAAA:8 a=VfXdpR8r6s7yCdZuuO4A:9 a=xzrYXqw+0zwiO4gHSXHcAg==:117
From: Greg Dietsche <Gregory.Dietsche@cuw.edu>
To: julia@diku.dk
Cc: Gilles.Muller@lip6.fr, npalix.work@gmail.com, cocci@diku.dk,
        linux-kernel@vger.kernel.org, Greg Dietsche <Gregory.Dietsche@cuw.edu>
Subject: [PATCH] coccinelle: if(ret)return ret; return ret; semantic patch
Date: Sun,  5 Jun 2011 19:26:52 -0500
Message-Id: <1307320012-31292-1-git-send-email-Gregory.Dietsche@cuw.edu>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This semantic patch finds code matching this pattern:
	if(ret)
		return ret;
	return ret;

I will be submitting patches shortly against the mainline to cleanup all
code matching this pattern.

Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
---
 scripts/coccinelle/misc/doublereturn.cocci |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)
 create mode 100644 scripts/coccinelle/misc/doublereturn.cocci

diff --git a/scripts/coccinelle/misc/doublereturn.cocci b/scripts/coccinelle/misc/doublereturn.cocci
new file mode 100644
index 0000000..656a118
--- /dev/null
+++ b/scripts/coccinelle/misc/doublereturn.cocci
@@ -0,0 +1,20 @@
+/// Remove unecessary if/return in code that follows this pattern:
+///	if(retval)
+///		return retval;
+///	return retval;
+//
+// Confidence: High
+// Copyright: (C) 2011 Greg Dietsche GPLv2.
+// URL: http://www.gregd.org
+// Comments:
+// Options: -no_includes
+
+virtual patch
+
+@@
+identifier retval;
+@@
+-if (retval)
+-	return retval;
+-return retval;
++return retval;
-- 
1.7.2.5

