Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759088Ab1FVWbM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 18:31:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:2505 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758297Ab1FVWbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 18:31:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,408,1304319600"; 
   d="scan'208";a="18489118"
Message-Id: <20110622222021.904952469@sbsiddha-MOBL3.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Wed, 22 Jun 2011 15:20:21 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, trenn@novell.com,
        prarit@redhat.com, tj@kernel.org, rusty@rustcorp.com.au,
        a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
        torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com,
        youquan.song@intel.com
Subject: [patch 0/4] MTRR rendezvous deadlock fix and cleanups using stop_machine()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, Peter:

Here is the updated MTRR stop machine patch-set.

First patch is a quick fix targeting 3.0 and the stable kernels.
This fixes the boot deadlock reported in the
https://bugzilla.novell.com/show_bug.cgi?id=672008

Second patch reorganizes the stop_cpus() code.

Third patch introduces stop_machine_from_offline_cpu() so that we can do
stop machine from the cpu hotplug path, where the calling cpu is not
yet online.

Fourth patch uses the stop_machine() and stop_machine_from_offline_cpu()
to implement the x86 MTRR rendezvous sequence and thus remove the duplicate
implementation of stop machine using stop_one_cpu_nowait().

thanks,
suresh


