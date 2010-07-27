Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab0G0Wjg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 18:39:36 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47445 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab0G0Wj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 18:39:28 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6056"; a="48987814"
From: Patrick Pannuto <ppannuto@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: ppannuto@codeaurora.org, Andy Whitcroft <apw@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>
Subject: [PATCH 4/4] Checkpatch: warn about unexpectedly long msleep's
Date: Tue, 27 Jul 2010 15:39:07 -0700
Message-Id: <1280270347-4409-5-git-send-email-ppannuto@codeaurora.org>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1280270347-4409-1-git-send-email-ppannuto@codeaurora.org>
References: <1280270347-4409-1-git-send-email-ppannuto@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As explained in Documentation/timers/delays.txt, msleep's
of < 20ms may sleep for as long as 20ms. Caller's of
msleep(1) or msleep(2), etc are likely not to expect this
quirky behavior - warn them.

Signed-off-by: Patrick Pannuto <ppannuto@codeaurora.org>
---
 scripts/checkpatch.pl |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 0650ab9..bbc2e76 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2583,6 +2583,13 @@ sub process {
 			WARN("usleep_range is preferred over usleep; see Documentation/timers/delays.txt\n" . $line);
 		}
 
+# warn about unexpectedly long msleep's
+		if ($line =~ /\bmsleep\s*\((\d+)\);/) {
+			if ($1 < 20) {
+				WARN("msleep < 20ms can sleep for up to 20ms; see Documentation/timers/delays.txt\n" . $line);
+			}
+		}
+
 # warn about #ifdefs in C files
 #		if ($line =~ /^.\s*\#\s*if(|n)def/ && ($realfile =~ /\.c$/)) {
 #			print "#ifdef in C files should be avoided\n";
-- 
1.7.2

