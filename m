Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803Ab1KFCnG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 22:43:06 -0400
Received: from que11.charter.net ([209.225.8.21]:56308 "EHLO que11.charter.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424Ab1KFCnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 22:43:04 -0400
X-Authority-Analysis: v=1.1 cv=6DnK9SlspjQUafU6MzYmZAt1wpB1MUaNH28Mo/Kfxqk=
 c=1 sm=1 a=f4rVMxkQ01QA:10 a=lDGNyK2vIvEA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:17
 a=QC6DmiQ5i6ZtQVrIgJwA:9 a=xzrYXqw+0zwiO4gHSXHcAg==:117
From: Gregory.Dietsche@cuw.edu
To: julia@diku.dk, mmarek@suse.cz
Cc: rdunlap@xenotime.net, Gilles.Muller@lip6.fr, npalix.work@gmail.com,
        cocci@diku.dk, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Dietsche <Gregory.Dietsche@cuw.edu>
Subject: [RESEND 1/2] coccicheck: add M= option to control which dir is processed
Date: Sat,  5 Nov 2011 20:59:43 -0500
Message-Id: <1320544784-24576-2-git-send-email-Gregory.Dietsche@cuw.edu>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1320544784-24576-1-git-send-email-Gregory.Dietsche@cuw.edu>
References: <1320544784-24576-1-git-send-email-Gregory.Dietsche@cuw.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Dietsche <Gregory.Dietsche@cuw.edu>

Examples:
	make coccicheck M=drivers/net/wireless/
	make coccicheck SUBDIRS=drivers/net/wireless/

Version 2:
	fix patch file names when using M=
	tell coccinelle where the include files are

Version 3:
	Add second include option to support out of tree development
	Fix error message

Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
---
 scripts/coccicheck |   19 ++++++++++++++-----
 1 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/scripts/coccicheck b/scripts/coccicheck
index 1bb1a1b..3c27764 100755
--- a/scripts/coccicheck
+++ b/scripts/coccicheck
@@ -9,14 +9,23 @@ if [ "$C" = "1" -o "$C" = "2" ]; then
 #    FLAGS="-ignore_unknown_options -very_quiet"
 #    OPTIONS=$*
 
-# Workaround for Coccinelle < 0.2.3
-    FLAGS="-I $srctree/include -very_quiet"
-    shift $(( $# - 1 ))
-    OPTIONS=$1
+    if [ "$KBUILD_EXTMOD" = "" ] ; then
+        # Workaround for Coccinelle < 0.2.3
+        FLAGS="-I $srctree/include -very_quiet"
+        shift $(( $# - 1 ))
+        OPTIONS=$1
+    else
+	echo M= is not currently supported when C=1 or C=2
+	exit 1
+    fi
 else
     ONLINE=0
     FLAGS="-very_quiet"
-    OPTIONS="-dir $srctree"
+    if [ "$KBUILD_EXTMOD" = "" ] ; then
+        OPTIONS="-dir $srctree"
+    else
+        OPTIONS="-dir $KBUILD_EXTMOD -patch $srctree -I $srctree/include -I $KBUILD_EXTMOD/include"
+    fi
 fi
 
 if [ ! -x "$SPATCH" ]; then
-- 
1.7.6.4

