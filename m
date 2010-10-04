Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332Ab0JDV0w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 17:26:52 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62364 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab0JDV0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 17:26:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=MnpZ7X7mDmCevpFPjw1SGSTVtjzQdNDjyUtGrHDRaGVBYNNxmLWOYhl10mqIgWBYXr
         pL8LX5wuh5+fBsCxLiYqtB+AlNWN/3w7qI+U3tlkQh3VrMtW5gsGVGkABfaVerZ1r8PB
         W7FwbGiEJY8kryVuvSI0o9fG8uWJRQXY2eIEw=
From: Nicolas Palix <npalix.work@gmail.com>
To: Julia Lawall <julia@diku.dk>, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <npalix@diku.dk>, Michal Marek <mmarek@suse.cz>,
        Sam Ravnborg <sam@ravnborg.org>, Joerg Roedel <joerg.roedel@amd.com>,
        cocci@diku.dk, linux-kernel@vger.kernel.org
Subject: [PATCH V2] Coccinelle: Use the -no-show-diff option for org and report mode
Date: Mon,  4 Oct 2010 23:26:35 +0200
Message-Id: <1286227595-22488-1-git-send-email-npalix.work@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows to write the semantic patches with code sharing
for the matching parts.

Signed-off-by: Nicolas Palix <npalix.work@gmail.com>
Signed-off-by: Julia Lawall <julia@diku.dk>
---
First submission contains -no_show-diff whereas it  
should be -no_show_diff

scripts/coccicheck |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/scripts/coccicheck b/scripts/coccicheck
index efaf108..2803e75 100755
--- a/scripts/coccicheck
+++ b/scripts/coccicheck
@@ -31,6 +31,8 @@ if [ "$MODE" = "" ] ; then
 	echo 'You can specify the mode with "make coccicheck MODE=<mode>"'
     fi
     MODE="chain"
+elif [ "$MODE" = "report" -o "$MODE" = "org" ] ; then
+    FLAGS="$FLAGS -no_show_diff"    
 fi
 
 if [ "$ONLINE" = "0" ] ; then
@@ -72,10 +74,10 @@ coccinelle () {
     fi
 
     if [ "$MODE" = "chain" ] ; then
-	$SPATCH -D patch   $FLAGS -sp_file $COCCI $OPT $OPTIONS || \
-	$SPATCH -D report  $FLAGS -sp_file $COCCI $OPT $OPTIONS || \
-	$SPATCH -D context $FLAGS -sp_file $COCCI $OPT $OPTIONS || \
-	$SPATCH -D org     $FLAGS -sp_file $COCCI $OPT $OPTIONS || exit 1
+	$SPATCH -D patch   $FLAGS -sp_file $COCCI $OPT $OPTIONS               || \
+	$SPATCH -D report  $FLAGS -sp_file $COCCI $OPT $OPTIONS -no_show_diff || \
+	$SPATCH -D context $FLAGS -sp_file $COCCI $OPT $OPTIONS               || \
+	$SPATCH -D org     $FLAGS -sp_file $COCCI $OPT $OPTIONS -no_show_diff || exit 1
     else
 	$SPATCH -D $MODE   $FLAGS -sp_file $COCCI $OPT $OPTIONS || exit 1
     fi
-- 
1.7.0.4

