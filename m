Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932311Ab1EWSpU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 14:45:20 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:50535 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756404Ab1EWSpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 14:45:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=BGBla0GO9g61lZByPLtySanJnojhw/63rT1Y22Xvdvu00VrHNVu7yWwdR+k55n83c8
         QdZ5KIM228mQn14lKVfQZGmAwhQR3MxTxvQjY4fYR2o72V7W22aHsVoQCN8qU7VboKOE
         Nfy2zfJ8T+CBHFWQjwunnCKGAk+wf1NSVjJGY=
From: Jim Cromie <jim.cromie@gmail.com>
To: rdunlap@xenotime.net
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 3/3] in scripts/export_report.pl use warn() to issue WARNING, so they go to stderr.
Date: Mon, 23 May 2011 12:44:57 -0600
Message-Id: <1306176297-6964-4-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1306176297-6964-1-git-send-email-jim.cromie@gmail.com>
References: <1305966108-13399-4-git-send-email-jim.cromie@gmail.com>
 <1306176297-6964-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also count CONFIG_MODVERSIONS warnings, and print a NOTE at start of
SECTION 2 if any were issued.  Section 2 will be empty if the build is
lacking this CONFIG_ item, and user may have missed the warnings, as
they're off screen.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 scripts/export_report.pl |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/scripts/export_report.pl b/scripts/export_report.pl
index 48398a1..8f79b70 100644
--- a/scripts/export_report.pl
+++ b/scripts/export_report.pl
@@ -102,6 +102,8 @@ close($module_symvers);
 #
 # collect the usage count of each symbol.
 #
+my $modversion_warnings = 0;
+
 foreach my $thismod (@allcfiles) {
 	my $module;
 
@@ -132,7 +134,8 @@ foreach my $thismod (@allcfiles) {
 		}
 	}
 	if ($state != 2) {
-		print "WARNING:$thismod is not built with CONFIG_MODVERSION enabled\n";
+		warn "WARNING:$thismod is not built with CONFIG_MODVERSIONS enabled\n";
+		$modversion_warnings++;
 	}
 	close($module);
 }
@@ -166,6 +169,9 @@ printf("SECTION 2:\n\tThis section reports export-symbol-usage of in-kernel
 modules. Each module lists the modules, and the symbols from that module that
 it uses.  Each listed symbol reports the number of modules using it\n");
 
+print "\nNOTE: Got $modversion_warnings CONFIG_MODVERSIONS warnings\n\n"
+    if $modversion_warnings;
+
 print "~"x80 , "\n";
 for my $thismod (sort keys %MODULE) {
 	my $list = $MODULE{$thismod};
-- 
1.7.4.4

