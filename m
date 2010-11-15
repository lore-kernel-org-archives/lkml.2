Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932700Ab0KOQ57 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 11:57:59 -0500
Received: from mail.perches.com ([173.55.12.10]:1288 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932499Ab0KOQ56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 11:57:58 -0500
Subject: [PATCH] scripts/checkpatch.pl: Add check for multiple terminating
 semicolons and casts of vmalloc
From: Joe Perches <joe@perches.com>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Nov 2010 08:57:56 -0800
Message-ID: <1289840276.16461.135.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index e3c7fc0..36d6851 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2785,10 +2785,15 @@ sub process {
 		}
 
 # check for pointless casting of kmalloc return
-		if ($line =~ /\*\s*\)\s*k[czm]alloc\b/) {
+		if ($line =~ /\*\s*\)\s*[kv][czm]alloc(_node){0,1}\b/) {
 			WARN("unnecessary cast may hide bugs, see http://c-faq.com/malloc/mallocnocast.html\n" . $herecurr);
 		}
 
+# check for multiple semicolons
+		if ($line =~ /;\s*;\s*$/) {
+		    WARN("Statements terminations use 1 semicolon\n" . $herecurr);
+		}
+
 # check for gcc specific __FUNCTION__
 		if ($line =~ /__FUNCTION__/) {
 			WARN("__func__ should be used instead of gcc specific __FUNCTION__\n"  . $herecurr);


