Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378Ab1FTQEL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 12:04:11 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:26539
	"EHLO CH1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753456Ab1FTQD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 12:03:59 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LN3JAD-01-4PW-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH] perf tools: Don't corrupt PERF-VERSION-FILE with make debug
Date: Mon, 20 Jun 2011 17:53:48 +0200
Message-ID: <1308585228-3982-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.5.3
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When running make with debug option -d the PERF-VERSION-FILE gets
corrupted because make is noisy:

 PERF-VERSION-FILE:2: *** missing separator.  Stop.

Fixing this by not passing the make flags in the MAKEFLAGS environment
variable to the sub-make that generates the version string.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 tools/perf/util/PERF-VERSION-GEN |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/PERF-VERSION-GEN b/tools/perf/util/PERF-VERSION-GEN
index 9c5fb4d..ad73300 100755
--- a/tools/perf/util/PERF-VERSION-GEN
+++ b/tools/perf/util/PERF-VERSION-GEN
@@ -23,7 +23,7 @@ if test -d ../../.git -o -f ../../.git &&
 then
 	VN=$(echo "$VN" | sed -e 's/-/./g');
 else
-	VN=$(make -sC ../.. kernelversion)
+	VN=$(MAKEFLAGS= make -sC ../.. kernelversion)
 fi
 
 VN=$(expr "$VN" : v*'\(.*\)')
-- 
1.7.5.3


