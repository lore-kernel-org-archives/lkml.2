Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205Ab2BFI1W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 03:27:22 -0500
Received: from [62.80.22.186] ([62.80.22.186]:6783 "EHLO
	domex.lippertembedded.de" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752517Ab2BFI1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 03:27:11 -0500
Message-ID: <4F2F8E07.7000202@LiPPERTEmbedded.de>
Date: Mon, 06 Feb 2012 09:23:35 +0100
From: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>
CC: Andres Salomon <dilinger@queued.net>, linux-kernel@vger.kernel.org,
        linux-geode@lists.infradead.org
Subject: [PATCH resend] cs5535-clockevt: allow the MFGPT IRQ to be shared
References: <4EE620A5.7080402@LiPPERTEmbedded.de>	<20111212123131.502be350@queued.net>	<4EE77416.8090907@LiPPERTEmbedded.de>	<4EE8ECF3.6000900@LiPPERTEmbedded.de> <20111214104724.292b02d4@queued.net>
In-Reply-To: <20111214104724.292b02d4@queued.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Feb 2012 08:27:04.0721 (UTC) FILETIME=[1B668010:01CCE4A9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cs5535-clockevt: allow the MFGPT IRQ to be shared

Shared timer IRQs are not a good solution, however the Geode platform has no
APIC, IRQs are a scarce resource and there is no technical reason to forbid it
rightaway.  Increased latencies and overhead due to sharing are still better
than a driver refusing to load.

Signed-off-by: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
Acked-by: Andres Salomon <dilinger@queued.net>
---

Hi again,

could you please take this, for linux-next?

Thanks,
Jens

--- linux-3.2-rc6/drivers/clocksource/cs5535-clockevt.c
+++ allow_shared_mfgpt_irq/drivers/clocksource/cs5535-clockevt.c
@@ -133,7 +133,7 @@ static irqreturn_t mfgpt_tick(int irq, v
 
 static struct irqaction mfgptirq  = {
 	.handler = mfgpt_tick,
-	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_TIMER,
+	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_TIMER | IRQF_SHARED,
 	.name = DRV_NAME,
 };
 
_


