Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181Ab2E1AAw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 20:00:52 -0400
Received: from fed1rmfepo101.cox.net ([68.230.241.143]:51919 "EHLO
	fed1rmfepo101.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab2E1AAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 20:00:50 -0400
X-CT-Class: Clean
X-CT-Score: 0.00
X-CT-RefID: str=0001.0A020201.4FC2C031.003F,ss=1,re=0.000,fgs=0
X-CT-Spam: 0
X-Authority-Analysis: v=1.1 cv=KX+v5h4Bo19/wPa7BIMoXY6ArU991IQkCVNWm470N+4=
 c=1 sm=1 a=QCgkks1ZXMQA:10 a=rcTfVT_afHIA:10 a=zukJ/Oo2bNzQHA4rRbcyFw==:17
 a=R_N1NMmAAAAA:8 a=QpeYVz3W_ADHj31c8xgA:9 a=QOiTB_lUNkwA:10
 a=zukJ/Oo2bNzQHA4rRbcyFw==:117
X-CM-Score: 0.00
Authentication-Results: cox.net; none
From: Eric Nelson <eric.nelson@boundarydevices.com>
To: apw@canonical.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, joe@perches.com,
        Eric Nelson <eric.nelson@boundarydevices.com>
Subject: [PATCH V3] checkpatch: check for whitespace before semicolon at EOL
Date: Sun, 27 May 2012 17:00:46 -0700
Message-Id: <1338163246-6727-1-git-send-email-eric.nelson@boundarydevices.com>
X-Mailer: git-send-email 1.7.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Requires --strict option during invocation:
	~/linux$ scripts/checkpatch --strict foo.patch

This tests for a bad habits of mine like this:

	return 0 ;

Note that it does allow a special case of a bare semicolon
for empty loops:

	while (foo())
		;

Signed-off-by: Eric Nelson <eric.nelson@boundarydevices.com>
---
 scripts/checkpatch.pl |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index faea0ec..2262e1f 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2448,6 +2448,13 @@ sub process {
 				     "space prohibited between function name and open parenthesis '('\n" . $herecurr);
 			}
 		}
+
+# check for whitespace before a non-naked semicolon
+		if ($line =~ /^\+.*\S\s+;/) {
+			CHK("SPACING",
+			    "space prohibited before semicolon\n" . $herecurr);
+		}
+
 # Check operator spacing.
 		if (!($line=~/\#\s*include/)) {
 			my $ops = qr{
-- 
1.7.9

