Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab0E1Ghk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 02:37:40 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36681 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930Ab0E1Ghg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 02:37:36 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <w.sang@pengutronix.de>,
       Russell King <linux@arm.linux.org.uk>,
       Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] checkpatch: refactor 'allowed asm includes' and add memory.h
Date: Fri, 28 May 2010 08:37:12 +0200
Message-Id: <1275028632-17190-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.0
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the check suggesting replacement of asm-includes with
linux-includes. Exceptions to this rule are easier to extend now. Add
memory.h because ARM has a custom one.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 scripts/checkpatch.pl |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index bd88f11..315faf9 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -224,6 +224,12 @@ our @modifierList = (
 	qr{fastcall},
 );
 
+our $allowed_asm_includes = qr{(?x:
+	irq|
+	memory
+)};
+# memory.h: ARM has a custom one
+
 sub build_types {
 	my $mods = "(?x:  \n" . join("|\n  ", @modifierList) . "\n)";
 	my $all = "(?x:  \n" . join("|\n  ", @typeList) . "\n)";
@@ -2308,7 +2314,7 @@ sub process {
 			my $checkfile = "include/linux/$file";
 			if (-f "$root/$checkfile" &&
 			    $realfile ne $checkfile &&
-			    $1 ne 'irq')
+			    $1 !~ /$allowed_asm_includes/)
 			{
 				if ($realfile =~ m{^arch/}) {
 					CHK("Consider using #include <linux/$file> instead of <asm/$file>\n" . $herecurr);
-- 
1.7.0

