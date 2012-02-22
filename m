Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797Ab2BVOkV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 09:40:21 -0500
Received: from mga02.intel.com ([134.134.136.20]:49909 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796Ab2BVOkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 09:40:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="113376759"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Andy Whitcroft <apw@canonical.com>, Andrew Morton <akpm@google.com>
Cc: Joe Perches <joe@perches.com>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCH] checkpatch.pl: be silent when -q and --ignore is given
Date: Wed, 22 Feb 2012 16:40:24 +0200
Message-Id: <1329921624-8559-1-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

This patch fixes checkpatch.pl when both -q and --ignore are given and
prevents it from printing a

NOTE: Ignored message types: blah

messages.

E.g., if I use -q --ignore PREFER_PACKED,PREFER_ALIGNED, i see:

NOTE: Ignored message types: PREFER_ALIGNED PREFER_PACKED

It makes no sense to print this when -q is given.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 scripts/checkpatch.pl |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index a3b9782..6fad217 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3394,13 +3394,12 @@ sub process {
 		}
 	}
 
-	if (keys %ignore_type) {
+	if ($quiet == 0 && keys %ignore_type) {
 	    print "NOTE: Ignored message types:";
 	    foreach my $ignore (sort keys %ignore_type) {
 		print " $ignore";
 	    }
-	    print "\n";
-	    print "\n" if ($quiet == 0);
+	    print "\n\n";
 	}
 
 	if ($clean == 1 && $quiet == 0) {
-- 
1.7.9

