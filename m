Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541Ab0EJXbS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:31:18 -0400
Received: from kroah.org ([198.145.64.141]:33300 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932419Ab0EJWwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:52:40 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:33:24 2010
Message-Id: <20100510223324.690314827@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:32:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [081/117] powerpc: Reduce printk from pseries_mach_cpu_die()
In-Reply-To: <20100510223700.GA18404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>

commit a8e6da093ea8642b1320fb5d64134366f2a8d0ac upstream.

Remove debug printks in pseries_mach_cpu_die().  These are
noisy at runtime.  Traceevents can be added to instrument this
section of code.

The following KERN_INFO printks are removed:

cpu 62 (hwid 62) returned from cede.
Decrementer value = b2802fff Timebase value = 2fa8f95035f4a
cpu 62 (hwid 62) got prodded to go online
cpu 58 (hwid 58) ceding for offline with hint 2

Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/platforms/pseries/hotplug-cpu.c |   11 -----------
 1 file changed, 11 deletions(-)

--- a/arch/powerpc/platforms/pseries/hotplug-cpu.c
+++ b/arch/powerpc/platforms/pseries/hotplug-cpu.c
@@ -122,21 +122,10 @@ static void pseries_mach_cpu_die(void)
 		if (!get_lppaca()->shared_proc)
 			get_lppaca()->donate_dedicated_cpu = 1;
 
-		printk(KERN_INFO
-			"cpu %u (hwid %u) ceding for offline with hint %d\n",
-			cpu, hwcpu, cede_latency_hint);
 		while (get_preferred_offline_state(cpu) == CPU_STATE_INACTIVE) {
 			extended_cede_processor(cede_latency_hint);
-			printk(KERN_INFO "cpu %u (hwid %u) returned from cede.\n",
-				cpu, hwcpu);
-			printk(KERN_INFO
-			"Decrementer value = %x Timebase value = %llx\n",
-			get_dec(), get_tb());
 		}
 
-		printk(KERN_INFO "cpu %u (hwid %u) got prodded to go online\n",
-			cpu, hwcpu);
-
 		if (!get_lppaca()->shared_proc)
 			get_lppaca()->donate_dedicated_cpu = 0;
 		get_lppaca()->idle = 0;


