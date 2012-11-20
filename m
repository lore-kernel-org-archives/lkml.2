Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165Ab2KTU5d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 15:57:33 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:43119 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752464Ab2KTU5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 15:57:32 -0500
Message-ID: <1353445050.17819.16.camel@joe-AO722>
Subject: [PATCH] checkpatch: Allow control over line length warning, default
 remains 80
From: Joe Perches <joe@perches.com>
To: Andy Whitcroft <apw@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Constantine Shulyupin <const@makelinux.com>, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Date: Tue, 20 Nov 2012 12:57:30 -0800
In-Reply-To: <20121120152227.GI7955@dm>
References: <1353190818-10070-1-git-send-email-const@MakeLinux.com>
	 <20121120142906.GD7955@dm> <1353422629.11235.10.camel@joe-AO722>
	 <20121120144742.GG7955@dm>
	 <CAE7jHC8LsxPaQHqy5-H4-wZp6q+_0s7arnPa3jG7R9x=tf_Oww@mail.gmail.com>
	 <1353423503.11235.12.camel@joe-AO722>
	 <CAE7jHC-QqYCvSVR2JwCQjrSx6yH0-41GXfid6FSPP3xB8FV=2w@mail.gmail.com>
	 <20121120152227.GI7955@dm>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some projects might want a longer line length so allow
a command line --max-line-length=n control over the
long line warnings.  The default line length is 80.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index d2d5ba1..38e8890 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -33,6 +33,7 @@ my %ignore_type = ();
 my @ignore = ();
 my $help = 0;
 my $configuration_file = ".checkpatch.conf";
+my $max_line_length = 80;
 
 sub help {
 	my ($exitcode) = @_;
@@ -51,6 +52,7 @@ Options:
   -f, --file                 treat FILE as regular source file
   --subjective, --strict     enable more subjective tests
   --ignore TYPE(,TYPE2...)   ignore various comma separated message types
+  --max-line-length=n        set the maximum line length, if exceeded, warn
   --show-types               show the message "types" in the output
   --root=PATH                PATH to the kernel tree root
   --no-summary               suppress the per-file summary
@@ -107,6 +109,7 @@ GetOptions(
 	'strict!'	=> \$check,
 	'ignore=s'	=> \@ignore,
 	'show-types!'	=> \$show_types,
+	'max-line-length=i' => \$max_line_length,
 	'root=s'	=> \$root,
 	'summary!'	=> \$summary,
 	'mailback!'	=> \$mailback,
@@ -1760,15 +1763,15 @@ sub process {
 # check we are in a valid source file if not then ignore this hunk
 		next if ($realfile !~ /\.(h|c|s|S|pl|sh)$/);
 
-#80 column limit
+#line length limit
 		if ($line =~ /^\+/ && $prevrawline !~ /\/\*\*/ &&
 		    $rawline !~ /^.\s*\*\s*\@$Ident\s/ &&
 		    !($line =~ /^\+\s*$logFunctions\s*\(\s*(?:(KERN_\S+\s*|[^"]*))?"[X\t]*"\s*(?:|,|\)\s*;)\s*$/ ||
 		    $line =~ /^\+\s*"[^"]*"\s*(?:\s*|,|\)\s*;)\s*$/) &&
-		    $length > 80)
+		    $length > $max_line_length)
 		{
 			WARN("LONG_LINE",
-			     "line over 80 characters\n" . $herecurr);
+			     "line over $max_line_length characters\n" . $herecurr);
 		}
 
 # Check for user-visible strings broken across lines, which breaks the ability


