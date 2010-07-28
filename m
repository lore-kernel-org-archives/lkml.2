Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab0G1Td5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 15:33:57 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:12545 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892Ab0G1TdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 15:33:17 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6057"; a="49104469"
From: Patrick Pannuto <ppannuto@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: ppannuto@codeaurora.org, apw@canonical.com, corbet@lwn.net,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>
Subject: [PATCH 3/4] Checkpatch: prefer usleep over udelay
Date: Wed, 28 Jul 2010 12:33:06 -0700
Message-Id: <1280345587-19725-4-git-send-email-ppannuto@codeaurora.org>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1280345587-19725-1-git-send-email-ppannuto@codeaurora.org>
References: <1280345587-19725-1-git-send-email-ppannuto@codeaurora.org>
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
index bd88f11..892ae62 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2570,6 +2570,14 @@ sub process {
 			}
 		}
 
+# prefer usleep over udelay
+		if (($line =~ /\budelay\s*\(\s*(\w+)\s*\)/ {
+			# ignore udelay's < 10, however
+			if (! (($1 =~ /(\d+)/) && ($1 < 10)) ) {
+				CHK("usleep is preferred over udelay; see Documentation/timers/delays.txt\n" . $line);
+			}
+		}
+
 # warn about #ifdefs in C files
 #		if ($line =~ /^.\s*\#\s*if(|n)def/ && ($realfile =~ /\.c$/)) {
 #			print "#ifdef in C files should be avoided\n";
-- 
1.7.2

