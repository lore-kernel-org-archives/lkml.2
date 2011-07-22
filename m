Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab1GVJNf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 05:13:35 -0400
Received: from www.linutronix.de ([62.245.132.108]:46115 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073Ab1GVJMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 05:12:53 -0400
Message-Id: <20110722091045.537404938@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 22 Jul 2011 09:12:51 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        Ben Greear <greearb@candelatech.com>, stable@kernel.org
Subject: [patch 3/3] rtc: Limit frequency
References: <20110722091011.717194327@linutronix.de>
Content-Disposition: inline; filename=rtc-limit-frequency.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The RTC hrtimer is self rearming. We really need to limit the
frequency to something sensible.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@kernel.org
---
 drivers/rtc/interface.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/rtc/interface.c
===================================================================
--- linux-2.6.orig/drivers/rtc/interface.c
+++ linux-2.6/drivers/rtc/interface.c
@@ -708,7 +708,7 @@ int rtc_irq_set_freq(struct rtc_device *
 	int err = 0;
 	unsigned long flags;
 
-	if (freq <= 0)
+	if (freq <= 0 || freq > 5000)
 		return -EINVAL;
 retry:
 	spin_lock_irqsave(&rtc->irq_task_lock, flags);


