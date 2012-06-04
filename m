Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875Ab2FDSak (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 14:30:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:2209 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755847Ab2FDS35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 14:29:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="160493201"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
        "H Peter Anvin" <hpa@zytor.com>,
        "Suresh B Siddha" <suresh.b.siddha@intel.com>,
        "Tony Luck" <tony.luck@intel.com>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "Arjan Dan De Ven" <arjan@linux.intel.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, "x86" <x86@kernel.org>,
        "linux-pm" <linux-pm@vger.kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH 6/6] x86/x2apic_phys.c: Wakeup function in x2apic_phys calls mwait or nmi method
Date: Mon,  4 Jun 2012 11:17:56 -0700
Message-Id: <1338833876-29721-8-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1338833876-29721-1-git-send-email-fenghua.yu@intel.com>
References: <1338833876-29721-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 	wmb();
+	printk("%s:%d\n",__func__,__LINE__);
 	cpu_idle();
 }
 
@@ -478,6 +479,8 @@ _wakeup_secondary_cpu_via_nmi(int apicid, int dest_mode)
 	unsigned long send_status, accept_status = 0;
 	int maxlvt;
 
+	printk("%s:%d\n",__func__,__LINE__);
+
 	/* Target chip */
 	/* Boot on the stack */
 	/* Kick the second */
@@ -530,6 +533,7 @@ DEFINE_PER_CPU(int, cpu_dead) = { 0 };
 
 static int wakeup_secondary_cpu_via_mwait(int cpu)
 {
+	printk("%s:%d\n",__func__,__LINE__);
 	per_cpu(cpu_dead, cpu) |= CPU_DEAD_TRIGGER;
 	return 0;
 }
@@ -553,6 +557,7 @@ wakeup_secondary_cpu_via_init(int phys_apicid, unsigned long start_eip)
 	unsigned long send_status, accept_status = 0;
 	int maxlvt, num_starts, j;
 
+	printk("%s:%d\n",__func__,__LINE__);
 	maxlvt = lapic_get_maxlvt();
 
 	/*
diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 6345294..b218149 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -49,6 +49,7 @@ static ssize_t __ref store_online(struct device *dev,
 			kobject_uevent(&dev->kobj, KOBJ_OFFLINE);
 		break;
 	case '1':
+		printk("%s:%d\n",__func__,__LINE__);
 		ret = cpu_up(cpu->dev.id);
 		if (!ret)
 			kobject_uevent(&dev->kobj, KOBJ_ONLINE);
