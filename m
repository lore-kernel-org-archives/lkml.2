Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526Ab1DQUGH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 16:06:07 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40430 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793Ab1DQUFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 16:05:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=cmvTwqCiSN2G6t/D75xnNb3FwxTRiTikLJaKSKlAlWO7ek1L1IghI1a6ZN9oIgP2gW
         bRY352bprRT4Je95mVPLTz3uKeVSQ1+gNbgsTbsy1alqd+rpYrLKAj9P9O8Q8/m0WRuc
         UinirEB/SYI6tXfERQWBF5qZ1uGOy0FNjDSSo=
From: Richard Henderson <rth@twiddle.net>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, mattst88@gmail.com,
        linux-alpha@vger.kernel.org
Subject: [PATCH 3/4] alpha: Fix RTC interrupt setup.
Date: Sun, 17 Apr 2011 13:05:25 -0700
Message-Id: <1303070726-32155-4-git-send-email-rth@twiddle.net>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1303070726-32155-1-git-send-email-rth@twiddle.net>
References: <1303070726-32155-1-git-send-email-rth@twiddle.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following 091738a266fc74329ae186f22ff2b3f01319112d we removed
an automatic conversion of no_irq_chip to dummy_irq_chip.  This
change needs to be propagated back into the alpha backend.

Signed-off-by: Richard Henderson <rth@twiddle.net>
---
 arch/alpha/kernel/irq_alpha.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/alpha/kernel/irq_alpha.c b/arch/alpha/kernel/irq_alpha.c
index 1479dc6..51b7fbd 100644
--- a/arch/alpha/kernel/irq_alpha.c
+++ b/arch/alpha/kernel/irq_alpha.c
@@ -228,7 +228,7 @@ struct irqaction timer_irqaction = {
 void __init
 init_rtc_irq(void)
 {
-	irq_set_chip_and_handler_name(RTC_IRQ, &no_irq_chip,
+	irq_set_chip_and_handler_name(RTC_IRQ, &dummy_irq_chip,
 				      handle_simple_irq, "RTC");
 	setup_irq(RTC_IRQ, &timer_irqaction);
 }
-- 
1.7.4.2

