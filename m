Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986Ab1HRGsp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 02:48:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:32523 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752587Ab1HRGsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 02:48:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,243,1312182000"; 
   d="scan'208";a="40973696"
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Bruce Allan <bruce.w.allan@intel.com>, Joe Perches <joe@perches.com>,
        Anish Kumar <anish198519851985@gmail.com>,
        Andy Whitcroft <apw@canonical.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH] checkpatch: do not test/warn of leading whitespace before signature tags
Date: Wed, 17 Aug 2011 23:48:32 -0700
Message-Id: <1313650112-17287-1-git-send-email-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bruce Allan <bruce.w.allan@intel.com>

Commit 2011247 introduced additional style checks for signature tags in
patches which is good.  Unfortunately, now whenever patches are checked
by piping the output of 'git show' or 'stg show' through checkpatch it
warns not to use whitespace before all signature tags since these (and the
rest of the patch description) are indented.  Remove this test/warning.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Cc: Joe Perches <joe@perches.com>
Cc: Anish Kumar <anish198519851985@gmail.com>
Cc: Andy Whitcroft <apw@canonical.com>
Tested-by:  Aaron Brown  <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 scripts/checkpatch.pl |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 9d761c9..a2a205a 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1539,17 +1539,12 @@ sub process {
 		}
 
 # Check signature styles
-		if ($line =~ /^(\s*)($signature_tags)(\s*)(.*)/) {
-			my $space_before = $1;
-			my $sign_off = $2;
-			my $space_after = $3;
-			my $email = $4;
+		if ($line =~ /^\s*($signature_tags)(\s*)(.*)/) {
+			my $sign_off = $1;
+			my $space_after = $2;
+			my $email = $3;
 			my $ucfirst_sign_off = ucfirst(lc($sign_off));
 
-			if (defined $space_before && $space_before ne "") {
-				WARN("BAD_SIGN_OFF",
-				     "Do not use whitespace before $ucfirst_sign_off\n" . $herecurr);
-			}
 			if ($sign_off =~ /-by:$/i && $sign_off ne $ucfirst_sign_off) {
 				WARN("BAD_SIGN_OFF",
 				     "'$ucfirst_sign_off' is the preferred signature form\n" . $herecurr);
-- 
1.7.6

