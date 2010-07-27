Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab0G0Wj3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 18:39:29 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47445 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab0G0Wj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 18:39:28 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6056"; a="48987812"
From: Patrick Pannuto <ppannuto@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: ppannuto@codeaurora.org, Andy Whitcroft <apw@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>
Subject: [PATCH 2/4] Checkpatch: prefer usleep_range over udelay
Date: Tue, 27 Jul 2010 15:39:05 -0700
Message-Id: <1280270347-4409-3-git-send-email-ppannuto@codeaurora.org>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1280270347-4409-1-git-send-email-ppannuto@codeaurora.org>
References: <1280270347-4409-1-git-send-email-ppannuto@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When possible, sleeping is (usually) better than delaying,
however, don't bother callers of udelay < 10us, as those
cases are not with the switch to usleep_range

Signed-off-by: Patrick Pannuto <ppannuto@codeaurora.org>
---
 scripts/checkpatch.pl |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index bd88f11..e3625ac 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2570,6 +2570,14 @@ sub process {
 			}
 		}
 
+# prefer usleep_range over udelay
+		if ($line =~ /\budelay\s*\((.+)\);/) {
+			# ignore udelay's < 10, however
+			if (! (($1 =~ /(\d+)/) && ($1 < 10)) ) {
+				WARN("usleep_range is preferred over udelay; see Documentation/timers/delays.txt\n" . $line);
+			}
+		}
+
 # warn about #ifdefs in C files
 #		if ($line =~ /^.\s*\#\s*if(|n)def/ && ($realfile =~ /\.c$/)) {
 #			print "#ifdef in C files should be avoided\n";
-- 
1.7.2

