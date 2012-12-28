Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932449Ab2L1T2F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:28:05 -0500
Received: from georges.telenet-ops.be ([195.130.137.68]:50236 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754833Ab2L1T14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:27:56 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] get_maintainer.pl: Find maintainers for removed files
Date: Fri, 28 Dec 2012 20:27:50 +0100
Message-Id: <1356722870-18325-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For removed files, get_maintainer.pl doesn't find any maintainers (besides
the default linux-kernel@vger.kernel.org), as it only looks at the "+++"
lines, which are "/dev/null" for removals.
Fix this by extending the parsing to the "---" lines.

E.g. for the two line test patch below the real score maintainers will now
be found:

    --- a/arch/score/include/asm/dma-mapping.h
    +++ /dev/null

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 scripts/get_maintainer.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index 8b673dd..18d4ab5 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -433,7 +433,7 @@ foreach my $file (@ARGV) {
 
 	while (<$patch>) {
 	    my $patch_line = $_;
-	    if (m/^\+\+\+\s+(\S+)/) {
+	    if (m/^\+\+\+\s+(\S+)/ or m/^---\s+(\S+)/) {
 		my $filename = $1;
 		$filename =~ s@^[^/]*/@@;
 		$filename =~ s@\n@@;
-- 
1.7.0.4

