Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274Ab0LBQI4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 11:08:56 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48496 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756829Ab0LBQIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 11:08:55 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] clocksource: really use a margin of 12.5% to limit deferment
Date: Thu,  2 Dec 2010 17:08:46 +0100
Message-Id: <1291306126-16990-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
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

< ukleinek> tglx: the last comment in clocksource_max_deferment is wrong I
            think.  Unless I'm mistaken the margin is only 2^-5, not 2^-3
< ukleinek> i.e. 3.125%, not 12.5%
...
< tglx> crap, the 3.125% is a bit narrow

So fix the code to really do what the comment specifies.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 kernel/time/clocksource.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index c18d7ef..0ddf372 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -528,7 +528,7 @@ static u64 clocksource_max_deferment(struct clocksource *cs)
 	 * note a margin of 12.5% is used because this can be computed with
 	 * a shift, versus say 10% which would require division.
 	 */
-	return max_nsecs - (max_nsecs >> 5);
+	return max_nsecs - (max_nsecs >> 3);
 }
 
 #ifndef CONFIG_ARCH_USES_GETTIMEOFFSET
-- 
1.7.2.3

