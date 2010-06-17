Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932871Ab0FQJ5J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 05:57:09 -0400
Received: from mail.perches.com ([173.55.12.10]:1162 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932822Ab0FQJ5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 05:57:07 -0400
Subject: [PATCH] checkpatch.pl: Add check for space after struct or union
 definition
From: Joe Perches <joe@perches.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Jun 2010 02:57:04 -0700
Message-ID: <1276768624.1005.34.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index bd88f11..59084fe 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1876,6 +1876,16 @@ sub process {
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


