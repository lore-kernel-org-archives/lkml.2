Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab0JNCUB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 22:20:01 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58108 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754157Ab0JNCUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 22:20:00 -0400
Date: Thu, 14 Oct 2010 13:19:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>
Subject: linux-next: manual merge of the tip tree with the sh tree
Message-Id: <20101014131953.cc24b95d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the tip tree got a conflict in
arch/sh/kernel/perf_event.c between commit
51c6c9bb34fcd112d4ab8b8f5c1d1b6a10a00e71 ("sh: perf: Set up
perf_max_events") from the sh tree and commit
a4eaf7f14675cb512d69f0c928055e73d0c6d252 ("perf: Rework the PMU methods")
from the tip tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/sh/kernel/perf_event.c
index ecef1fe,036f7a9..0000000
--- a/arch/sh/kernel/perf_event.c
+++ b/arch/sh/kernel/perf_event.c
@@@ -319,13 -365,13 +365,14 @@@ int __cpuinit register_sh_pmu(struct sh
  {
  	if (sh_pmu)
  		return -EBUSY;
- 	sh_pmu = pmu;
+ 	sh_pmu = _pmu;
  
- 	pr_info("Performance Events: %s support registered\n", pmu->name);
+ 	pr_info("Performance Events: %s support registered\n", _pmu->name);
  
- 	WARN_ON(pmu->num_events > MAX_HWEVENTS);
- 	perf_max_events = pmu->num_events;
+ 	WARN_ON(_pmu->num_events > MAX_HWEVENTS);
++	perf_max_events = _pmu->num_events;
  
+ 	perf_pmu_register(&pmu);
  	perf_cpu_notifier(sh_pmu_notifier);
  	return 0;
  }
