Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab2ATXmP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 18:42:15 -0500
Received: from que21.charter.net ([209.225.8.22]:52255 "EHLO que21.charter.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049Ab2ATXmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 18:42:10 -0500
X-Authority-Analysis: v=1.1 cv=rvNqJbVGdbt4egs52VbhtoJZG7AoPDG9H2iogr/sNfs=
 c=1 sm=1 a=NaMn599R75wA:10 a=lDGNyK2vIvEA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:17
 a=Zlvplbn0pptQHqOZtSYA:9 a=xzrYXqw+0zwiO4gHSXHcAg==:117
From: Greg Dietsche <Gregory.Dietsche@cuw.edu>
To: Brice.Goglin@inria.fr, julia.lawall@lip6.fr, mmarek@suse.cz
Cc: linux-kernel@vger.kernel.org, Greg Dietsche <Gregory.Dietsche@cuw.edu>
Subject: [PATCH] coccicheck: change handling of C={1,2} when M= is set
Date: Fri, 20 Jan 2012 17:10:35 -0600
Message-Id: <1327101035-7684-2-git-send-email-Gregory.Dietsche@cuw.edu>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1327101035-7684-1-git-send-email-Gregory.Dietsche@cuw.edu>
References: <4F1928FC.8090300@inria.fr>
 <1327101035-7684-1-git-send-email-Gregory.Dietsche@cuw.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch reverts a portion of d0bc1fb4 so that coccicheck will
work properly when C=1 or C=2.

Reported-by: Brice Goglin <Brice.Goglin@inria.fr>
Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
---
 scripts/coccicheck |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/scripts/coccicheck b/scripts/coccicheck
index 3c27764..823e972 100755
--- a/scripts/coccicheck
+++ b/scripts/coccicheck
@@ -9,15 +9,10 @@ if [ "$C" = "1" -o "$C" = "2" ]; then
 #    FLAGS="-ignore_unknown_options -very_quiet"
 #    OPTIONS=$*
 
-    if [ "$KBUILD_EXTMOD" = "" ] ; then
-        # Workaround for Coccinelle < 0.2.3
-        FLAGS="-I $srctree/include -very_quiet"
-        shift $(( $# - 1 ))
-        OPTIONS=$1
-    else
-	echo M= is not currently supported when C=1 or C=2
-	exit 1
-    fi
+# Workaround for Coccinelle < 0.2.3
+	FLAGS="-I $srctree/include -very_quiet"
+	shift $(( $# - 1 ))
+	OPTIONS=$1
 else
     ONLINE=0
     FLAGS="-very_quiet"
-- 
1.7.6.4

