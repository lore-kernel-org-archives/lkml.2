Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933241Ab2KNWr6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 17:47:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45577 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932997Ab2KNWr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 17:47:56 -0500
Date: Wed, 14 Nov 2012 13:26:50 -0800
From: tip-bot for Fenghua Yu <fenghua.yu@intel.com>
Message-ID: <tip-6e32d479db6079dd5d4309aa66aecbcf2664a5fe@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fenghua.yu@intel.com, rafael.j.wysocki@intel.com,
        srivatsa.bhat@linux.vnet.ibm.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de,
        srivatsa.bhat@linux.vnet.ibm.com, rafael.j.wysocki@intel.com,
        hpa@linux.intel.com
In-Reply-To: <1352835171-3958-7-git-send-email-fenghua.yu@intel.com>
References: <1352835171-3958-7-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/bsp-hotplug] kernel/cpu.c:
  Add comment for priority in cpu_hotplug_pm_callback
Git-Commit-ID: 6e32d479db6079dd5d4309aa66aecbcf2664a5fe
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 14 Nov 2012 14:46:48 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6e32d479db6079dd5d4309aa66aecbcf2664a5fe
Gitweb:     http://git.kernel.org/tip/6e32d479db6079dd5d4309aa66aecbcf2664a5fe
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Tue, 13 Nov 2012 11:32:43 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 14 Nov 2012 09:39:50 -0800

kernel/cpu.c: Add comment for priority in cpu_hotplug_pm_callback

cpu_hotplug_pm_callback should have higher priority than
bsp_pm_callback which depends on cpu_hotplug_pm_callback to disable cpu hotplug
to avoid race during bsp online checking.

This is to hightlight the priorities between the two callbacks in case people
may overlook the order.

Ideally the priorities should be defined in macro/enum instead of fixed values.
To do that, a seperate patchset may be pushed which will touch serveral other
generic files and is out of scope of this patchset.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1352835171-3958-7-git-send-email-fenghua.yu@intel.com
Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 kernel/cpu.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 42bd331..a2491a2 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -601,6 +601,11 @@ cpu_hotplug_pm_callback(struct notifier_block *nb,
 
 static int __init cpu_hotplug_pm_sync_init(void)
 {
+	/*
+	 * cpu_hotplug_pm_callback has higher priority than x86
+	 * bsp_pm_callback which depends on cpu_hotplug_pm_callback
+	 * to disable cpu hotplug to avoid cpu hotplug race.
+	 */
 	pm_notifier(cpu_hotplug_pm_callback, 0);
 	return 0;
 }
