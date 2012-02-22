Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914Ab2BVSGv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 13:06:51 -0500
Received: from mga11.intel.com ([192.55.52.93]:4406 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754196Ab2BVSGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 13:06:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="128256767"
From: "Luck, Tony" <tony.luck@intel.com>
Subject: [PATCH/resubmit] x86: Remove some noise from boot log when starting cpus
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@amd64.org>,
        castet.matthieu@free.fr, tglx@linutronix.de, sfr@canb.auug.org.au,
        hpa@linux.intel.com, rjw@sisk.pl, hpa@zytor.com
In-Reply-To: <20120222112954.GA12859@elte.hu>
Date: Wed, 22 Feb 2012 10:06:44 -0800
Message-Id: <4f452eb42507460426@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Printing the "start_ip" for every secondary cpu is very noisy on a large
system - and doesn't add any value. Drop this message.

Console log before:
Booting Node   0, Processors  #1
smpboot cpu 1: start_ip = 96000
 #2
smpboot cpu 2: start_ip = 96000
 #3
smpboot cpu 3: start_ip = 96000
 #4
smpboot cpu 4: start_ip = 96000
       ...
 #31
smpboot cpu 31: start_ip = 96000
Brought up 32 CPUs

Console log after:
Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #7 Ok.
Booting Node   1, Processors  #8 #9 #10 #11 #12 #13 #14 #15 Ok.
Booting Node   0, Processors  #16 #17 #18 #19 #20 #21 #22 #23 Ok.
Booting Node   1, Processors  #24 #25 #26 #27 #28 #29 #30 #31
Brought up 32 CPUs

Acked-by: Borislav Petkov <bp@amd64.org>
Link: https://lkml.org/lkml/2012/2/22/144
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/smpboot.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)


diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 66d250c..6835752 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -740,8 +740,6 @@ do_rest:
 	 * the targeted processor.
 	 */
 
-	printk(KERN_DEBUG "smpboot cpu %d: start_ip = %lx\n", cpu, start_ip);
-
 	atomic_set(&init_deasserted, 0);
 
 	if (get_uv_system_type() != UV_NON_UNIQUE_APIC) {
-- 
1.7.9.rc2.1.g69204

