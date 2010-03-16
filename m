Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933072Ab0CPQHx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 12:07:53 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:7270 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758278Ab0CPQHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 12:07:52 -0400
X-SpamScore: -24
X-BigFish: VPS-24(zz1432R98dN936eM62a3Lab9bhzz1202hzzz32i6bh2a8h62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KZDU4M-02-BZY-02
X-M-MSG: 
Date: Tue, 16 Mar 2010 17:07:33 +0100
From: Robert Richter <robert.richter@amd.com>
To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, eranian@google.com,
       linux-kernel@vger.kernel.org, gorcunov@openvz.org, peterz@infradead.org,
       fweisbec@gmail.com, ming.m.lin@intel.com, tglx@linutronix.de,
       mingo@elte.hu
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/x86] perf, x86: Implement initial P4 PMU driver
Message-ID: <20100316160733.GR1585@erda.amd.com>
References: <20100311165439.GB5129@lenovo>
 <tip-a072738e04f0eb26370e39ec679e9a0d65e49aea@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <tip-a072738e04f0eb26370e39ec679e9a0d65e49aea@git.kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 16 Mar 2010 16:07:34.0220 (UTC) FILETIME=[CA0278C0:01CAC522]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please see my patch below that fixes ther reporting error code that
returns from x86_pmu.hw_config.

-Robert

On 11.03.10 18:33:55, tip-bot for Cyrill Gorcunov wrote:
> Commit-ID:  a072738e04f0eb26370e39ec679e9a0d65e49aea
> Gitweb:     http://git.kernel.org/tip/a072738e04f0eb26370e39ec679e9a0d65e49aea
> Author:     Cyrill Gorcunov <gorcunov@openvz.org>
> AuthorDate: Thu, 11 Mar 2010 19:54:39 +0300
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Thu, 11 Mar 2010 18:51:08 +0100
> 
> perf, x86: Implement initial P4 PMU driver
> 
> The netburst PMU is way different from the "architectural
> perfomance monitoring" specification that current CPUs use.
> P4 uses a tuple of ESCR+CCCR+COUNTER MSR registers to handle
> perfomance monitoring events.

--

From: Robert Richter <robert.richter@amd.com>
Date: Tue, 16 Mar 2010 16:38:19 +0100
Subject: [PATCH] perf, x86: reporting error code that returns from x86_pmu.hw_config()

If x86_pmu.hw_config() fails a fixed error code (-EOPNOTSUPP) is
return even if a different error was reported. This patch fixes this.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 4e2480f..8982d92 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -467,8 +467,9 @@ static int __hw_perf_event_init(struct perf_event *event)
 	hwc->last_tag = ~0ULL;
 
 	/* Processor specifics */
-	if (x86_pmu.hw_config(attr, hwc))
-		return -EOPNOTSUPP;
+	err = x86_pmu.hw_config(attr, hwc);
+	if (err)
+		return err;
 
 	if (!hwc->sample_period) {
 		hwc->sample_period = x86_pmu.max_period;
-- 
1.7.0



-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

