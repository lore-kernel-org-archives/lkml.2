Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424Ab0CSQRN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 12:17:13 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:46564 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab0CSQRL convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Fri, 19 Mar 2010 12:17:11 -0400
Message-Id: <4BA3B1980200007800035F13@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 19 Mar 2010 16:17:12 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Rusty Russell" <rusty@rustcorp.com.au>, <travis@sgi.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] fix the output from /sys/devices/system/cpu/offline
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without CONFIG_CPUMASK_OFFSTACK, simply inverting cpu_online_mask leads
to CPUs beyond nr_cpu_ids to be displayed twice and CPUs not even
possible to be displayed as offline.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 drivers/base/cpu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.34-rc1/drivers/base/cpu.c
+++ 2.6.34-rc1-cpus-offline-display/drivers/base/cpu.c
@@ -185,7 +185,7 @@ static ssize_t print_cpus_offline(struct
 	/* display offline cpus < nr_cpu_ids */
 	if (!alloc_cpumask_var(&offline, GFP_KERNEL))
 		return -ENOMEM;
-	cpumask_complement(offline, cpu_online_mask);
+	cpumask_andnot(offline, cpu_possible_mask, cpu_online_mask);
 	n = cpulist_scnprintf(buf, len, offline);
 	free_cpumask_var(offline);
 



