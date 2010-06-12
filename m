Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054Ab0FLRQe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 13:16:34 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50986 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab0FLRQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 13:16:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=dAX9sS8CgPoZtF4elv5CSJN768dC9utm56WY6M8q/fYip4UJUJPLw3xihDtARfZ4UW
         yY9I+gZDtQUw0bgCsMwmuIKtdfbo+I5DXV2nNfAChH5hH05Xjs1E+eFv10nueIm2pN1i
         ahdKNQbYbAQ/+A/hTcxbFcLYKD6xKH2vzzM8M=
Date: Sat, 12 Jun 2010 19:09:44 +0200
From: Fredrik Gustafsson <iveqy@iveqy.com>
To: apw@canonical.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] checkpatch.pl skip long lines
Message-ID: <20100612170944.GA9121@iveqy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
since the number of long lines in the linux kernel is huge and since
Greg Kroah Hartman in his google tech talk about the kernel
(http://www.youtube.com/watch?v=L2SED6sewRw) talked about probably
ignore that criteria in the future, I thought the checkpatch.pl script
should have an option to ignore checking for long lines.

This would help finding the real errors and warnings, because they don't
drown in line length warnings.

--
Regards
iveqy


>From ce6f2138969a56f5cbde2948f239c5204f0cafe1 Mon Sep 17 00:00:00 2001
From: iveqy <iveqy@iveqy.com>
Date: Sat, 12 Jun 2010 18:57:51 +0200
Subject: [PATCH] Add skiplinelength parameter

---
 scripts/checkpatch.pl |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index bd88f11..e0683f4 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -29,6 +29,7 @@ my $summary_file = 0;
 my $root;
 my %debug;
 my $help = 0;
+my $skip_line_length = 0;
 
 sub help {
 	my ($exitcode) = @_;
@@ -49,6 +50,7 @@ Options:
   --root=PATH                PATH to the kernel tree root
   --no-summary               suppress the per-file summary
   --mailback                 only produce a report in case of warnings/errors
+  --skiplinelength           skip check for long lines
   --summary-file             include the filename in summary
   --debug KEY=[0|1]          turn on/off debugging of KEY, where KEY is one of
                              'values', 'possible', 'type', and 'attr' (default
@@ -81,6 +83,7 @@ GetOptions(
 	'debug=s'	=> \%debug,
 	'test-only=s'	=> \$tst_only,
 	'h|help'	=> \$help,
+	'skiplinelength!'	=> \$skip_line_length,
 	'version'	=> \$help
 ) or help(1);
 
@@ -1401,12 +1404,13 @@ sub process {
 		next if ($realfile !~ /\.(h|c|s|S|pl|sh)$/);
 
 #80 column limit
-		if ($line =~ /^\+/ && $prevrawline !~ /\/\*\*/ &&
-		    $rawline !~ /^.\s*\*\s*\@$Ident\s/ &&
-		    $line !~ /^\+\s*$logFunctions\s*\(\s*(?:KERN_\S+\s*)?"[X\t]*"\s*(?:,|\)\s*;)\s*$/ &&
-		    $length > 80)
-		{
-			WARN("line over 80 characters\n" . $herecurr);
+		if(!$skip_line_length) {
+			if ($line =~ /^\+/ && $prevrawline !~ /\/\*\*/ &&
+				$rawline !~ /^.\s*\*\s*\@$Ident\s/ &&
+				$line !~ /^\+\s*$logFunctions\s*\(\s*(?:KERN_\S+\s*)?"[X\t]*"\s*(?:,|\)\s*;)\s*$/ &&
+				$length > 80) {
+				WARN("line over 80 characters\n" . $herecurr);
+			}
 		}
 
 # check for spaces before a quoted newline
-- 
1.6.4.4

