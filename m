Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab0HRPsW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 11:48:22 -0400
Received: from adelie.canonical.com ([91.189.90.139]:51886 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab0HRPrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 11:47:11 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 06/16] checkpatch: returning errno typically should be negative
Date: Wed, 18 Aug 2010 16:46:39 +0100
Message-Id: <1282146409-30544-7-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282146409-30544-1-git-send-email-apw@canonical.com>
References: <1282146409-30544-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a (strict mode only) test to check for non-negative returns of what
appear to be errno values as the majority case these should indeed be
negative.

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 3cec299..bcdb54b 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2204,6 +2204,13 @@ sub process {
 				ERROR("space required before the open parenthesis '('\n" . $herecurr);
 			}
 		}
+# Return of what appears to be an errno should normally be -'ve
+		if ($line =~ /^.\s*return\s*(E[A-Z]*)\s*;/) {
+			my $name = $1;
+			if ($name ne 'EOF' && $name ne 'ERROR') {
+				WARN("return of an errno should typically be -ve (return -$1)\n" . $herecurr);
+			}
+		}
 
 # Need a space before open parenthesis after if, while etc
 		if ($line=~/\b(if|while|for|switch)\(/) {
-- 
1.7.0.4

