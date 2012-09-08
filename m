Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab2IHTsH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 15:48:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:13728 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397Ab2IHTsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 15:48:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,392,1344236400"; 
   d="scan'208";a="199715023"
From: Andi Kleen <andi@firstfloor.org>
To: mmarek@suse.cz
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] Kbuild: use normal compression settings for tar*-pkg
Date: Sat,  8 Sep 2012 12:47:59 -0700
Message-Id: <1347133679-14641-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

For large kernel configurations (like a distribution kernel)
targz-pkg takes a quite long time to just do the compression.
I clocked it at 15+mins for a SUSE kernel like config on a fast
system.  And tarxz and bzip2 are even slower.

The main reason is that the script that is doing the taring sets
the highest compression level (-9).  When I change it to just
use the defaults the gzip time for the same kernel goes down
to ~3 mins. I haven't tested xz and bzip, but I expect those
to be much faster too.

I'm not willing to wait that long for a small compression
gain. So just change the script to use the defaults.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 scripts/package/buildtar |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/scripts/package/buildtar b/scripts/package/buildtar
index 8a7b155..632377f 100644
--- a/scripts/package/buildtar
+++ b/scripts/package/buildtar
@@ -28,15 +28,15 @@ case "${1}" in
 		file_ext=""
 		;;
 	targz-pkg)
-		compress="gzip -c9"
+		compress="gzip"
 		file_ext=".gz"
 		;;
 	tarbz2-pkg)
-		compress="bzip2 -c9"
+		compress="bzip2"
 		file_ext=".bz2"
 		;;
 	tarxz-pkg)
-		compress="xz -c9"
+		compress="xz"
 		file_ext=".xz"
 		;;
 	*)
-- 
1.7.7.6

