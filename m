Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758676Ab1FKP3v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 11:29:51 -0400
Received: from mta31.charter.net ([216.33.127.82]:59418 "EHLO
	mta31.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758656Ab1FKP3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 11:29:49 -0400
X-Authority-Analysis: v=1.1 cv=vT9vkN3vVXssH3Ov7r/wQUs/sfIFjNPEFFf4aeKIi4A=
 c=1 sm=1 a=NGGmEQNDVJIA:10 a=lDGNyK2vIvEA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:17
 a=Ti-l2rNWsRaBP1mDtNEA:9 a=xzrYXqw+0zwiO4gHSXHcAg==:117
From: Greg Dietsche <Gregory.Dietsche@cuw.edu>
To: julia@diku.dk
Cc: Nicolas.Palix@inria.fr, rdunlap@xenotime.net, Gilles.Muller@lip6.fr,
        cocci@diku.dk, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Dietsche <Gregory.Dietsche@cuw.edu>
Subject: [PATCH 1/2 V2] coccicheck: add M= option to control which dir is processed
Date: Sat, 11 Jun 2011 10:29:33 -0500
Message-Id: <1307806173-24964-1-git-send-email-Gregory.Dietsche@cuw.edu>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <BANLkTi=gZzsZcSKUd3x50PbPwKC-Vnj24Q@mail.gmail.com>
References: <BANLkTi=gZzsZcSKUd3x50PbPwKC-Vnj24Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Examples:
	make coccicheck M=drivers/net/wireless/
	make coccicheck SUBDIRS=drivers/net/wireless/

Version 2:
	fix patch file names when using M=
	tell coccinelle where the include files are

Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
---
 scripts/coccicheck |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/scripts/coccicheck b/scripts/coccicheck
index 1bb1a1b..1ceecdf 100755
--- a/scripts/coccicheck
+++ b/scripts/coccicheck
@@ -10,13 +10,22 @@ if [ "$C" = "1" -o "$C" = "2" ]; then
 #    OPTIONS=$*
 
 # Workaround for Coccinelle < 0.2.3
-    FLAGS="-I $srctree/include -very_quiet"
+    if [ "$KBUILD_EXTMOD" = "" ] ; then
+        FLAGS="-I $srctree/include -very_quiet"
+    else
+	    echo 'M= is only supported for Coccinelle >= 0.2.3'
+	    exit 1
+    fi
     shift $(( $# - 1 ))
     OPTIONS=$1
 else
     ONLINE=0
     FLAGS="-very_quiet"
-    OPTIONS="-dir $srctree"
+    if [ "$KBUILD_EXTMOD" = "" ] ; then
+        OPTIONS="-dir $srctree"
+    else
+        OPTIONS="-dir $KBUILD_EXTMOD -patch $srctree -I $srctree/include"
+    fi
 fi
 
 if [ ! -x "$SPATCH" ]; then
-- 
1.7.2.5

