Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab0DMU0z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 16:26:55 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:48470 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414Ab0DMU0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 16:26:49 -0400
X-SpamScore: -3
X-BigFish: VPS-3(zzab9bh655Lzz1202hzzz32i6bh87h2a8h467h43h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L0U0SD-02-H0B-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 06/12] perf, x86: use weight instead of cmask in for_each_event_constraint()
Date: Tue, 13 Apr 2010 22:23:15 +0200
Message-ID: <1271190201-25705-7-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
References: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 13 Apr 2010 20:26:35.0480 (UTC) FILETIME=[9CE38D80:01CADB47]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There may exist constraints with a cmask set to zero. In this case
for_each_event_constraint() will not work properly. Now weight is used
instead of the cmask for loop exit detection. Weight is always a value
other than zero since the default contains the HWEIGHT from the
counter mask and in other cases a value of zero does not fit too.

This is in preparation of ibs event constraints that wont have a
cmask.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index f66f52a..feda380 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -170,7 +170,7 @@ struct cpu_hw_events {
 	EVENT_CONSTRAINT(0, 0, 0)
 
 #define for_each_event_constraint(e, c)	\
-	for ((e) = (c); (e)->cmask; (e)++)
+	for ((e) = (c); (e)->weight; (e)++)
 
 union perf_capabilities {
 	struct {
-- 
1.7.0.3


