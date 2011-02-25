Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247Ab1BYOMI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 09:12:08 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:58401 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755746Ab1BYOMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 09:12:07 -0500
X-Spam-ASN: 
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: john stultz <johnstul@us.ibm.com>, Rodolfo Giometti <giometti@linux.it>,
        lkml <linux-kernel@vger.kernel.org>,
        Alexander Gordeev <lasaine@lvk.cs.msu.su>
Subject: [PATCH 2/2] pps: remove unreachable code
Date: Fri, 25 Feb 2011 17:11:56 +0300
Message-Id: <1298643116-3488-3-git-send-email-lasaine@lvk.cs.msu.su>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <20110208153129.0f7fe5d3.akpm@linux-foundation.org>
References: <20110208153129.0f7fe5d3.akpm@linux-foundation.org>
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove code enabled only when CONFIG_PREEMPT_RT is turned on because it
is not used in the vanilla kernel.

Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
---
 drivers/pps/generators/pps_gen_parport.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/pps/generators/pps_gen_parport.c b/drivers/pps/generators/pps_gen_parport.c
index b93af3e..dcd39fb 100644
--- a/drivers/pps/generators/pps_gen_parport.c
+++ b/drivers/pps/generators/pps_gen_parport.c
@@ -216,11 +216,6 @@ static void parport_attach(struct parport *port)
 
 	hrtimer_init(&device.timer, CLOCK_REALTIME, HRTIMER_MODE_ABS);
 	device.timer.function = hrtimer_event;
-#ifdef CONFIG_PREEMPT_RT
-	/* hrtimer interrupt will run in the interrupt context with this */
-	device.timer.irqsafe = 1;
-#endif
-
 	hrtimer_start(&device.timer, next_intr_time(&device), HRTIMER_MODE_ABS);
 
 	return;
-- 
1.7.2.3

