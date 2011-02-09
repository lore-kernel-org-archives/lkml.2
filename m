Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab1BIK2P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 05:28:15 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42567 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203Ab1BIK2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 05:28:14 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        David Vrabel <dvrabel@arcom.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH RESENT#2] [AVR32] don't check platform_get_irq's return value against zero
Date: Wed,  9 Feb 2011 11:28:04 +0100
Message-Id: <1297247284-31650-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1288690250.32331.41.camel@hcegtvedt>
References: <1288690250.32331.41.camel@hcegtvedt>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

platform_get_irq returns -ENXIO on failure, so !int_irq was probably
always true.  Better use (int)int_irq <= 0.  Note that a return value of
zero is still handled as error even though this could mean irq0.

This is a followup to 305b3228f9ff4d59f49e6d34a7034d44ee8ce2f0 that
changed the return value of platform_get_irq from 0 to -ENXIO on error.

Acked-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
Hello,

Hans-Christian Egtvedt asked to push this patch via Linus as there is no avr32
tree.

@Andrew: do you take it?

Best regards
Uwe

 arch/avr32/mach-at32ap/extint.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/avr32/mach-at32ap/extint.c b/arch/avr32/mach-at32ap/extint.c
index e9d1205..dae8682 100644
--- a/arch/avr32/mach-at32ap/extint.c
+++ b/arch/avr32/mach-at32ap/extint.c
@@ -199,7 +199,7 @@ static int __init eic_probe(struct platform_device *pdev)
 
 	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	int_irq = platform_get_irq(pdev, 0);
-	if (!regs || !int_irq) {
+	if (!regs || (int)int_irq <= 0) {
 		dev_dbg(&pdev->dev, "missing regs and/or irq resource\n");
 		return -ENXIO;
 	}
-- 
1.7.2.3

