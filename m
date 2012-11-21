Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461Ab2KUL0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 06:26:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62998 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754202Ab2KUL0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 06:26:20 -0500
Subject: [PATCH] sign-file: fix the perl warning message when extracting
 ASN.1
To: torvalds@osdl.org, rusty@rustcorp.com.au
From: David Howells <dhowells@redhat.com>
Cc: Chun-Yi Lee <jlee@suse.com>, linux-kernel@vger.kernel.org
Date: Wed, 21 Nov 2012 11:26:09 +0000
Message-ID: <20121121112609.5567.70258.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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

Signed-off-by: Chun-Yi Lee <jlee@suse.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 scripts/sign-file |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


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

