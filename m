Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759464Ab0GAVwY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:52:24 -0400
Received: from kroah.org ([198.145.64.141]:60867 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758951Ab0GAVNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:13:41 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:52 2010
Message-Id: <20100701174252.161221950@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:42:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jan Beulich <jbeulich@novell.com>, Andi Kleen <ak@linux.intel.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [068/200] drivers/base/cpu.c: fix the output from /sys/devices/system/cpu/offline
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Beulich <JBeulich@novell.com>

commit cdc6e3d3968052cebb2f2ddcd742bff29fbd1a90 upstream.

Without CONFIG_CPUMASK_OFFSTACK, simply inverting cpu_online_mask leads
to CPUs beyond nr_cpu_ids to be displayed twice and CPUs not even
possible to be displayed as offline.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/base/cpu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -186,7 +186,7 @@ static ssize_t print_cpus_offline(struct
 	/* display offline cpus < nr_cpu_ids */
 	if (!alloc_cpumask_var(&offline, GFP_KERNEL))
 		return -ENOMEM;
-	cpumask_complement(offline, cpu_online_mask);
+	cpumask_andnot(offline, cpu_possible_mask, cpu_online_mask);
 	n = cpulist_scnprintf(buf, len, offline);
 	free_cpumask_var(offline);
 


