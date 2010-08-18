Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695Ab0HRPrS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 11:47:18 -0400
Received: from adelie.canonical.com ([91.189.90.139]:51900 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab0HRPrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 11:47:12 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 08/16] checkpatch: simplify and consolidate "missing space after" checks
Date: Wed, 18 Aug 2010 16:46:41 +0100
Message-Id: <1282146409-30544-9-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282146409-30544-1-git-send-email-apw@canonical.com>
References: <1282146409-30544-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commonise the code for missing spaces after struct, union, and enum such
that they share the same code.  Ensure we cover all the common cases in
each case.  Check against the sanitised line to ensure we do not report
on comments and strings.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 983ac18..cb19f54 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1905,22 +1905,17 @@ sub process {
 			ERROR("open brace '{' following function declarations go on the next line\n" . $herecurr);
 		}
 
-# missing space after union or struct definition
-		if ($rawline =~ /^\+\s*(union|struct)\s+$Ident[=\{]/) {
-		    WARN("Missing space after struct or union definition\n" . $herecurr);
-		}
-
-# missing space after enum definition
-		if ($rawline =~ /^\+\s*enum\{/) {
-		    WARN("Missing space after enum definition\n" . $herecurr);
-		}
-
 # open braces for enum, union and struct go on the same line.
 		if ($line =~ /^.\s*{/ &&
 		    $prevline =~ /^.\s*(?:typedef\s+)?(enum|union|struct)(?:\s+$Ident)?\s*$/) {
 			ERROR("open brace '{' following $1 go on the same line\n" . $hereprev);
 		}
 
+# missing space after union, struct or enum definition
+		if ($line =~ /^.\s*(?:typedef\s+)?(enum|union|struct)(?:\s+$Ident)?(?:\s+$Ident)?[=\{]/) {
+		    WARN("missing space after $1 definition\n" . $herecurr);
+		}
+
 # check for spacing round square brackets; allowed:
 #  1. with a type on the left -- int [] a;
 #  2. at the beginning of a line for slice initialisers -- [0...10] = 5,
-- 
1.7.0.4

