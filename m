Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab1BBSER (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 13:04:17 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:41948 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547Ab1BBSEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 13:04:16 -0500
From: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
To: mroberto@cpti.cetuc.puc-rio.br, a.zummo@towertech.it,
        john.stultz@linaro.org
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: [PATCH] RTC: Prevents a division by zero in kernel code.
Date: Wed,  2 Feb 2011 16:04:02 -0200
Message-Id: <1296669842-32611-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch prevents a user space program from calling the RTC_IRQP_SET
ioctl with a negative value of frequency. Also, if this call is make
with a zero value of frequency, there would be a division by zero in the
kernel code.

Signed-off-by: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
---
 drivers/rtc/interface.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index 925006d..a0c0196 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -464,6 +464,9 @@ int rtc_irq_set_freq(struct rtc_device *rtc, struct rtc_task *task, int freq)
 	int err = 0;
 	unsigned long flags;
 
+	if (freq <= 0)
+		return -EINVAL;
+
 	spin_lock_irqsave(&rtc->irq_task_lock, flags);
 	if (rtc->irq_task != NULL && task == NULL)
 		err = -EBUSY;
-- 
1.7.3.4

