Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057Ab0G1Kz1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 06:55:27 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:19098 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754819Ab0G1Kyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 06:54:36 -0400
X-IronPort-AV: E=Sophos;i="4.55,273,1278302400"; 
   d="scan'208";a="107382893"
From: Ian Campbell <ian.campbell@citrix.com>
To: linux-kernel@vger.kernel.org
Cc: Ian Campbell <ian.campbell@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Subject: [PATCH 2/4] ixp4xx-beeper: Use IRQF_NO_SUSPEND not IRQF_TIMER for non-timer interrupt
Date: Wed, 28 Jul 2010 11:54:25 +0100
Message-Id: <1280314467-5637-2-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1280314445.24292.90.camel@zakaz.uk.xensource.com>
References: <1280314445.24292.90.camel@zakaz.uk.xensource.com>
X-OriginalArrivalTime: 28 Jul 2010 10:54:35.0302 (UTC) FILETIME=[44417C60:01CB2E43]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ixp4xx_spkr_interrupt is not a timer interrupt and therefore should
not use IRQF_TIMER. Use the recently introduced IRQF_NO_SUSPEND
instead since that is the actual desired behaviour.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org
---
 drivers/input/misc/ixp4xx-beeper.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/misc/ixp4xx-beeper.c b/drivers/input/misc/ixp4xx-beeper.c
index 9946d73..5c5ea77 100644
--- a/drivers/input/misc/ixp4xx-beeper.c
+++ b/drivers/input/misc/ixp4xx-beeper.c
@@ -115,7 +115,7 @@ static int __devinit ixp4xx_spkr_probe(struct platform_device *dev)
 	input_dev->event = ixp4xx_spkr_event;
 
 	err = request_irq(IRQ_IXP4XX_TIMER2, &ixp4xx_spkr_interrupt,
-			  IRQF_DISABLED | IRQF_TIMER, "ixp4xx-beeper", (void *) dev->id);
+			  IRQF_DISABLED | IRQF_NO_SUSPEND, "ixp4xx-beeper", (void *) dev->id);
 	if (err)
 		goto err_free_device;
 
-- 
1.5.6.5

