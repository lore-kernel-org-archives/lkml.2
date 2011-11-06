Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506Ab1KFI7y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 03:59:54 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:35021 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750855Ab1KFI7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 03:59:53 -0500
Message-ID: <1320570027.5755.7.camel@Joe-Laptop>
Subject: [PATCH] checkpatch: Update signature "might be better as" warning
From: Joe Perches <joe@perches.com>
To: Julia Lawall <julia.lawall@lip6.fr>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andy Whitcroft <apw@shadowen.org>
Date: Sun, 06 Nov 2011 11:00:27 +0200
In-Reply-To: <alpine.DEB.2.02.1111052254540.1963@hadrien>
References: <alpine.DEB.2.02.1111052254540.1963@hadrien>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

email header lines can look like signatures tags.
It's valid to have multiple email recipients on a single line
but not valid to have multiple signatures on a single line.

Validate signatures only when not in the email headers.

Clear the $in_commit_log flag when the patch filename appears.

Add '-' to the valid chars in a message header for headers
like "Message-Id:" and "In-Reply-To:".

Reported-by: Julia Lawall <julia.lawall@lip6.fr>
Signed-off-by: Joe Perches <joe@perches.com>

---

On Sat, 2011-11-05 at 22:57 +0100, Julia Lawall wrote:
> Checkpatch is giving me, eg: 
> 'Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,"David S. Miller" 
> <davem@davemloft.net>,b.a.t.m.a.n@lists.open-mesh.org,netdev@vger.kernel.org,linux-kernel@vger.kernel.org' 
> might be better as '"Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,\"David S. 
> Miller" <davem@davemloft.net>,b.a.t.m.a.n@lists.open-mesh.org,netdev@vger.kernel.org,linux-kernel@vger.kernel.org'
> The problem seems to go away if I get rid of the quotes around "David S. 
> Miller".  Is it intentional to give a warning in this case?

 scripts/checkpatch.pl |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 5e93342..9bc0e06 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1504,9 +1504,11 @@ sub process {
 		if ($line =~ /^diff --git.*?(\S+)$/) {
 			$realfile = $1;
 			$realfile =~ s@^([^/]*)/@@;
+			$in_commit_log = 0;
 		} elsif ($line =~ /^\+\+\+\s+(\S+)/) {
 			$realfile = $1;
 			$realfile =~ s@^([^/]*)/@@;
+			$in_commit_log = 0;
 
 			$p1_prefix = $1;
 			if (!$file && $tree && $p1_prefix ne '' &&
@@ -1546,7 +1548,8 @@ sub process {
 		}
 
 # Check signature styles
-		if ($line =~ /^(\s*)($signature_tags)(\s*)(.*)/) {
+		if (!$in_header_lines &&
+		    $line =~ /^(\s*)($signature_tags)(\s*)(.*)/) {
 			my $space_before = $1;
 			my $sign_off = $2;
 			my $space_after = $3;
@@ -1623,7 +1626,7 @@ sub process {
 # Check if it's the start of a commit log
 # (not a header line and we haven't seen the patch filename)
 		if ($in_header_lines && $realfile =~ /^$/ &&
-		    $rawline !~ /^(commit\b|from\b|\w+:).+$/i) {
+		    $rawline !~ /^(commit\b|from\b|[\w-]+:).+$/i) {
 			$in_header_lines = 0;
 			$in_commit_log = 1;
 		}
-- 
1.7.6.405.gc1be0

