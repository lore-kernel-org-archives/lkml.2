Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab0IWDRU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 23:17:20 -0400
Received: from mail.perches.com ([173.55.12.10]:2267 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752804Ab0IWDRQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 23:17:16 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] scripts/get_maintainer.pl: Don't deduplicate unnamed addresses ie: mailing lists
Date: Wed, 22 Sep 2010 20:17:14 -0700
Message-Id: <0d856d95cdeeda55d110ba34deb9c7b857c773aa.1285209493.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1285209493.git.joe@perches.com>
References: <cover.1285209493.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a defect with the first mailing list address being used for
each subsequent mailing list.

Updated to 0.26-beta6.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/get_maintainer.pl |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index e822518..d21ec3a 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -13,7 +13,7 @@
 use strict;
 
 my $P = $0;
-my $V = '0.26-beta5';
+my $V = '0.26-beta6';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
@@ -1036,7 +1036,7 @@ sub push_email_address {
 	push(@email_to, [format_email($name, $address, $email_usename), $role]);
     } elsif (!email_inuse($name, $address)) {
 	push(@email_to, [format_email($name, $address, $email_usename), $role]);
-	$email_hash_name{lc($name)}++;
+	$email_hash_name{lc($name)}++ if ($name ne "");
 	$email_hash_address{lc($address)}++;
     }
 
@@ -1659,7 +1659,7 @@ sub deduplicate_email {
 
     ($name, $address) = parse_email($email);
 
-    if ($deduplicate_name_hash{lc($name)}) {
+    if ($name ne "" && $deduplicate_name_hash{lc($name)}) {
 	$name = $deduplicate_name_hash{lc($name)}->[0];
 	$address = $deduplicate_name_hash{lc($name)}->[1];
 	$matched = 1;
-- 
1.7.3

