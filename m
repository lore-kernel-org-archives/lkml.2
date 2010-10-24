Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933053Ab0JXViZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 17:38:25 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57789 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932971Ab0JXViT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 17:38:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=Uzyf1ebAs4vGexnGgE1qMjR2prUOP/wW2mDVHvPh1Pci3BoS4A6afHRH+ihcvKCuAB
         kWmHRdPZaQiv39Vg94F2zzQMwb/Khk9amrrZT8UvBfh8aVPjNYGPZ8BBBMoWUwSnAUko
         zWa5W+98nyKp4V0d0AkBq51p6O1iqtrqTXVZQ=
From: Nicolas Palix <npalix.work@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>, Nicolas Palix <npalix.work@gmail.com>,
        Julia Lawall <julia@diku.dk>, Michal Marek <mmarek@suse.cz>,
        Kulikov Vasiliy <segooon@gmail.com>,
        Gilles Muller <Gilles.Muller@lip6.fr>, Sam Ravnborg <sam@ravnborg.org>,
        Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, cocci@diku.dk
Subject: [PATCH 4/4] Coccinelle: Add contextual message
Date: Sun, 24 Oct 2010 23:37:34 +0200
Message-Id: <1287956254-15563-4-git-send-email-npalix.work@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the message displayed to the user according
to the current mode used.

Fix trailing white-space and spelling

Signed-off-by: Nicolas Palix <npalix.work@gmail.com>
---
 scripts/coccicheck |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/scripts/coccicheck b/scripts/coccicheck
index 7529af1..1bb1a1b 100755
--- a/scripts/coccicheck
+++ b/scripts/coccicheck
@@ -32,7 +32,7 @@ if [ "$MODE" = "" ] ; then
     fi
     MODE="chain"
 elif [ "$MODE" = "report" -o "$MODE" = "org" ] ; then
-    FLAGS="$FLAGS -no_show_diff"    
+    FLAGS="$FLAGS -no_show_diff"
 fi
 
 if [ "$ONLINE" = "0" ] ; then
@@ -47,7 +47,7 @@ coccinelle () {
 
     OPT=`grep "Option" $COCCI | cut -d':' -f2`
 
-#   The option '-parse_cocci' can be used to syntaxically check the SmPL files.
+#   The option '-parse_cocci' can be used to syntactically check the SmPL files.
 #
 #    $SPATCH -D $MODE $FLAGS -parse_cocci $COCCI $OPT > /dev/null
 
@@ -62,7 +62,17 @@ coccinelle () {
 
 	sed -ne 's|^///||p' $COCCI
 
-	echo ' The semantic patch that makes this change is available'
+	if [ "$MODE" = "patch" ] ; then
+	    echo ' The semantic patch that makes this change is available'
+	elif [ "$MODE" = "report" ] ; then
+	    echo ' The semantic patch that makes this report is available'
+	elif [ "$MODE" = "context" ] ; then
+	    echo ' The semantic patch that spots this code is available'
+	elif [ "$MODE" = "org" ] ; then
+	    echo ' The semantic patch that makes this Org report is available'
+	else
+	    echo ' The semantic patch that makes this output is available'
+	fi
 	echo " in $FILE."
 	echo ''
 	echo ' More information about semantic patching is available at'
-- 
1.7.0.4

