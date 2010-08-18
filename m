Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab0HRPsO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 11:48:14 -0400
Received: from adelie.canonical.com ([91.189.90.139]:51892 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab0HRPrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 11:47:11 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 07/16] checkpatch: add check for space after struct, union, and enum
Date: Wed, 18 Aug 2010 16:46:40 +0100
Message-Id: <1282146409-30544-8-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282146409-30544-1-git-send-email-apw@canonical.com>
References: <1282146409-30544-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add spacing checks for struct, union, and enum definitions.  Check the
spacing after type and before the equals (=) and open brace ({).

Based on a patch by Joe Perches <joe@perches.com>.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index bcdb54b..983ac18 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1905,6 +1905,16 @@ sub process {
 			ERROR("open brace '{' following function declarations go on the next line\n" . $herecurr);
 		}
 
+# missing space after union or struct definition
+		if ($rawline =~ /^\+\s*(union|struct)\s+$Ident[=\{]/) {
+		    WARN("Missing space after struct or union definition\n" . $herecurr);
+		}
+
+# missing space after enum definition
+		if ($rawline =~ /^\+\s*enum\{/) {
+		    WARN("Missing space after enum definition\n" . $herecurr);
+		}
+
 # open braces for enum, union and struct go on the same line.
 		if ($line =~ /^.\s*{/ &&
 		    $prevline =~ /^.\s*(?:typedef\s+)?(enum|union|struct)(?:\s+$Ident)?\s*$/) {
-- 
1.7.0.4

