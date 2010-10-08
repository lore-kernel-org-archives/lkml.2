Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289Ab0JHT2S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 15:28:18 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48248 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759555Ab0JHT2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 15:28:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer:in-reply-to:references;
        b=SMDbu5XqEfHMagbmQmdf2GVleeKjViq6y2EOcjHMHb/SoSG6BTL2u4jF7Qiit0f4/3
         A7DvZK7OqhAjVv4cZE+v1qCNn6pod0WyVRNNojH4IA9pbAoRIz7m9TNiNJ8Qe9+Q7wcR
         naGKMgqSofuzp4IDSZqy+QsmuW62fzWzumHp0=
From: Nicolas Palix <npalix.work@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>, Nicolas Palix <npalix.work@gmail.com>,
        Julia Lawall <julia@diku.dk>, Michal Marek <mmarek@suse.cz>,
        Kulikov Vasiliy <segooon@gmail.com>,
        Gilles Muller <Gilles.Muller@lip6.fr>, Sam Ravnborg <sam@ravnborg.org>,
        Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, cocci@diku.dk
Subject: [PATCH 3/6] Coccinelle: Improve user information with a new kind of comment
Date: Fri,  8 Oct 2010 21:27:38 +0200
Message-Id: <1286566061-17122-4-git-send-email-npalix.work@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1286566061-17122-1-git-send-email-npalix.work@gmail.com>
References: <1286566061-17122-1-git-send-email-npalix.work@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Improve user information with a new kind of comment
about semantic patch output.

Fix spelling.

Signed-off-by: Nicolas Palix <npalix.work@gmail.com>
Signed-off-by: Julia Lawall <julia@diku.dk>
---
 scripts/coccicheck |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/scripts/coccicheck b/scripts/coccicheck
index b8bcf1f..ef78c87 100755
--- a/scripts/coccicheck
+++ b/scripts/coccicheck
@@ -25,7 +25,7 @@ fi
 
 if [ "$MODE" = "" ] ; then
     if [ "$ONLINE" = "0" ] ; then
-	echo 'You have not explicitly specify the mode to use. Fallback to "report".'
+	echo 'You have not explicitly specified the mode to use. Fallback to "report".'
 	echo 'You can specify the mode with "make coccicheck MODE=<mode>"'
 	echo 'Available modes are: report, patch, context, org'
     fi
@@ -52,10 +52,12 @@ coccinelle () {
 
 	FILE=`echo $COCCI | sed "s|$srctree/||"`
 
-	echo "Processing `basename $COCCI` with option(s) \"$OPT\""
+	echo "Processing `basename $COCCI`"
+	echo "with option(s) \"$OPT\""
+	echo ''
 	echo 'Message example to submit a patch:'
 
-	sed -e '/\/\/\//!d' -e 's|^///||' $COCCI
+	sed -ne 's|^///||p' $COCCI
 
 	echo ' The semantic patch that makes this change is available'
 	echo " in $FILE."
@@ -64,6 +66,12 @@ coccinelle () {
 	echo ' http://coccinelle.lip6.fr/'
 	echo ''
 
+	if [ "`sed -ne 's|^//#||p' $COCCI`" ] ; then
+	    echo 'Semantic patch information:'
+	    sed -ne 's|^//#||p' $COCCI
+	    echo ''
+	fi
+
 	$SPATCH -D $MODE $FLAGS -sp_file $COCCI $OPT -dir $srctree || exit 1
     else
 	$SPATCH -D $MODE $FLAGS -sp_file $COCCI $OPT $OPTIONS || exit 1
-- 
1.7.0.4

