Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065Ab1BXAJY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 19:09:24 -0500
Received: from mga02.intel.com ([134.134.136.20]:32483 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753017Ab1BXAJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 19:09:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,214,1297065600"; 
   d="scan'208";a="605916639"
From: jacob.jun.pan@linux.intel.com
To: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH] x86/mrst: fix apb timer rating when lapic timer is used
Date: Wed, 23 Feb 2011 16:07:26 -0800
Message-Id: <1298506046-439-1-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jacob Pan <jacob.jun.pan@linux.intel.com>

Need to adjust the clockevent device rating for the structure that will
be registered with clockevent system instead of the temporary structure.

Without this fix, APB timer rating will be higher than LAPIC timer such
that it can not be released later to be used as the broadcast timer.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 arch/x86/kernel/apb_timer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apb_timer.c b/arch/x86/kernel/apb_timer.c
index 671d5aa..1293c70 100644
--- a/arch/x86/kernel/apb_timer.c
+++ b/arch/x86/kernel/apb_timer.c
@@ -284,7 +284,7 @@ static int __init apbt_clockevent_register(void)
 	memcpy(&adev->evt, &apbt_clockevent, sizeof(struct clock_event_device));
 
 	if (mrst_timer_options == MRST_TIMER_LAPIC_APBT) {
-		apbt_clockevent.rating = APBT_CLOCKEVENT_RATING - 100;
+		adev->evt.rating = APBT_CLOCKEVENT_RATING - 100;
 		global_clock_event = &adev->evt;
 		printk(KERN_DEBUG "%s clockevent registered as global\n",
 		       global_clock_event->name);
-- 
1.7.0.4

