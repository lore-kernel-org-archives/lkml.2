Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab1DSMEW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 08:04:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:44942 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752205Ab1DSMEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 08:04:21 -0400
Date: Tue, 19 Apr 2011 12:03:56 GMT
From: tip-bot for Andre Przywara <andre.przywara@amd.com>
Message-ID: <tip-83112e688f5f05dea1e63787db9a6c16b2887a1d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, andre.przywara@amd.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, andre.przywara@amd.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1302913676-14352-2-git-send-email-robert.richter@amd.com>
References: <1302913676-14352-2-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf, x86: Fix pre-defined cache-misses event for AMD family 15h cpus
Git-Commit-ID: 83112e688f5f05dea1e63787db9a6c16b2887a1d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 19 Apr 2011 12:03:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  83112e688f5f05dea1e63787db9a6c16b2887a1d
Gitweb:     http://git.kernel.org/tip/83112e688f5f05dea1e63787db9a6c16b2887a1d
Author:     Andre Przywara <andre.przywara@amd.com>
AuthorDate: Sat, 16 Apr 2011 02:27:53 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 19 Apr 2011 10:07:54 +0200

perf, x86: Fix pre-defined cache-misses event for AMD family 15h cpus

With AMD cpu family 15h a unit mask was introduced for the Data Cache
Miss event (0x041/L1-dcache-load-misses). We need to enable bit 0
(first data cache miss or streaming store to a 64 B cache line) of
this mask to proper count data cache misses.

Now we set this bit for all families and models. In case a PMU does
not implement a unit mask for event 0x041 the bit is ignored.

Signed-off-by: Andre Przywara <andre.przywara@amd.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1302913676-14352-2-git-send-email-robert.richter@amd.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_amd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 461f62b..4e16138 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -8,7 +8,7 @@ static __initconst const u64 amd_hw_cache_event_ids
  [ C(L1D) ] = {
 	[ C(OP_READ) ] = {
 		[ C(RESULT_ACCESS) ] = 0x0040, /* Data Cache Accesses        */
-		[ C(RESULT_MISS)   ] = 0x0041, /* Data Cache Misses          */
+		[ C(RESULT_MISS)   ] = 0x0141, /* Data Cache Misses          */
 	},
 	[ C(OP_WRITE) ] = {
 		[ C(RESULT_ACCESS) ] = 0x0142, /* Data Cache Refills :system */
