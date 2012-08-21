Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598Ab2HUIuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 04:50:20 -0400
Received: from smtp-out-188.synserver.de ([212.40.185.188]:1086 "EHLO
	smtp-out-188.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037Ab2HUIuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 04:50:14 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 6848
From: Lars-Peter Clausen <lars@metafoo.de>
To: Julia Lawall <julia@diku.dk>
Cc: cocci@diku.dk, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] scripts/coccinelle: ptr_ret: Add ternary operator version
Date: Tue, 21 Aug 2012 10:49:58 +0200
Message-Id: <1345538998-24600-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a ternary operator version of the open-coded PTR_RET().

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 scripts/coccinelle/api/ptr_ret.cocci |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/scripts/coccinelle/api/ptr_ret.cocci b/scripts/coccinelle/api/ptr_ret.cocci
index cbfd08c..15f076f 100644
--- a/scripts/coccinelle/api/ptr_ret.cocci
+++ b/scripts/coccinelle/api/ptr_ret.cocci
@@ -30,6 +30,13 @@ expression ptr;
 - if (IS_ERR(ptr)) return PTR_ERR(ptr); return 0;
 + return PTR_RET(ptr);
 
+@depends on patch@
+expression ptr;
+@@
+
+- (IS_ERR(ptr) ? PTR_ERR(ptr) : 0)
++ PTR_RET(ptr)
+
 @r1 depends on !patch@
 expression ptr;
 position p1;
@@ -44,6 +51,13 @@ position p2;
 
 * if@p2 (IS_ERR(ptr)) return PTR_ERR(ptr); return 0;
 
+@r3 depends on !patch@
+expression ptr;
+position p3;
+@@
+
+* IS_ERR@p3(ptr) ? PTR_ERR(ptr) : 0
+
 @script:python depends on org@
 p << r1.p1;
 @@
@@ -57,6 +71,12 @@ p << r2.p2;
 
 coccilib.org.print_todo(p[0], "WARNING: PTR_RET can be used")
 
+@script:python depends on org@
+p << r3.p3;
+@@
+
+coccilib.org.print_todo(p[0], "WARNING: PTR_RET can be used")
+
 @script:python depends on report@
 p << r1.p1;
 @@
@@ -68,3 +88,9 @@ p << r2.p2;
 @@
 
 coccilib.report.print_report(p[0], "WARNING: PTR_RET can be used")
+
+@script:python depends on report@
+p << r3.p3;
+@@
+
+coccilib.report.print_report(p[0], "WARNING: PTR_RET can be used")
-- 
1.7.2.5

