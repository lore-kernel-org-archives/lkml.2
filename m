Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab1DWRvq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 13:51:46 -0400
Received: from mail.perches.com ([173.55.12.10]:4927 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752913Ab1DWRvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 13:51:44 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] checkpatch: Fix defect in printk(KERN_<LEVEL> 80 column exceptions
Date: Sat, 23 Apr 2011 10:51:41 -0700
Message-Id: <78c7a2ed2044e636504f8f42b4d7d8f94a4d2877.1303580986.git.joe@perches.com>
X-Mailer: git-send-email 1.7.5.rc3.dirty
In-Reply-To: <464728b8c51d26604943b31662f987997bb6a455.1303580986.git.joe@perches.com>
References: <464728b8c51d26604943b31662f987997bb6a455.1303580986.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, printk lines with a only KERN_PREFIX and a quoted string
without a comma or close paren that exceed 80 columns are flagged
with a warning.

ie:
	printk(KERN_WARNING "some long string that extends beond 80 cols..."
	       "and is continued on another line\n");

Allow this form instead of emitting a warning.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index fbe7733..5385f31 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1462,7 +1462,7 @@ sub process {
 #80 column limit
 		if ($line =~ /^\+/ && $prevrawline !~ /\/\*\*/ &&
 		    $rawline !~ /^.\s*\*\s*\@$Ident\s/ &&
-		    !($line =~ /^\+\s*$logFunctions\s*\(\s*(?:(KERN_\S+\s*|[^"]*))?"[X\t]*"\s*(?:,|\)\s*;)\s*$/ ||
+		    !($line =~ /^\+\s*$logFunctions\s*\(\s*(?:(KERN_\S+\s*|[^"]*))?"[X\t]*"\s*(?:|,|\)\s*;)\s*$/ ||
 		    $line =~ /^\+\s*"[^"]*"\s*(?:\s*|,|\)\s*;)\s*$/) &&
 		    $length > 80)
 		{
-- 
1.7.5.rc3.dirty

