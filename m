Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934260Ab0EUQyc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 12:54:32 -0400
Received: from kroah.org ([198.145.64.141]:39065 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934117Ab0EUQyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:54:10 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jan Beulich <JBeulich@novell.com>, Jan Beulich <jbeulich@novell.com>,
       Andi Kleen <ak@linux.intel.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>, stable <stable@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 01/38] drivers/base/cpu.c: fix the output from /sys/devices/system/cpu/offline
Date: Fri, 21 May 2010 09:53:31 -0700
Message-Id: <1274460848-11377-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <20100521165106.GA11216@kroah.com>
References: <20100521165106.GA11216@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Beulich <JBeulich@novell.com>

Without CONFIG_CPUMASK_OFFSTACK, simply inverting cpu_online_mask leads
to CPUs beyond nr_cpu_ids to be displayed twice and CPUs not even
possible to be displayed as offline.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/cpu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index f35719a..251acea 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -186,7 +186,7 @@ static ssize_t print_cpus_offline(struct sysdev_class *class,
 	/* display offline cpus < nr_cpu_ids */
 	if (!alloc_cpumask_var(&offline, GFP_KERNEL))
 		return -ENOMEM;
-	cpumask_complement(offline, cpu_online_mask);
+	cpumask_andnot(offline, cpu_possible_mask, cpu_online_mask);
 	n = cpulist_scnprintf(buf, len, offline);
 	free_cpumask_var(offline);
 
-- 
1.7.0.3

