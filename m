Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab1HWU03 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 16:26:29 -0400
Received: from mga03.intel.com ([143.182.124.21]:43135 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130Ab1HWU01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 16:26:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,270,1312182000"; 
   d="scan'208";a="41644043"
From: "Luck, Tony" <tony.luck@intel.com>
To: hpa@zytor.com
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, castet.matthieu@free.fr,
        tglx@linutronix.de, sfr@canb.auug.org.au, hpa@linux.intel.com,
        rjw@sisk.pl
In-Reply-To: <4E53FBBB.7030008@zytor.com>
Subject: [PATCH] x86: remove some noise from boot log when starting cpus
Date: Tue, 23 Aug 2011 13:26:26 -0700
Message-Id: <4e540cf271396b4c4@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Printing the "start_ip" for every secondary cpu is very noisy on a large
system - and doesn't add any value. Drop this message.

Signed-off-by: Tony Luck <tony.luck@intel.com>

---

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 9f548cb..fe5fb7a 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -734,8 +734,6 @@ do_rest:
 	 * the targeted processor.
 	 */
 
-	printk(KERN_DEBUG "smpboot cpu %d: start_ip = %lx\n", cpu, start_ip);
-
 	atomic_set(&init_deasserted, 0);
 
 	if (get_uv_system_type() != UV_NON_UNIQUE_APIC) {
