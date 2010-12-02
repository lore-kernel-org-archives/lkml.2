Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757769Ab0LBOKk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 09:10:40 -0500
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:46577 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757651Ab0LBOKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 09:10:39 -0500
From: Mattias Wallin <mattias.wallin@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mattias Wallin <mattias.wallin@stericsson.com>
Subject: [PATCH] MFD: ab8500-core wake up from suspend
Date: Thu, 2 Dec 2010 15:10:27 +0100
Message-ID: <1291299027-7306-1-git-send-email-mattias.wallin@stericsson.com>
X-Mailer: git-send-email 1.7.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the system wake up from suspend when an
ab8500 interrupt occur. This can for example be USB cable
insert or an RTC alarm.

Signed-off-by: Mattias Wallin <mattias.wallin@stericsson.com>
---
 drivers/mfd/ab8500-core.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index 2bd4437..e464e94 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -519,7 +519,8 @@ int __devinit ab8500_init(struct ab8500 *ab8500)
 			return ret;
 
 		ret = request_threaded_irq(ab8500->irq, NULL, ab8500_irq,
-					   IRQF_ONESHOT, "ab8500", ab8500);
+					   IRQF_ONESHOT | IRQF_NO_SUSPEND,
+					   "ab8500", ab8500);
 		if (ret)
 			goto out_removeirq;
 	}
-- 
1.7.2.2

