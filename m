Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538Ab2IUQNe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 12:13:34 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:34235 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756226Ab2IUQNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 12:13:30 -0400
Date: Fri, 21 Sep 2012 16:13:29 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dipankar Sarma <dipankar@in.ibm.com>
cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        "Bruce, Becky" <bbruce@ti.com>, "Hilman, Kevin" <khilman@ti.com>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "Hunter, Jon" <jon-hunter@ti.com>, snijsure@grid-net.com
Subject: [PATCH] Documentation: RCU: update the stall warning message "timer=-1"
 to match reality
Message-ID: <alpine.DEB.2.00.1209211610280.30239@utopia.booyaka.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The CONFIG_RCU_FAST_NO_HZ stall warning messages can never emit
"timer=-1".  This is because the printf() format specifier to generate
that number is '%lu'.  So, update the documentation to use the
unsigned long equivalent instead, "timer=4294967295".  This is what
actually shows up in traces.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Dipankar Sarma <dipankar@in.ibm.com>
---
 Documentation/RCU/stallwarn.txt |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/RCU/stallwarn.txt b/Documentation/RCU/stallwarn.txt
index 523364e..fe3379e 100644
--- a/Documentation/RCU/stallwarn.txt
+++ b/Documentation/RCU/stallwarn.txt
@@ -99,7 +99,7 @@ In kernels with CONFIG_RCU_FAST_NO_HZ, even more information is
 printed:
 
 	INFO: rcu_preempt detected stall on CPU
-	0: (64628 ticks this GP) idle=dd5/3fffffffffffffff/0 drain=0 . timer=-1
+	0: (64628 ticks this GP) idle=dd5/3fffffffffffffff/0 drain=0 . timer=4294967295
 	   (t=65000 jiffies)
 
 The "(64628 ticks this GP)" indicates that this CPU has taken more
@@ -119,10 +119,10 @@ number (as shown above) otherwise.
 For CONFIG_RCU_FAST_NO_HZ kernels, the "drain=0" indicates that the
 CPU is not in the process of trying to force itself into dyntick-idle
 state, the "." indicates that the CPU has not given up forcing RCU
-into dyntick-idle mode (it would be "H" otherwise), and the "timer=-1"
-indicates that the CPU has not recented forced RCU into dyntick-idle
-mode (it would otherwise indicate the number of microseconds remaining
-in this forced state).
+into dyntick-idle mode (it would be "H" otherwise), and the
+"timer=4294967295" (the magic number (2^32)-1) indicates that the CPU
+has not recently forced RCU into dyntick-idle mode (it would otherwise
+indicate the number of microseconds remaining in this forced state).
 
 
 Multiple Warnings From One Stall
-- 
1.7.10.4

