Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760894Ab2EQMzY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 08:55:24 -0400
Received: from smtp.nokia.com ([147.243.1.47]:21419 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753798Ab2EQMzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 08:55:22 -0400
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: apw@canonical.com
Cc: linux-kernel@vger.kernel.org, ext-phil.2.carmody@nokia.com
Subject: [PATCH 1/1] checkpatch: don't fake typedefs with #define
Date: Thu, 17 May 2012 15:52:12 +0300
Message-Id: <1337259132-28774-1-git-send-email-ext-phil.2.carmody@nokia.com>
X-Mailer: git-send-email 1.7.2.5
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

People seemed to be taking the "no typedefs" rule too literally,
and were using #define to abide by the letter rather than the
spirit of the law. E.g. #define FOO_t struct _FOO_t

Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
---
 scripts/checkpatch.pl |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index faea0ec..7dc41c5 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2299,6 +2299,12 @@ sub process {
 			     "do not add new typedefs\n" . $herecurr);
 		}
 
+# check for deliberate avoidance of the above anti-typedef rule
+		if ($line =~ /#\s*define\s+$Ident\s+$Type\b/) {
+			WARN("NEW_TYPEDEFS",
+			     "do not fake typedefs using #define\n" . $herecurr);
+		}
+
 # * goes on variable not on type
 		# (char*[ const])
 		while ($line =~ m{(\($NonptrType(\s*(?:$Modifier\b\s*|\*\s*)+)\))}g) {
-- 
1.7.2.5

