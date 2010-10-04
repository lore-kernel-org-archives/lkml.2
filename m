Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932766Ab0JDUuy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 16:50:54 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44276 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932514Ab0JDUuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 16:50:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=DP1qRR1A9XdVIph/ubbH7XRMInA7ZCc5yVF6aVQpGU3Zsd3cdIUBI5j71QWfVOGKGT
         fcHFhgVJI1eK8lS3IbRlcT/d0BkGidrRHTUUXvF5c68zt7ai9/zwvNdlVeMrpvX56i7c
         k5jp9Z8Ox03vxgOqCrpHyT/ZrrgjKsvTNS0C0=
From: Nicolas Palix <npalix.work@gmail.com>
To: Julia Lawall <julia@diku.dk>, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <npalix@diku.dk>, Michal Marek <mmarek@suse.cz>,
        Sam Ravnborg <sam@ravnborg.org>, Joerg Roedel <joerg.roedel@amd.com>,
        cocci@diku.dk, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] Coccinelle: Use the -no-show-diff option for org and report mode
Date: Mon,  4 Oct 2010 22:50:09 +0200
Message-Id: <1286225409-22200-2-git-send-email-npalix.work@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows to write the semantic patches with code sharing
for the matching parts.

Signed-off-by: Nicolas Palix <npalix.work@gmail.com>
Signed-off-by: Julia Lawall <julia@diku.dk>
---
 scripts/coccicheck |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/scripts/coccicheck b/scripts/coccicheck
index efaf108..6b04b31 100755
--- a/scripts/coccicheck
+++ b/scripts/coccicheck
@@ -31,6 +31,8 @@ if [ "$MODE" = "" ] ; then
 	echo 'You can specify the mode with "make coccicheck MODE=<mode>"'
     fi
     MODE="chain"
+elif [ "$MODE" = "report" -o "$MODE" = "org" ] ; then
+    FLAGS="$FLAGS -no_show-diff"    
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
+	$SPATCH -D report  $FLAGS -sp_file $COCCI $OPT $OPTIONS -no_show-diff || \
+	$SPATCH -D context $FLAGS -sp_file $COCCI $OPT $OPTIONS               || \
+	$SPATCH -D org     $FLAGS -sp_file $COCCI $OPT $OPTIONS -no_show-diff || exit 1
     else
 	$SPATCH -D $MODE   $FLAGS -sp_file $COCCI $OPT $OPTIONS || exit 1
     fi
-- 
1.7.0.4

