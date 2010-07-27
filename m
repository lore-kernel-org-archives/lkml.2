Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533Ab0G0R1M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 13:27:12 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:14054 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab0G0R1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 13:27:11 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6056"; a="48951991"
Message-ID: <4C4F16EE.9010008@codeaurora.org>
Date: Tue, 27 Jul 2010 10:27:10 -0700
From: Israel Schlesinger <israels@codeaurora.org>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: apw@canonical.com, akpm@linux-foundation.org, joe@perches.com
Subject: [PATCH v2] checkpatch: Add warnings for use of mdelay()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mdelay is a busy-wait loop which is wasteful. If at all possible,
callers should use msleep instead of mdelay.

The only time mdelay is really appropriate is in atomic context,
however, delays of 1ms+ in atomic context are rather expensive, so
a warning for this case is probably appropriate as well to encourage
people to move such expensive delays outside of atomic context

Signed-off-by: Israel Schlesinger <israels@codeaurora.org>
---
 scripts/checkpatch.pl |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index bd88f11..9ce1cb5 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2570,6 +2570,11 @@ sub process {
 			}
 		}
 
+# check the patch for use of mdelay
+		if ($line =~ /\bmdelay\s*\(/) {
+			WARN("use of mdelay() found: msleep() is the preferred API.\n" . $line );
+		}
+
 # warn about #ifdefs in C files
 #		if ($line =~ /^.\s*\#\s*if(|n)def/ && ($realfile =~ /\.c$/)) {
 #			print "#ifdef in C files should be avoided\n";
-- 
1.7.0.2

-- 
Employee of Qualcomm Innovation Center, Inc. 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum

