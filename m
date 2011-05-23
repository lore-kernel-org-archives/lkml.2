Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374Ab1EWSpZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 14:45:25 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44000 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757012Ab1EWSpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 14:45:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=S+XXxAdmExGNO+PsaHegz82I00ZCeIe2svR7NhqbjIgR1qqmuhq1bheT77G/9DXdBr
         gl+i1ZvshfjGRGP1YrINQZG2prTsWcgSC+m0qvqGrH03Sc4yDn5s8c/F+PAIWFi6iwAJ
         RSL78v0pEJTw6VxzXenJXwT1s9jYqrvHmbwrc=
From: Jim Cromie <jim.cromie@gmail.com>
To: rdunlap@xenotime.net
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 2/3] sort SECTION 2 output of scripts/export_report.pl
Date: Mon, 23 May 2011 12:44:56 -0600
Message-Id: <1306176297-6964-3-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1306176297-6964-1-git-send-email-jim.cromie@gmail.com>
References: <1305966108-13399-4-git-send-email-jim.cromie@gmail.com>
 <1306176297-6964-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sort SECTION 2 modules by name.  Within those module listings, sort
the symbol providers by name, and remove the count, as it is
misleading; its the kernel-wide count of uses of that symbol, not the
count pertaining to the module being outlined.  (this can be seen by
grepping the output for a single symbol).  The count is still used to
sort the symbols.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 scripts/export_report.pl |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/scripts/export_report.pl b/scripts/export_report.pl
index f97899c..48398a1 100644
--- a/scripts/export_report.pl
+++ b/scripts/export_report.pl
@@ -25,11 +25,12 @@ sub alphabetically {
 sub print_depends_on {
 	my ($href) = @_;
 	print "\n";
-	while (my ($mod, $list) = each %$href) {
+	for my $mod (sort keys %$href) {
+		my $list = $href->{$mod};
 		print "\t$mod:\n";
 		foreach my $sym (sort numerically @{$list}) {
 			my ($symbol, $no) = split /\s+/, $sym;
-			printf("\t\t%-25s\t%-25d\n", $symbol, $no);
+			printf("\t\t%-25s\n", $symbol);
 		}
 		print "\n";
 	}
@@ -166,7 +167,8 @@ modules. Each module lists the modules, and the symbols from that module that
 it uses.  Each listed symbol reports the number of modules using it\n");
 
 print "~"x80 , "\n";
-while (my ($thismod, $list) = each %MODULE) {
+for my $thismod (sort keys %MODULE) {
+	my $list = $MODULE{$thismod};
 	my %depends;
 	$thismod =~ s/\.mod\.c/.ko/;
 	print "\t\t\t$thismod\n";
-- 
1.7.4.4

