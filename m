Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161005Ab2KIBiZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 20:38:25 -0500
Received: from oproxy12-pub.bluehost.com ([50.87.16.10]:55508 "HELO
	oproxy12-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753898Ab2KIBiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 20:38:24 -0500
From: Tao Ma <tm@tao.ma>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>
Subject: [PATCH V2 3/5] checkpatch: Remove reference to feature-removal-schedule.txt.
Date: Fri,  9 Nov 2012 09:38:12 +0800
Message-Id: <1352425092-2568-1-git-send-email-tm@tao.ma>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <20121108174702.GL3066@dm>
References: <20121108174702.GL3066@dm>
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 42.120.72.201 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

In 9c0ece069, Linus removes feature-removal-schedule.txt from Documentation,
but there is still some reference to this file. So remove them.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 scripts/checkpatch.pl |   37 -------------------------------------
 1 files changed, 0 insertions(+), 37 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 21a9f5d..b56c5e0 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -352,27 +352,6 @@ sub deparenthesize {
 
 $chk_signoff = 0 if ($file);
 
-my @dep_includes = ();
-my @dep_functions = ();
-my $removal = "Documentation/feature-removal-schedule.txt";
-if ($tree && -f "$root/$removal") {
-	open(my $REMOVE, '<', "$root/$removal") ||
-				die "$P: $removal: open failed - $!\n";
-	while (<$REMOVE>) {
-		if (/^Check:\s+(.*\S)/) {
-			for my $entry (split(/[, ]+/, $1)) {
-				if ($entry =~ m@include/(.*)@) {
-					push(@dep_includes, $1);
-
-				} elsif ($entry !~ m@/@) {
-					push(@dep_functions, $entry);
-				}
-			}
-		}
-	}
-	close($REMOVE);
-}
-
 my @rawlines = ();
 my @lines = ();
 my $vname;
@@ -3181,22 +3160,6 @@ sub process {
 			}
 		}
 
-# don't include deprecated include files (uses RAW line)
-		for my $inc (@dep_includes) {
-			if ($rawline =~ m@^.\s*\#\s*include\s*\<$inc>@) {
-				ERROR("DEPRECATED_INCLUDE",
-				      "Don't use <$inc>: see Documentation/feature-removal-schedule.txt\n" . $herecurr);
-			}
-		}
-
-# don't use deprecated functions
-		for my $func (@dep_functions) {
-			if ($line =~ /\b$func\b/) {
-				ERROR("DEPRECATED_FUNCTION",
-				      "Don't use $func(): see Documentation/feature-removal-schedule.txt\n" . $herecurr);
-			}
-		}
-
 # no volatiles please
 		my $asm_volatile = qr{\b(__asm__|asm)\s+(__volatile__|volatile)\b};
 		if ($line =~ /\bvolatile\b/ && $line !~ /$asm_volatile/) {
-- 
1.7.0.4

