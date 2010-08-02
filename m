Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751Ab0HBWB4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 18:01:56 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26389 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755571Ab0HBWBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 18:01:23 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6062"; a="49642674"
From: Patrick Pannuto <ppannuto@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: ppannuto@codeaurora.org, apw@canonical.com, corbet@lwn.net,
        arjan@linux.intel.com, linux-arm-msm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>
Subject: [PATCH 4/4] Checkpatch: warn about unexpectedly long msleep's
Date: Mon,  2 Aug 2010 15:01:07 -0700
Message-Id: <1280786467-26999-5-git-send-email-ppannuto@codeaurora.org>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1280786467-26999-1-git-send-email-ppannuto@codeaurora.org>
References: <1280786467-26999-1-git-send-email-ppannuto@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As explained in Documentation/timers/timers-howto.txt, msleep's
of < 20ms may sleep for as long as 20ms. Caller's of
msleep(1) or msleep(2), etc are likely not to expect this
quirky behavior - warn them.

Signed-off-by: Patrick Pannuto <ppannuto@codeaurora.org>
---
 scripts/checkpatch.pl |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 1698c63..8536c33 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2578,6 +2578,13 @@ sub process {
 			}
 		}
 
+# warn about unexpectedly long msleep's
+		if ($line =~ /\bmsleep\s*\((\d+)\);/) {
+			if ($1 < 20) {
+				WARN("msleep < 20ms can sleep for up to 20ms; see Documentation/timers/timers-howto.txt\n" . $line);
+			}
+		}
+
 # warn about #ifdefs in C files
 #		if ($line =~ /^.\s*\#\s*if(|n)def/ && ($realfile =~ /\.c$/)) {
 #			print "#ifdef in C files should be avoided\n";
-- 
1.7.2

