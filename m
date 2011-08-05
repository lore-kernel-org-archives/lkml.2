Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346Ab1HEMSa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 08:18:30 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:56679 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008Ab1HEMS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 08:18:29 -0400
Message-ID: <4E3BDF8A.5090103@linux.vnet.ibm.com>
Date: Fri, 05 Aug 2011 17:48:18 +0530
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Len Brown <len.brown@intel.com>, x86@kernel.org
Subject: Re: [linux-pm] [PATCH 5/5] cpuidle: stop depending on pm_idle --build
 break
References: <1312400648-17636-1-git-send-email-lenb@kernel.org> <619b3f9e65307529dd4bbc98efe9d2f3b632646c.1312400543.git.len.brown@intel.com>
In-Reply-To: <619b3f9e65307529dd4bbc98efe9d2f3b632646c.1312400543.git.len.brown@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Following is a patch required to compile on arm
and sh with the latest cpuidle cleanup changes. 

Signed-off-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Signed-off-by: Trinabh Gupta <trinabh@linux.vnet.ibm.com>

Index: linux/arch/arm/kernel/process.c
===================================================================
--- linux.orig/arch/arm/kernel/process.c        2011-08-05 11:02:59.000000000 +0000
+++ linux/arch/arm/kernel/process.c     2011-08-05 11:10:03.000000000 +0000
@@ -197,7 +197,7 @@
                                cpu_relax();
                        } else {
                                stop_critical_timings();
-                               if (cpuidle_call_idle())
+                               if (cpuidle_idle_call())
                                        pm_idle();
                                start_critical_timings();
                                /*
Index: linux/arch/sh/kernel/idle.c
===================================================================
--- linux.orig/arch/sh/kernel/idle.c    2011-08-05 11:02:59.000000000 +0000
+++ linux/arch/sh/kernel/idle.c 2011-08-05 11:13:23.000000000 +0000
@@ -101,7 +101,7 @@
                        local_irq_disable();
                        /* Don't trace irqs off for idle */
                        stop_critical_timings();
-                       if (cpuidle_call_idle())
+                       if (cpuidle_idle_call())
                                pm_idle();
                        /*
                         * Sanity check to ensure that pm_idle() returns
