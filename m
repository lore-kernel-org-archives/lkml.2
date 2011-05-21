Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab1EUIWb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 04:22:31 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:35391 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043Ab1EUIWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 04:22:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Giz9/xbQY8idN+8pfhOKkUQ6WT84x4RYhWXVXN3HWbunF2RNX4rCtQphrZunW6/SwC
         MsMLpK9qdvPOfcBD5LIz7zEyKmMpBNRBmLVnRteh0Tf/zDcRqqwceNF6e5ZHcgbrqR3G
         4qKC+haEgXcMnu+k1EIKetEVejX9e4O8gIHK0=
From: Jim Cromie <jim.cromie@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 3/3] in scripts/export_report.pl use warn() to issue WARNING, so they go to stderr.
Date: Sat, 21 May 2011 02:21:48 -0600
Message-Id: <1305966108-13399-4-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1305966108-13399-1-git-send-email-jim.cromie@gmail.com>
References: <1305966108-13399-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also count CONFIG_MODVERSION warnings, and print an NB message at
start of SECTION 2 if any were issued.  Section 2 will be empty
if the build is lacking this CONFIG_ item, and user may have missed
the warnings, as they're off screen.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 scripts/export_report.pl |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/scripts/export_report.pl b/scripts/export_report.pl
index 16bd240..14c1638 100644
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
+		warn "WARNING:$thismod is not built with CONFIG_MODVERSION enabled\n";
+		$modversion_warnings++;
 	}
 	close($module);
 }
@@ -166,6 +169,9 @@ printf("SECTION 2:\n\tThis section reports export-symbol-usage of in-kernel
 modules. Each module lists the modules, and the symbols from that module that
 it uses.  Each listed symbol reports the number of modules using it\n");
 
+print "\nNB: Got $modversion_warnings CONFIG_MODVERSION warnings\n\n"
+    if $modversion_warnings;
+
 print "~"x80 , "\n";
 for my $thismod (sort keys %MODULE) {
 	my $list = $MODULE{$thismod};
-- 
1.7.4.1

