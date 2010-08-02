Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647Ab0HBWBZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 18:01:25 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26389 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755570Ab0HBWBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 18:01:22 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6062"; a="49642673"
From: Patrick Pannuto <ppannuto@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: ppannuto@codeaurora.org, apw@canonical.com, corbet@lwn.net,
        arjan@linux.intel.com, linux-arm-msm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>
Subject: [PATCH 3/4] Checkpatch: prefer usleep_range over udelay
Date: Mon,  2 Aug 2010 15:01:06 -0700
Message-Id: <1280786467-26999-4-git-send-email-ppannuto@codeaurora.org>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1280786467-26999-1-git-send-email-ppannuto@codeaurora.org>
References: <1280786467-26999-1-git-send-email-ppannuto@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When possible, sleeping is (usually) better than delaying;
however, don't bother callers of udelay < 10us, as those
cases are generally not worth the switch to usleep

Signed-off-by: Patrick Pannuto <ppannuto@codeaurora.org>
---
 scripts/checkpatch.pl |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index bd88f11..1698c63 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2570,6 +2570,14 @@ sub process {
 			}
 		}
 
+# prefer usleep_range over udelay
+		if (($line =~ /\budelay\s*\(\s*(\w+)\s*\)/ {
+			# ignore udelay's < 10, however
+			if (! (($1 =~ /(\d+)/) && ($1 < 10)) ) {
+				CHK("usleep_range is preferred over udelay; see Documentation/timers/timers-howto.txt\n" . $line);
+			}
+		}
+
 # warn about #ifdefs in C files
 #		if ($line =~ /^.\s*\#\s*if(|n)def/ && ($realfile =~ /\.c$/)) {
 #			print "#ifdef in C files should be avoided\n";
-- 
1.7.2

