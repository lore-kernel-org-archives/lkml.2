Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab2FSMPV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 08:15:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652Ab2FSMOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 08:14:48 -0400
From: Igor Mammedov <imammedo@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: prarit@redhat.com, oleg@redhat.com, rob@landley.net, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org, luto@mit.edu,
        suresh.b.siddha@intel.com, avi@redhat.com, imammedo@redhat.com,
        a.p.zijlstra@chello.nl, johnstul@us.ibm.com, arjan@linux.intel.com
Subject: [PATCH 2/2] x86: don't panic if master CPU haven't set cpu_callout_mask
Date: Tue, 19 Jun 2012 14:14:21 +0200
Message-Id: <1340108061-5128-3-git-send-email-imammedo@redhat.com>
In-Reply-To: <1340108061-5128-1-git-send-email-imammedo@redhat.com>
References: <1340108061-5128-1-git-send-email-imammedo@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gracefully cancel CPU initialization instead of panic when master
CPU haven't managed to set cpu_callout_mask in time.

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
---
 arch/x86/kernel/smpboot.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 95948b9..6470470 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -175,8 +175,9 @@ static void __cpuinit smp_callin(void)
 	}
 
 	if (!time_before(jiffies, timeout)) {
-		panic("%s: CPU%d started up but did not get a callout!\n",
+		pr_debug("%s: CPU%d started up but did not get a callout!\n",
 		      __func__, cpuid);
+		goto die;
 	}
 
 	/*
-- 
1.7.1

