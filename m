Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064Ab2LDKTO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 05:19:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44176 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757Ab2LDKTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 05:19:13 -0500
From: Michal Marek <mmarek@suse.cz>
To: dhowells@redhat.com
Cc: linux-kernel@vger.kernel.org, rusty@ozlabs.org
Subject: [PATCH 1/3] MODSIGN: Fix comparison erros in scripts/sign-file
Date: Tue,  4 Dec 2012 11:18:39 +0100
Message-Id: <1354616321-13520-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michal Marek <mmarek@suse.cz>
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
-- 
1.7.10.4

