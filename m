Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab2B0Ro7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 12:44:59 -0500
Received: from mga14.intel.com ([143.182.124.37]:51459 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753523Ab2B0Ro6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 12:44:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="111536608"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCH resend] checkpatch.pl: be silent when -q and --ignore is given
Date: Mon, 27 Feb 2012 19:45:58 +0200
Message-Id: <1330364758-12065-1-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <dedekind1@gmail.com>

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

--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

