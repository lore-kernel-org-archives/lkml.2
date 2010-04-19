Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab0DSPnq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 11:43:46 -0400
Received: from imr3.ericy.com ([198.24.6.13]:60311 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752855Ab0DSPnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 11:43:45 -0400
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: wim@iguana.be, alan@redhat.com, andy.sharp@onstor.com,
       linux-kernel@vger.kernel.org
CC: linux-mips@vger.kernel.org, ralf@linux-mips.org,
       Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH/RESEND] MIPS: Fix sibyte watchdog initialization
Date: Mon, 19 Apr 2010 08:37:11 -0700
Message-ID: <1271691431-28166-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.0.87.g0901d
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Watchdog configuration register and timer count register were interchanged,
causing wrong values to be written into both registers.
This caused watchdog triggered resets even if the watchdog was reset in time.

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
---
Resend:
    Widening the audience.
    Please let me know if there are any problems with this patch.

 drivers/watchdog/sb_wdog.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/sb_wdog.c b/drivers/watchdog/sb_wdog.c
index 9748eed..1407cfa 100644
--- a/drivers/watchdog/sb_wdog.c
+++ b/drivers/watchdog/sb_wdog.c
@@ -67,8 +67,8 @@ static DEFINE_SPINLOCK(sbwd_lock);
 void sbwdog_set(char __iomem *wdog, unsigned long t)
 {
 	spin_lock(&sbwd_lock);
-	__raw_writeb(0, wdog - 0x10);
-	__raw_writeq(t & 0x7fffffUL, wdog);
+	__raw_writeb(0, wdog);
+	__raw_writeq(t & 0x7fffffUL, wdog - 0x10);
 	spin_unlock(&sbwd_lock);
 }
 
-- 
1.7.0.87.g0901d

