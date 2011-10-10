Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab1JJF5I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 01:57:08 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44095 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab1JJF5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 01:57:06 -0400
From: Olof Johansson <olof@lixom.net>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, apw@canonical.com,
        Olof Johansson <olof@lixom.net>
Subject: [PATCH] checkpatch: warn on found Change-Id lines
Date: Sun,  9 Oct 2011 22:56:56 -0700
Message-Id: <1318226216-5317-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.4.1
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
index 3dfc471..bac1c93 100755
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
@@ -45,6 +46,7 @@ Options:
   -q, --quiet                quiet
   --no-tree                  run without a kernel tree
   --no-signoff               do not check for 'Signed-off-by' line
+  --no-change-id             don't complain about 'Change-Id' lines
   --patch                    treat FILE as patchfile (default)
   --emacs                    emacs compile window format
   --terse                    one line per report
@@ -99,6 +101,7 @@ GetOptions(
 	'q|quiet+'	=> \$quiet,
 	'tree!'		=> \$tree,
 	'signoff!'	=> \$chk_signoff,
+	'change-id!'	=> \$chk_changeid,
 	'patch!'	=> \$chk_patch,
 	'emacs!'	=> \$emacs,
 	'terse!'	=> \$terse,
@@ -341,6 +344,7 @@ sub deparenthesize {
 }
 
 $chk_signoff = 0 if ($file);
+$chk_changeid = 0 if ($file);
 
 my @dep_includes = ();
 my @dep_functions = ();
@@ -1578,6 +1582,10 @@ sub process {
 				}
 			}
 		}
+# Check for Change-Id lines:
+		if ($line =~ /^\s*change-id:/i && $chk_changeid) {
+			ERROR("CHANGE_ID", "Found Change-Id line\n", $herecurr);
+		}
 
 # Check for wrappage within a valid hunk of the file
 		if ($realcnt != 0 && $line !~ m{^(?:\+|-| |\\ No newline|$)}) {
-- 
1.7.4.1

