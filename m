Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303Ab1JKItj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 04:49:39 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:48922 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751880Ab1JKIth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 04:49:37 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Virupax Sadashivpetimath 
	<virupax.sadashivpetimath@stericsson.com>,
        Philippe Langlais <philippe.langlais@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 1/4] mfd/ab8500-core: add interrupt disable hook
Date: Tue, 11 Oct 2011 10:49:17 +0200
Message-ID: <1318322957-11435-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Virupax Sadashivpetimath <virupax.sadashivpetimath@stericsson.com>

Add the missing interrupt disable hook in the irq_chip
callbacks for ab8500.

Signed-off-by: Virupax Sadashivpetimath <virupax.sadashivpetimath@stericsson.com>
Reviewed-by: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Signed-off-by: Philippe Langlais <philippe.langlais@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/ab8500-core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index 387705e..eb238ee 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -293,6 +293,7 @@ static struct irq_chip ab8500_irq_chip = {
 	.irq_bus_lock		= ab8500_irq_lock,
 	.irq_bus_sync_unlock	= ab8500_irq_sync_unlock,
 	.irq_mask		= ab8500_irq_mask,
+	.irq_disable		= ab8500_irq_mask,
 	.irq_unmask		= ab8500_irq_unmask,
 };
 
-- 
1.7.3.2

