Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab1BNKdj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 05:33:39 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51165 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220Ab1BNKdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 05:33:36 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: John Stultz <john.stultz@linaro.org>
Cc: David Daney <ddaney@caviumnetworks.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Andreas Schwab <schwab@linux-m68k.org>
Subject: [PATCH] rtc: release mutex in error path of rtc_alarm_irq_enable
Date: Mon, 14 Feb 2011 11:33:17 +0100
Message-Id: <1297679597-8649-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1295565973-14358-1-git-send-email-john.stultz@linaro.org>
References: <1295565973-14358-1-git-send-email-john.stultz@linaro.org>
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

This was introduced in

	aa0be0f (RTC: Propagate error handling via rtc_timer_enqueue properly)

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/rtc/interface.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index 873fd36..cb2f072 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -209,9 +209,8 @@ int rtc_alarm_irq_enable(struct rtc_device *rtc, unsigned int enabled)
 	}
 
 	if (err)
-		return err;
-
-	if (!rtc->ops)
+		/* nothing */;
+	else if (!rtc->ops)
 		err = -ENODEV;
 	else if (!rtc->ops->alarm_irq_enable)
 		err = -EINVAL;
-- 
1.7.2.3

