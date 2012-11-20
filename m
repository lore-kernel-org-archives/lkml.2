Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475Ab2KTKrD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 05:47:03 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:59898 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826Ab2KTKrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 05:47:01 -0500
From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
To: dhowells@redhat.com
Cc: linux-kernel@vger.kernel.org, jlee@suse.com
Subject: [PATCH] sign-file: fix the perl warning message when extracting ASN.1
Date: Tue, 20 Nov 2012 18:46:18 +0800
Message-Id: <1353408378-17496-1-git-send-email-jlee@suse.com>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There have the following warning message when running modules install for sign ko files:

# make modules_install
...
  INSTALL drivers/input/touchscreen/pcap_ts.ko
Found = in conditional, should be == at scripts/sign-file line 164.
Found = in conditional, should be == at scripts/sign-file line 161.
Found = in conditional, should be == at scripts/sign-file line 159.

This patch change replace '=' by '==' in elsif conditions for avoid the above warning messages.

Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 scripts/sign-file |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/scripts/sign-file b/scripts/sign-file
index 87ca59d..974a20b 100755
--- a/scripts/sign-file
+++ b/scripts/sign-file
@@ -156,12 +156,12 @@ sub asn1_extract($$@)
 
 	if ($l == 0x1) {
 	    $len = unpack("C", substr(${$cursor->[2]}, $cursor->[0], 1));
-	} elsif ($l = 0x2) {
+	} elsif ($l == 0x2) {
 	    $len = unpack("n", substr(${$cursor->[2]}, $cursor->[0], 2));
-	} elsif ($l = 0x3) {
+	} elsif ($l == 0x3) {
 	    $len = unpack("C", substr(${$cursor->[2]}, $cursor->[0], 1)) << 16;
 	    $len = unpack("n", substr(${$cursor->[2]}, $cursor->[0] + 1, 2));
-	} elsif ($l = 0x4) {
+	} elsif ($l == 0x4) {
 	    $len = unpack("N", substr(${$cursor->[2]}, $cursor->[0], 4));
 	} else {
 	    die $x509, ": ", $cursor->[0], ": ASN.1 element too long (", $l, ")\n";
-- 
1.6.0.2

