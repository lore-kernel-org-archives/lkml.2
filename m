Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296Ab0GVVvt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 17:51:49 -0400
Received: from mail.perches.com ([173.55.12.10]:2039 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752767Ab0GVVvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 17:51:48 -0400
Subject: [PATCH] scripts/checkpatch.pl: Add more exceptions to 80 char lines
From: Joe Perches <joe@perches.com>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Jul 2010 14:51:46 -0700
Message-ID: <1279835506.1909.66.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add new logging functions netdev_<level> and netif_<level>.
Don't complain if the only thing on a line is a quoted string.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index bd88f11..b7445f6 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -195,7 +195,7 @@ our $typeTypedefs = qr{(?x:
 our $logFunctions = qr{(?x:
 	printk|
 	pr_(debug|dbg|vdbg|devel|info|warning|err|notice|alert|crit|emerg|cont)|
-	dev_(printk|dbg|vdbg|info|warn|err|notice|alert|crit|emerg|WARN)|
+	(dev|netdev|netif)_(printk|dbg|vdbg|info|warn|err|notice|alert|crit|emerg|WARN)|
 	WARN|
 	panic
 )};
@@ -1403,7 +1403,8 @@ sub process {
 #80 column limit
 		if ($line =~ /^\+/ && $prevrawline !~ /\/\*\*/ &&
 		    $rawline !~ /^.\s*\*\s*\@$Ident\s/ &&
-		    $line !~ /^\+\s*$logFunctions\s*\(\s*(?:KERN_\S+\s*)?"[X\t]*"\s*(?:,|\)\s*;)\s*$/ &&
+		    !($line =~ /^\+\s*$logFunctions\s*\(\s*(?:(KERN_\S+\s*|[^"]*))?"[X\t]*"\s*(?:,|\)\s*;)\s*$/ ||
+		    $line =~ /^\+\s*"[^"]*"\s*(?:\s*|,|\)\s*;)\s*$/) &&
 		    $length > 80)
 		{
 			WARN("line over 80 characters\n" . $herecurr);


