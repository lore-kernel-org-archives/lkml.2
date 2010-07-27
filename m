Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab0G0Wje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 18:39:34 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:8648 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699Ab0G0Wj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 18:39:28 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6056"; a="48846756"
From: Patrick Pannuto <ppannuto@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: ppannuto@codeaurora.org, Andy Whitcroft <apw@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>
Subject: [PATCH 3/4] Checkpatch: prefer usleep_range over usleep
Date: Tue, 27 Jul 2010 15:39:06 -0700
Message-Id: <1280270347-4409-4-git-send-email-ppannuto@codeaurora.org>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1280270347-4409-1-git-send-email-ppannuto@codeaurora.org>
References: <1280270347-4409-1-git-send-email-ppannuto@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In (almost) every case, usleep_range is better than
usleep, as the precise (ish) wakeup - more accurately
the extra interrupt - from usleep is unnecessary.

usleep_range gives a much better chance of coalescing
processor wakeups.

Signed-off-by: Patrick Pannuto <ppannuto@codeaurora.org>
---
 scripts/checkpatch.pl |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index e3625ac..0650ab9 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2578,6 +2578,11 @@ sub process {
 			}
 		}
 
+# prefer usleep_range over usleep
+		if ($line =~ /\busleep\s*\(.+\);/) {
+			WARN("usleep_range is preferred over usleep; see Documentation/timers/delays.txt\n" . $line);
+		}
+
 # warn about #ifdefs in C files
 #		if ($line =~ /^.\s*\#\s*if(|n)def/ && ($realfile =~ /\.c$/)) {
 #			print "#ifdef in C files should be avoided\n";
-- 
1.7.2

