Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370Ab1GJSSk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 14:18:40 -0400
Received: from gw.minian.org ([83.96.227.91]:59614 "EHLO lab.minian.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756176Ab1GJSSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 14:18:39 -0400
From: Edwin van Vliet <edwin@cheatah.nl>
To: apw@canonical.com
Cc: linux-kernel@vger.kernel.org, Edwin van Vliet <edwin@cheatah.nl>
Subject: [PATCH] scripts/checkpatch.pl: added test for repeated lines
Date: Sun, 10 Jul 2011 20:18:09 +0200
Message-Id: <1310321889-25943-1-git-send-email-edwin@cheatah.nl>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Repeated lines may indicate a bug or code that needs clarification. If the
repeated line is intentional, an extra comment may be helpful for reviewers
since the repeated pattern is likely to draw attention.

Signed-off-by: Edwin van Vliet <edwin@cheatah.nl>
---
 scripts/checkpatch.pl |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index b0aa2c6..4b50496 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1479,6 +1479,11 @@ sub process {
 			WARN("adding a line without newline at end of file\n" . $herecurr);
 		}
 
+# check for repeated lines which may indicate bugs or lack of clarity
+		if ($rawline eq $prevrawline) {
+			WARN("repeated line\n" . $herecurr);
+		}
+
 # Blackfin: use hi/lo macros
 		if ($realfile =~ m@arch/blackfin/.*\.S$@) {
 			if ($line =~ /\.[lL][[:space:]]*=.*&[[:space:]]*0x[fF][fF][fF][fF]/) {
-- 
1.7.5.4

