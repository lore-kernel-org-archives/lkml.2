Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789Ab0LORUy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 12:20:54 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61754 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab0LORUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 12:20:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=kG+kZb2t67RjpMY31ecUlov+BvYsruBI3rU61pGdaXbSWsVTNcMPapUniP4+eUbqX9
         homvyoFYsmR6ZRIk57Ms2gmq64zjgn7VZXoB5JrCzASLz5ZLgq0VUZ2kbjekXp9Yx41k
         8G1at8LcX2X7ph9flWgn7jp/dEc4YU5OpM2vE=
Message-ID: <4D08F825.3050206@gmail.com>
Date: Wed, 15 Dec 2010 18:17:25 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: apw@canonical.com
Subject: [PATCH] scripts: add no-warning option to the checkpatch script
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marco Stornelli <marco.stornelli@gmail.com>

Add no-warning option to the checkpatch script.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---

--- linux-2.6.36-orig/scripts/checkpatch.pl	2010-10-20 22:30:22.000000000 +0200
+++ linux-2.6.36/scripts/checkpatch.pl	2010-11-28 12:40:24.000000000 +0100
@@ -15,6 +15,7 @@ my $V = '0.30';
 use Getopt::Long qw(:config no_auto_abbrev);
 
 my $quiet = 0;
+my $chk_warn = 1;
 my $tree = 1;
 my $chk_signoff = 1;
 my $chk_patch = 1;
@@ -39,6 +40,7 @@ Version: $V
 
 Options:
   -q, --quiet                quiet
+  --no-warning               do not report warnings
   --no-tree                  run without a kernel tree
   --no-signoff               do not check for 'Signed-off-by' line
   --patch                    treat FILE as patchfile (default)
@@ -65,6 +67,7 @@ EOM
 
 GetOptions(
 	'q|quiet+'	=> \$quiet,
+	'warning!'	=> \$chk_warn,
 	'tree!'		=> \$tree,
 	'signoff!'	=> \$chk_signoff,
 	'patch!'	=> \$chk_patch,
@@ -1087,7 +1090,7 @@ sub ERROR {
 	}
 }
 sub WARN {
-	if (report("WARNING: $_[0]\n")) {
+	if ($chk_warn && report("WARNING: $_[0]\n")) {
 		our $clean = 0;
 		our $cnt_warn++;
 	}

