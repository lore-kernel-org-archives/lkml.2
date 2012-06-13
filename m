Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab2FMSvA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 14:51:00 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:39822 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752890Ab2FMSu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 14:50:59 -0400
Message-ID: <1339613458.28729.5.camel@joe2Laptop>
Subject: [PATCH] checkpatch: Update alignment check
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, LKML <linux-kernel@vger.kernel.org>
Date: Wed, 13 Jun 2012 11:50:58 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parenthesis alignment doesn't correctly check an existing line
after an inserted or modified line with an open parenthesis.

Fix it.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index e5bd60f..630319a 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1848,8 +1848,8 @@ sub process {
 
 			my $pos = pos_last_openparen($rest);
 			if ($pos >= 0) {
-				$line =~ /^\+([ \t]*)/;
-				my $newindent = $1;
+				$line =~ /^(\+| )([ \t]*)/;
+				my $newindent = $2;
 
 				my $goodtabindent = $oldindent .
 					"\t" x ($pos / 8) .


