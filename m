Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060Ab0IBRLp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 13:11:45 -0400
Received: from bounce-2.online.net ([88.191.253.47]:51568 "EHLO
	bounce-2.online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103Ab0IBRLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 13:11:43 -0400
X-Greylist: delayed 499 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Sep 2010 13:11:43 EDT
Message-ID: <4C7FD8DB.6080009@free.fr>
Date: Thu, 02 Sep 2010 19:03:23 +0200
From: Albert ARIBAUD <albert.aribaud@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andy Whitcroft <apw@canonical.com>
Subject: [PATCH] add an option to control maximum line length
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-auth-smtp-user: albert@aribaud.net 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some projects or people use checkpatch.pl but want a maximum
line length different from 80: provide option --max-line-length
which expects an integer (defaults to 80) as the length limit.

Signed-off-by: Albert Aribaud <albert.aribaud@free.fr>
---
  scripts/checkpatch.pl |   45 ++++++++++++++++++++++++---------------------
  1 files changed, 24 insertions(+), 21 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 2039acd..4cd54ff 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -16,6 +16,7 @@ use Getopt::Long qw(:config no_auto_abbrev);
   my $quiet = 0;
  my $tree = 1;
+my $maxlinelength = 80;
  my $chk_signoff = 1;
  my $chk_patch = 1;
  my $tst_only;
@@ -41,6 +42,7 @@ Options:
    -q, --quiet                quiet
    --no-tree                  run without a kernel tree
    --no-signoff               do not check for 'Signed-off-by' line
+  --max-line-length=LEN      warn for lines longer than LEN 
characters(default 80)
    --patch                    treat FILE as patchfile (default)
    --emacs                    emacs compile window format
    --terse                    one line per report
@@ -64,24 +66,25 @@ EOM
  }
   GetOptions(
-	'q|quiet+'	=> \$quiet,
-	'tree!'		=> \$tree,
-	'signoff!'	=> \$chk_signoff,
-	'patch!'	=> \$chk_patch,
-	'emacs!'	=> \$emacs,
-	'terse!'	=> \$terse,
-	'f|file!'	=> \$file,
-	'subjective!'	=> \$check,
-	'strict!'	=> \$check,
-	'root=s'	=> \$root,
-	'summary!'	=> \$summary,
-	'mailback!'	=> \$mailback,
-	'summary-file!'	=> \$summary_file,
-
-	'debug=s'	=> \%debug,
-	'test-only=s'	=> \$tst_only,
-	'h|help'	=> \$help,
-	'version'	=> \$help
+	'q|quiet+'		=> \$quiet,
+	'tree!'			=> \$tree,
+	'max-line-length=i'	=> \$maxlinelength,
+	'signoff!'		=> \$chk_signoff,
+	'patch!'		=> \$chk_patch,
+	'emacs!'		=> \$emacs,
+	'terse!'		=> \$terse,
+	'f|file!'		=> \$file,
+	'subjective!'		=> \$check,
+	'strict!'		=> \$check,
+	'root=s'		=> \$root,
+	'summary!'		=> \$summary,
+	'mailback!'		=> \$mailback,
+	'summary-file!'		=> \$summary_file,
+
+	'debug=s'		=> \%debug,
+	'test-only=s'		=> \$tst_only,
+	'h|help'		=> \$help,
+	'version'		=> \$help
  ) or help(1);
   help(0) if ($help);
@@ -1409,14 +1412,14 @@ sub process {
  # check we are in a valid source file if not then ignore this hunk
  		next if ($realfile !~ /\.(h|c|s|S|pl|sh)$/);
  -#80 column limit
+#80 (or maxlinelength) column limit
  		if ($line =~ /^\+/ && $prevrawline !~ /\/\*\*/ &&
  		    $rawline !~ /^.\s*\*\s*\@$Ident\s/ &&
  		    !($line =~ 
/^\+\s*$logFunctions\s*\(\s*(?:(KERN_\S+\s*|[^"]*))?"[X\t]*"\s*(?:,|\)\s*;)\s*$/ 
||
  		    $line =~ /^\+\s*"[^"]*"\s*(?:\s*|,|\)\s*;)\s*$/) &&
-		    $length > 80)
+		    $length > $maxlinelength)
  		{
-			WARN("line over 80 characters\n" . $herecurr);
+			WARN("line over $maxlinelength characters\n" . $herecurr);
  		}
   # check for spaces before a quoted newline
-- 
1.7.1



