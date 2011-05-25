Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab1EYUTR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 16:19:17 -0400
Received: from outmail010.snc4.facebook.com ([66.220.144.142]:41482 "EHLO
	mx-out.facebook.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754679Ab1EYUTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 16:19:15 -0400
From: Arun Sharma <asharma@fb.com>
To: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Arun Sharma <asharma@fb.com>
Subject: [PATCH] kbuild: Move firmware images to a separate RPM
Date: Wed, 25 May 2011 13:19:08 -0700
Message-Id: <1306354748-26727-1-git-send-email-asharma@fb.com>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows multiple kernel RPMs to be installed without
namespace conflicts.

Signed-off-by: Arun Sharma <asharma@fb.com>
---
 scripts/package/mkspec |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/scripts/package/mkspec b/scripts/package/mkspec
index b20bdac..35e68d1 100755
--- a/scripts/package/mkspec
+++ b/scripts/package/mkspec
@@ -68,6 +68,13 @@ echo "between the Linux kernel and userspace libraries and programs.  The"
 echo "header files define structures and constants that are needed for"
 echo "building most standard programs and are also needed for rebuilding the"
 echo "glibc package."
+echo ""
+echo "%package firmware"
+echo "Summary: Set of firmware images in the kernel tree"
+echo "Group: Development/System"
+echo "%description firmware"
+echo "Firmware images in the kernel tree provided for backward compability"
+echo ""
 
 if ! $PREBUILT; then
 echo "%prep"
@@ -137,7 +144,6 @@ echo "%files"
 echo '%defattr (-, root, root)'
 echo "%dir /lib/modules"
 echo "/lib/modules/$KERNELRELEASE"
-echo "/lib/firmware"
 echo "/boot/*"
 echo ""
 echo "%files devel"
@@ -148,3 +154,7 @@ echo "%files headers"
 echo '%defattr (-, root, root)'
 echo "/usr/include"
 echo ""
+echo "%files firmware"
+echo '%defattr (-, root, root)'
+echo "/lib/firmware"
+echo ""
-- 
1.7.4

