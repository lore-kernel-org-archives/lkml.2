Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758798Ab2HVJDy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 05:03:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40165 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857Ab2HVJDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 05:03:50 -0400
Date: Wed, 22 Aug 2012 02:03:24 -0700
From: "tip-bot for Liu, Chuansheng" <chuansheng.liu@intel.com>
Message-ID: <tip-2530cd4f448935c74eeb49f29559589928e4b2f0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yanmin_zhang@linux.intel.com, tglx@linutronix.de,
        chuansheng.liu@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yanmin_zhang@linux.intel.com, tglx@linutronix.de,
        chuansheng.liu@intel.com
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A137286@SHSMSX101.ccr.corp.intel.com>
References: <27240C0AC20F114CBF8149A2696CBE4A137286@SHSMSX101.ccr.corp.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/fixup_irq:
  Use cpu_online_mask instead of cpu_all_mask
Git-Commit-ID: 2530cd4f448935c74eeb49f29559589928e4b2f0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 22 Aug 2012 02:03:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2530cd4f448935c74eeb49f29559589928e4b2f0
Gitweb:     http://git.kernel.org/tip/2530cd4f448935c74eeb49f29559589928e4b2f0
Author:     Liu, Chuansheng <chuansheng.liu@intel.com>
AuthorDate: Tue, 14 Aug 2012 06:55:01 +0000
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 22 Aug 2012 10:36:08 +0200

x86/fixup_irq: Use cpu_online_mask instead of cpu_all_mask

When one CPU is going down and this CPU is the last one in irq
affinity, current code is setting cpu_all_mask as the new
affinity for that irq.

But for some systems (such as in Medfield Android mobile) the
firmware sends the interrupt to each CPU in the irq affinity
mask, averaged, and cpu_all_mask includes all potential CPUs,
i.e. offline ones as well.

So replace cpu_all_mask with cpu_online_mask.

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
Acked-by: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/27240C0AC20F114CBF8149A2696CBE4A137286@SHSMSX101.ccr.corp.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/irq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 7ad683d..d44f782 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -270,7 +270,7 @@ void fixup_irqs(void)
 
 		if (cpumask_any_and(affinity, cpu_online_mask) >= nr_cpu_ids) {
 			break_affinity = 1;
-			affinity = cpu_all_mask;
+			affinity = cpu_online_mask;
 		}
 
 		chip = irq_data_get_irq_chip(data);
