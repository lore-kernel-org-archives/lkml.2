Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422674Ab2KICWN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 21:22:13 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:55251 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756999Ab2KICWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 21:22:10 -0500
Message-ID: <509C68CE.5030509@gmail.com>
Date: Fri, 09 Nov 2012 10:22:06 +0800
From: Shan Wei <shanwei88@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: johnstul@us.ibm.com, tglx@linutronix.de,
        Kernel-Maillist <linux-kernel@vger.kernel.org>,
        cl@linux-foundation.org, Shan Wei <shanwei88@gmail.com>
Subject: [PATCH v3 8/9] clocksource: use this_cpu_ptr per-cpu helper
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shan Wei <davidshan@tencent.com>


Signed-off-by: Shan Wei <davidshan@tencent.com>
Reviewed-by: Christoph Lameter <cl@linux.com>
---
no changes vs v2.
---
 drivers/clocksource/arm_generic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/clocksource/arm_generic.c b/drivers/clocksource/arm_generic.c
index c4d9f95..cb445ab 100644
--- a/drivers/clocksource/arm_generic.c
+++ b/drivers/clocksource/arm_generic.c
@@ -224,7 +224,7 @@ int __init arm_generic_timer_init(void)
 	lpj_fine = arch_timer_rate / HZ;
 
 	/* Immediately configure the timer on the boot CPU */
-	arch_timer_setup(per_cpu_ptr(&arch_timer_evt, smp_processor_id()));
+	arch_timer_setup(this_cpu_ptr(&arch_timer_evt));
 
 	register_cpu_notifier(&arch_timer_cpu_nb);
 
-- 
1.7.1


