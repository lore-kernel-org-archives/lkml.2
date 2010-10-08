Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932970Ab0JHT22 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 15:28:28 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48248 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932862Ab0JHT2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 15:28:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer:in-reply-to:references;
        b=iByU3haB6Pq/gssV5cpVSx9QUiEYjapaTxmjjepscewHmNW1rENaSmz2qFaujIcWb+
         7Ml8ue7uoNII5sD+mkPb+PDa66k+QOKRF/T2SpJGNwg5il5AgEZMmWLCx+0L/WCrG6s1
         5gM7PP2rtBDu26T5qBxG43Zkjxp94PGPLlMVQ=
From: Nicolas Palix <npalix.work@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>, Nicolas Palix <npalix.work@gmail.com>,
        Julia Lawall <julia@diku.dk>, Michal Marek <mmarek@suse.cz>,
        Kulikov Vasiliy <segooon@gmail.com>,
        Gilles Muller <Gilles.Muller@lip6.fr>, Sam Ravnborg <sam@ravnborg.org>,
        Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, cocci@diku.dk
Subject: [PATCH 6/6] Coccinelle: Use the -no_show_diff option for org and report mode
Date: Fri,  8 Oct 2010 21:27:41 +0200
Message-Id: <1286566061-17122-7-git-send-email-npalix.work@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1286566061-17122-1-git-send-email-npalix.work@gmail.com>
References: <1286566061-17122-1-git-send-email-npalix.work@gmail.com>
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
index c7beb63..7529af1 100755
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
@@ -75,10 +77,10 @@ coccinelle () {
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

