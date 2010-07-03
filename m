Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab0GCPUn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 11:20:43 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41513 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715Ab0GCPUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 11:20:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=BEXOiF6U0wFrTV8NMKCgRQfvo5ovRR5v9S7tAR4adIjsrfLSJV8MEBTbrscMBrjP48
         GYLgNMDOg06k266TfwUZjr8G7kFAUOFeN7+OVaVbZiCuAxa1yAkksgJ6dJChHPcQnrW0
         oxnb9dMR5UzHCw9d9vogBfOLDQyxU3rBesFdo=
From: Kulikov Vasiliy <segooon@gmail.com>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Julia Lawall <julia@diku.dk>, Gilles Muller <Gilles.Muller@lip6.fr>,
       Nicolas Palix <npalix@diku.dk>, Michal Marek <mmarek@suse.cz>,
       Sam Ravnborg <sam@ravnborg.org>, Joerg Roedel <joerg.roedel@amd.com>,
       cocci@diku.dk, linux-kernel@vger.kernel.org
Subject: [PATCH] coccicheck: use $KBUILD_EXTMOD when available
Date: Sat,  3 Jul 2010 19:20:34 +0400
Message-Id: <1278170438-8136-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use $KBUILD_EXTMOD instead of $srctree when the latter is not null
to use make M=somedir.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 scripts/coccicheck |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/scripts/coccicheck b/scripts/coccicheck
index b8bcf1f..7d66a55 100755
--- a/scripts/coccicheck
+++ b/scripts/coccicheck
@@ -1,5 +1,11 @@
 #!/bin/sh
 
+if [ -n "$KBUILD_EXTMOD" ]; then
+	CHECK_DIR="$KBUILD_EXTMOD"
+else
+	CHECK_DIR="$srctree"
+fi
+
 SPATCH="`which ${SPATCH:=spatch}`"
 
 if [ "$C" = "1" -o "$C" = "2" ]; then
@@ -64,7 +70,7 @@ coccinelle () {
 	echo ' http://coccinelle.lip6.fr/'
 	echo ''
 
-	$SPATCH -D $MODE $FLAGS -sp_file $COCCI $OPT -dir $srctree || exit 1
+	$SPATCH -D $MODE $FLAGS -sp_file $COCCI $OPT -dir $CHECK_DIR || exit 1
     else
 	$SPATCH -D $MODE $FLAGS -sp_file $COCCI $OPT $OPTIONS || exit 1
     fi
-- 
1.7.0.4

