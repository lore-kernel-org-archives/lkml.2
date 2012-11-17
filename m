Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912Ab2KQOgM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 09:36:12 -0500
Received: from oproxy9.bluehost.com ([69.89.24.6]:54105 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751585Ab2KQOgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 09:36:11 -0500
From: Constantine Shulyupin <const@MakeLinux.com>
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        Andy Whitcroft <apw@canonical.com>, joe@perches.com
Cc: Constantine Shulyupin <const@MakeLinux.com>
Subject: [PATCH v2] checkpatch: debugfs_remove() can take NULL
Date: Sat, 17 Nov 2012 16:36:05 +0200
Message-Id: <1353162965-575-1-git-send-email-const@MakeLinux.com>
X-Mailer: git-send-email 1.7.9.5
X-Identified-User: {1470:box668.bluehost.com:makelinu:makelinux.net} {sentby:smtp auth 77.126.70.233 authed with poster@makelinux.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Constantine Shulyupin <const@MakeLinux.com>

debugfs_remove() and  debugfs_remove_recursive() can take a NULL, so let's check and warn about that.

Channegs since v1:

- added debugfs_remove_recursive
- all tests for pattenrs are "if (a) xxx(a)" are consolidates

Signed-off-by: Constantine Shulyupin <const@MakeLinux.com>
---
 scripts/checkpatch.pl |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index f18750e..2339b54 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3213,21 +3213,29 @@ sub process {
 				$herecurr);
 		}
 
-# check for needless kfree() checks
+# check for needless "if"
 		if ($prevline =~ /\bif\s*\(([^\)]*)\)/) {
 			my $expr = $1;
+# check for needless kfree() checks
 			if ($line =~ /\bkfree\(\Q$expr\E\);/) {
 				WARN("NEEDLESS_KFREE",
 				     "kfree(NULL) is safe this check is probably not required\n" . $hereprev);
 			}
-		}
 # check for needless usb_free_urb() checks
-		if ($prevline =~ /\bif\s*\(([^\)]*)\)/) {
-			my $expr = $1;
 			if ($line =~ /\busb_free_urb\(\Q$expr\E\);/) {
 				WARN("NEEDLESS_USB_FREE_URB",
 				     "usb_free_urb(NULL) is safe this check is probably not required\n" . $hereprev);
 			}
+# check for needless debugfs_remove() checks
+			if ($line =~ /\bdebugfs_remove\(\Q$expr\E\);/) {
+				WARN("NEEDLESS_DEBUGFS_REMOVE",
+				     "debugfs_remove(NULL) is safe this check is probably not required\n" . $hereprev);
+			}
+# check for needless debugfs_remove_recursive() checks
+			if ($line =~ /\bdebugfs_remove_recursive\(\Q$expr\E\);/) {
+				WARN("NEEDLESS_DEBUGFS_REMOVE",
+				     "debugfs_remove_recursive(NULL) is safe this check is probably not required\n" . $hereprev);
+			}
 		}
 
 # prefer usleep_range over udelay
-- 
1.7.9.5

