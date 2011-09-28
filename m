Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444Ab1I1XTi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 19:19:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54077 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755841Ab1I1Wm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:42:28 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:31 2011
Message-Id: <20110928220131.571327743@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:00:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Willy Tarreau <w@1wt.eu>, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Subject: [060/244] rtc: Fix RTC PIE frequency limit
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: John Stultz <john.stultz@linaro.org>

commit 938f97bcf1bdd1b681d5d14d1d7117a2e22d4434 upstream.

Thomas earlier submitted a fix to limit the RTC PIE freq, but
picked 5000Hz out of the air. Willy noticed that we should
instead use the 8192Hz max from the rtc man documentation.

Cc: Willy Tarreau <w@1wt.eu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/rtc/interface.c |    2 +-
 include/linux/rtc.h     |    3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -708,7 +708,7 @@ int rtc_irq_set_freq(struct rtc_device *
 	int err = 0;
 	unsigned long flags;
 
-	if (freq <= 0 || freq > 5000)
+	if (freq <= 0 || freq > RTC_MAX_FREQ)
 		return -EINVAL;
 retry:
 	spin_lock_irqsave(&rtc->irq_task_lock, flags);
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -97,6 +97,9 @@ struct rtc_pll_info {
 #define RTC_AF 0x20	/* Alarm interrupt */
 #define RTC_UF 0x10	/* Update interrupt for 1Hz RTC */
 
+
+#define RTC_MAX_FREQ	8192
+
 #ifdef __KERNEL__
 
 #include <linux/types.h>


