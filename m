Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab2JPAbg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 20:31:36 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:40676 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664Ab2JPAbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 20:31:35 -0400
Date: Mon, 15 Oct 2012 17:31:28 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: cernekee@gmail.com, torbenh@gmx.de, torvalds@linux-foundation.org,
        tglx@linutronix.de, srivatsa.bhat@linux.vnet.ibm.com
Subject: [PATCH] Fix scheduling-while-atomic problem in console_cpu_notify()
Message-ID: <20121016003128.GA5879@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12101600-5930-0000-0000-00000D1A6E0B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The console_cpu_notify( function runs with interrupts disabled in
the CPU_DEAD case.  It therefore cannot block, for example, as will
happen when it calls console_lock().  Therefore, remove the CPU_DEAD
leg of the switch statement to avoid this problem.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>

diff --git a/kernel/printk.c b/kernel/printk.c
index 66a2ea3..8e23a14 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1889,7 +1889,6 @@ static int __cpuinit console_cpu_notify(struct notifier_block *self,
 {
 	switch (action) {
 	case CPU_ONLINE:
-	case CPU_DEAD:
 	case CPU_DYING:
 	case CPU_DOWN_FAILED:
 	case CPU_UP_CANCELED:

