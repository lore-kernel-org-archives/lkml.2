Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202Ab0JDUqo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 16:46:44 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46355 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756392Ab0JDUqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 16:46:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=iOUWrYkJZn2IEAAI1sPHJJRyMS9ARvv7k6iyMt4mjY0nP4J0ctXANhD6OI98M1Z4BN
         9AxTWJdFjIQlzP6tXRVxs7NPMDns0nsfo5adzR+w4eXDa6E19xLc0IEHx5zrivw9oC76
         4C4ja7RhqYfdu4A52PXhwwo6sZ++8SmOcAci0=
From: Nicolas Palix <npalix.work@gmail.com>
To: Julia Lawall <julia@diku.dk>, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <npalix@diku.dk>, Michal Marek <mmarek@suse.cz>,
        Sam Ravnborg <sam@ravnborg.org>, Joerg Roedel <joerg.roedel@amd.com>,
        cocci@diku.dk, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] Coccinelle: Improve user information with a new kind of comment
Date: Mon,  4 Oct 2010 22:45:38 +0200
Message-Id: <1286225141-22027-1-git-send-email-npalix.work@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Improve user information with a new kind of comment
about semantic patch output.

Fix spelling.

Signed-off-by: Nicolas Palix <npalix.work@gmail.com>
Signed-off-by: Julia Lawall <julia@diku.dk>
---
 scripts/coccicheck |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/scripts/coccicheck b/scripts/coccicheck
index b8bcf1f..4655551 100755
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
@@ -52,7 +52,12 @@ coccinelle () {
 
 	FILE=`echo $COCCI | sed "s|$srctree/||"`
 
-	echo "Processing `basename $COCCI` with option(s) \"$OPT\""
+	echo "Processing `basename $COCCI`"
+	echo "with option(s) \"$OPT\""
+	echo 'Semantic patch information:'
+
+	sed -e '/\/\/#/!d' -e 's|^//#||' $COCCI
+
 	echo 'Message example to submit a patch:'
 
 	sed -e '/\/\/\//!d' -e 's|^///||' $COCCI
-- 
1.7.0.4

