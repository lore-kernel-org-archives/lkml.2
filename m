Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759063Ab2EDQGb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 12:06:31 -0400
Received: from relay4.integra.net ([204.130.255.183]:65063 "HELO
	mail.integraonline.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1751182Ab2EDQG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 12:06:29 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 May 2012 12:06:29 EDT
From: Eric Nelson <eric.nelson@boundarydevices.com>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, u-boot@lists.denx.de, rylv50@freescale.com,
        marex@denx.de, vapier@gentoo.org, joe@perches.com,
        Eric Nelson <eric.nelson@boundarydevices.com>
Subject: [PATCH V2] checkpatch: add check for whitespace before semicolon at end-of-line
Date: Fri,  4 May 2012 08:59:46 -0700
Message-Id: <1336147186-27853-1-git-send-email-eric.nelson@boundarydevices.com>
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

---
V2 adds the special case and requirement for --strict based on
recommendations of Joe Perches.

 scripts/checkpatch.pl |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index a3b9782..e711122 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3227,6 +3227,12 @@ sub process {
 			 "Statements terminations use 1 semicolon\n" . $herecurr);
 		}
 
+# check for whitespace before semicolon - not allowed at end-of-line
+		if ($line =~ /\S+\s+;$/) {
+		    CHK("SPACING",
+			 "Whitespace before semicolon\n" . $herecurr);
+		}
+
 # check for gcc specific __FUNCTION__
 		if ($line =~ /__FUNCTION__/) {
 			WARN("USE_FUNC",
-- 
1.7.9

