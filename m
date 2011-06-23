Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964875Ab1FWSWT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:22:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:3004 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933189Ab1FWSWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 14:22:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,414,1304319600"; 
   d="scan'208";a="19879205"
Message-Id: <20110623181925.983511592@sbsiddha-MOBL3.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Thu, 23 Jun 2011 11:19:25 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, trenn@suse.de,
        prarit@redhat.com, tj@kernel.org, rusty@rustcorp.com.au,
        a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
        torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com,
        youquan.song@intel.com
Subject: [patch v2 0/4] MTRR rendezvous deadlock fix and cleanups using stop_machine()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the v2 of the MTRR stop machine patchset.

First patch is a simple fix targeting 3.0 and the stable kernels.
This fixes the boot deadlock reported in the
https://bugzilla.novell.com/show_bug.cgi?id=672008

Second patch reorganizes the stop_cpus() code.

Third patch introduces stop_machine_from_inactive_cpu() so that we can do
stop machine from the cpu hotplug path, where the calling cpu is not
yet active.

Fourth patch uses the stop_machine() and stop_machine_from_inactive_cpu()
to implement the x86 MTRR rendezvous sequence and thus remove the duplicate
implementation of stop machine using stop_one_cpu_nowait().

changes from v1:
* update comments and use cpu active instead of the cpu online checks.

thanks,
suresh


