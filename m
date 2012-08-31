Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714Ab2HaNSe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 09:18:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62059 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662Ab2HaNSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 09:18:32 -0400
From: Cruz Julian Bishop <cruzjbishop@gmail.com>
To: mcgrof@gmail.com
Cc: linux-kernel@vger.kernel.org, Cruz Julian Bishop <cruzjbishop@gmail.com>
Subject: [PATCH 3/4] scripts/checkincludes.pl: Fix a bug introduced in the last commit
Date: Fri, 31 Aug 2012 23:18:09 +1000
Message-Id: <1346419090-3808-4-git-send-email-cruzjbishop@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1346419090-3808-1-git-send-email-cruzjbishop@gmail.com>
References: <1346419090-3808-1-git-send-email-cruzjbishop@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the previous commit, simply specifying -r without any files
caused no message to be displayed.

Before said commit, the usage() function was called.

This commit simply calls the usage() function if no files were
specified - This includes once other arguments are supported.

Signed-off-by: Cruz Julian Bishop <cruzjbishop@gmail.com>
---
 scripts/checkincludes.pl |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/scripts/checkincludes.pl b/scripts/checkincludes.pl
index 7d713c2..cde7ce1 100755
--- a/scripts/checkincludes.pl
+++ b/scripts/checkincludes.pl
@@ -30,12 +30,16 @@ if ($#ARGV < 0) {
 	usage();
 }
 
+my $argc = 0;
+
 foreach my $arg (@ARGV) {
 	if ($arg eq "-r") {
 		$remove = 1;
 	} else {
 		open(my $f, '<', $arg)
 		    or die "Cannot open $arg: $!.\n";
+		    
+		$argc++;
 
 		my %includedfiles = ();
 		my @file_lines = ();
@@ -84,3 +88,7 @@ foreach my $arg (@ARGV) {
 		close($f);
 	}
 }
+
+if ($argc == 0) {
+	usage();
+}
-- 
1.7.9.5

