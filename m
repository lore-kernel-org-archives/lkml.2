Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734Ab0HRPrU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 11:47:20 -0400
Received: from adelie.canonical.com ([91.189.90.139]:51896 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117Ab0HRPrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 11:47:12 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 03/16] checkpatch: suggest cleanpatch and cleanfile when appropriate
Date: Wed, 18 Aug 2010 16:46:36 +0100
Message-Id: <1282146409-30544-4-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282146409-30544-1-git-send-email-apw@canonical.com>
References: <1282146409-30544-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we hit types of whitespace which may be fixed by scripts/cleanpatch
and scripts/cleanfile suggest their use in our report.

Suggested-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 41f59b1..32d6a23 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -103,6 +103,8 @@ for my $key (keys %debug) {
 	die "$@" if ($@);
 }
 
+my $rpt_cleaners = 0;
+
 if ($terse) {
 	$emacs = 1;
 	$quiet++;
@@ -1389,6 +1391,7 @@ sub process {
 		} elsif ($rawline =~ /^\+.*\S\s+$/ || $rawline =~ /^\+\s+$/) {
 			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
 			ERROR("trailing whitespace\n" . $herevet);
+			$rpt_cleaners = 1;
 		}
 
 # check for Kconfig help text having a real description
@@ -1450,6 +1453,7 @@ sub process {
 		    $rawline =~ /^\+\s*        \s*/) {
 			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
 			ERROR("code indent should use tabs where possible\n" . $herevet);
+			$rpt_cleaners = 1;
 		}
 
 # check for space before tabs.
@@ -2842,6 +2846,15 @@ sub process {
 		print "\n" if ($quiet == 0);
 	}
 
+	if ($quiet == 0) {
+		# If there were whitespace errors which cleanpatch can fix
+		# then suggest that.
+		if ($rpt_cleaners) {
+			print "NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or\n";
+			print "      scripts/cleanfile\n\n";
+		}
+	}
+
 	if ($clean == 1 && $quiet == 0) {
 		print "$vname has no obvious style problems and is ready for submission.\n"
 	}
-- 
1.7.0.4

