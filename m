Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab2BPS4x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 13:56:53 -0500
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:34187
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751896Ab2BPS4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 13:56:51 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bh8275dhz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LZI1YL-01-EEI-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: Joerg Roedel <joerg.roedel@amd.com>, Michal Marek <mmarek@suse.cz>,
        maximilian attems <max@stro.at>, Ben Hutchings <ben@decadent.org.uk>,
        <debian-kernel@lists.debian.org>, <linux-kbuild@vger.kernel.org>
Subject: [PATCH] kbuild: Fix out-of-tree build for 'make deb-pkg'
Date: Thu, 16 Feb 2012 19:56:37 +0100
Message-ID: <1329418597-1654-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The out-of-tree build is broken in 'make deb-pkg'. The
header checks and the header install works on the source and
not on the object tree.
While fixing this also replace the direct 'make' invocations
with the $MAKE variable to be consistent within the script.

Cc: Michal Marek <mmarek@suse.cz>
Cc: maximilian attems <max@stro.at>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: debian-kernel@lists.debian.org
Cc: linux-kbuild@vger.kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 scripts/package/builddeb |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index 0db889f..eee5f8e 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -121,7 +121,7 @@ else
 fi
 
 if grep -q '^CONFIG_MODULES=y' .config ; then
-	INSTALL_MOD_PATH="$tmpdir" make KBUILD_SRC= modules_install
+	INSTALL_MOD_PATH="$tmpdir" $MAKE KBUILD_SRC= modules_install
 	rm -f "$tmpdir/lib/modules/$version/build"
 	rm -f "$tmpdir/lib/modules/$version/source"
 	if [ "$ARCH" = "um" ] ; then
@@ -131,8 +131,8 @@ if grep -q '^CONFIG_MODULES=y' .config ; then
 fi
 
 if [ "$ARCH" != "um" ]; then
-	make headers_check
-	make headers_install INSTALL_HDR_PATH="$libc_headers_dir/usr"
+	$MAKE headers_check KBUILD_SRC=
+	$MAKE headers_install KBUILD_SRC= INSTALL_HDR_PATH="$libc_headers_dir/usr"
 fi
 
 # Install the maintainer scripts
-- 
1.7.5.4


