Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092Ab0KHT1i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 14:27:38 -0500
Received: from mail.perches.com ([173.55.12.10]:4637 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798Ab0KHT1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 14:27:37 -0500
Subject: [PATCH] arch/arm/kernel/smp_twd.c: Correct local timer printk
 decimal output
From: Joe Perches <joe@perches.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Nov 2010 11:27:35 -0800
Message-ID: <1289244455.29216.348.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The timer decimal place is shown incorrectly.
The %100 divisor needs to have 1 fewer 0.

Convert to pr_<level> while at it.

Uncompiled/untested.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/arm/kernel/smp_twd.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/arm/kernel/smp_twd.c b/arch/arm/kernel/smp_twd.c
index 35882fb..4f90183 100644
--- a/arch/arm/kernel/smp_twd.c
+++ b/arch/arm/kernel/smp_twd.c
@@ -8,6 +8,9 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/delay.h>
@@ -89,7 +92,7 @@ static void __cpuinit twd_calibrate_rate(void)
 	 * the timer ticks
 	 */
 	if (twd_timer_rate == 0) {
-		printk(KERN_INFO "Calibrating local timer... ");
+		pr_info("Calibrating local timer... ");
 
 		/* Wait for a tick to start */
 		waitjiffies = get_jiffies_64() + 1;
@@ -113,8 +116,9 @@ static void __cpuinit twd_calibrate_rate(void)
 
 		twd_timer_rate = (0xFFFFFFFFU - count) * (HZ / 5);
 
-		printk("%lu.%02luMHz.\n", twd_timer_rate / 1000000,
-			(twd_timer_rate / 100000) % 100);
+		pr_cont("%lu.%02luMHz\n",
+			twd_timer_rate / 1000000,
+			(twd_timer_rate / 10000) % 100);
 	}
 
 	load = twd_timer_rate / HZ;


