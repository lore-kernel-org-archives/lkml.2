Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046Ab2GSVt4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 17:49:56 -0400
Received: from mail.eladian.com ([64.140.252.105]:14024 "EHLO mail.eladian.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466Ab2GSVty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 17:49:54 -0400
X-Amavis-Modified: Mail body modified (using disclaimer) - mail.eladian.com
Date: Thu, 19 Jul 2012 17:49:53 -0400 (EDT)
From: Daniel Wisehart <daniel.wisehart@eladian.com>
To: linux-kernel@vger.kernel.org
Cc: alan@redhat.com
Subject: [PATCH] scripts/patch-kernel fix
Message-ID: <9b2de540-7ff6-4853-8331-5b9f0d28051c@mail.eladian.com>
In-Reply-To: <cf445a75-137c-4689-aa34-6c89cbd92b7b@mail.eladian.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Mailer: Zimbra 7.1.3_GA_3374 (ZimbraWebClient - GC19 (Linux)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takes care of errors when running something like:

$ ./scripts/patch-kernel . .. 3.5
Current kernel version is 3.5.0-rc7 ( Saber-toothed Squirrel)
./scripts/patch-kernel: line 229: [: -lt: unary operator expected
./scripts/patch-kernel: line 252: [: -gt: unary operator expected


diff --git a/scripts/patch-kernel b/scripts/patch-kernel
index d000ea3..a7672eb 100755
--- a/scripts/patch-kernel
+++ b/scripts/patch-kernel
@@ -226,7 +226,7 @@ fi
 
 # This all assumes a 2.6.x[.y] kernel tree.
 # Don't allow backwards/reverse patching.
-if [ $STOPSUBLEVEL -lt $SUBLEVEL ]; then
+if [ "$STOPSUBLEVEL"0 -lt "$SUBLEVEL"0 ]; then
        backwards
 fi
 
@@ -249,7 +249,7 @@ fi
 # If not ending sublevel is specified, it is incremented until
 # no further sublevels are found.
 
-if [ $STOPSUBLEVEL -gt $SUBLEVEL ]; then
+if [ "$STOPSUBLEVEL"0 -gt "$SUBLEVEL"0 ]; then
 while :                                # incrementing SUBLEVEL (s in v.p.s)
 do
     CURRENTFULLVERSION="$VERSION.$PATCHLEVEL.$SUBLEVEL"



This communication is restricted - please see http://www.eladian.com for further information.
