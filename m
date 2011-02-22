Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573Ab1BVV5c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 16:57:32 -0500
Received: from mail.lixom.net ([70.86.134.90]:58936 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007Ab1BVV5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 16:57:31 -0500
X-Greylist: delayed 410 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Feb 2011 16:57:31 EST
From: Olof Johansson <olof@lixom.net>
To: Andy Whitcroft <apw@canonical.com>
Cc: linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>
Subject: [PATCH] checkpatch: error out on found Change-Id lines
Date: Tue, 22 Feb 2011 15:50:20 -0600
Message-Id: <1298411420-1834-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.3.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some external projects use repo, which uses a special-format Change-Id
field in the commit message for some internal bookkeeping (to re-associate
patches back to review entries, etc). Sometimes they sneak into patches
going upstream, which is embarrassing for the developer, and annoying
for the maintainer.

Add checking for these to checkpatch, to catch them before
posting. Provide a way to disable the check to keep checkpatch useful
for intra-project use.


Signed-off-by: Olof Johansson <olof@lixom.net>

---
 scripts/checkpatch.pl |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 4c0383d..7233e23 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -18,6 +18,7 @@ my $quiet = 0;
 my $tree = 1;
 my $chk_signoff = 1;
 my $chk_patch = 1;
+my $chk_changeid = 1;
 my $tst_only;
 my $emacs = 0;
 my $terse = 0;
@@ -41,6 +42,7 @@ Options:
   -q, --quiet                quiet
   --no-tree                  run without a kernel tree
   --no-signoff               do not check for 'Signed-off-by' line
+  --no-change-id             don't complain about 'Change-Id' lines
   --patch                    treat FILE as patchfile (default)
   --emacs                    emacs compile window format
   --terse                    one line per report
@@ -67,6 +69,7 @@ GetOptions(
 	'q|quiet+'	=> \$quiet,
 	'tree!'		=> \$tree,
 	'signoff!'	=> \$chk_signoff,
+	'change-id!'	=> \$chk_changeid,
 	'patch!'	=> \$chk_patch,
 	'emacs!'	=> \$emacs,
 	'terse!'	=> \$terse,
@@ -269,6 +272,7 @@ sub build_types {
 build_types();
 
 $chk_signoff = 0 if ($file);
+$chk_changeid = 0 if ($file);
 
 my @dep_includes = ();
 my @dep_functions = ();
@@ -1378,6 +1382,10 @@ sub process {
 					$herecurr);
 			}
 		}
+# Check for Change-Id lines:
+		if ($line =~ /^\s*change-id:/i && $chk_changeid) {
+			ERROR("Found Change-Id line\n", $herecurr);
+		}
 
 # Check for wrappage within a valid hunk of the file
 		if ($realcnt != 0 && $line !~ m{^(?:\+|-| |\\ No newline|$)}) {
-- 
1.7.0.4

