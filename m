Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170Ab1DSUXm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:23:42 -0400
Received: from kroah.org ([198.145.64.141]:35632 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754817Ab1DSUR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:17:29 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:10:48 2011
Message-Id: <20110419201048.063316928@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:08:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Mike Frysinger <vapier@gentoo.org>,
        John Stultz <john.stultz@linaro.org>
Subject: [46/70] RTC: add missing "return 0" in new alarm func for rtc-bfin.c
In-Reply-To: <20110419201501.GA8865@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mike Frysinger <vapier@gentoo.org>

commit 8c122b96866580c99e44f3f07ac93a993d964ec3 upstream.

The new bfin_rtc_alarm_irq_enable function forgot to add a "return 0" to
the end leading to the build warning:
	drivers/rtc/rtc-bfin.c: In function 'bfin_rtc_alarm_irq_enable':
	drivers/rtc/rtc-bfin.c:253: warning: control reaches end of non-void function

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/rtc/rtc-bfin.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/rtc/rtc-bfin.c
+++ b/drivers/rtc/rtc-bfin.c
@@ -276,6 +276,8 @@ static int bfin_rtc_alarm_irq_enable(str
 		bfin_rtc_int_set_alarm(rtc);
 	else
 		bfin_rtc_int_clear(~(RTC_ISTAT_ALARM | RTC_ISTAT_ALARM_DAY));
+
+	return 0;
 }
 
 static int bfin_rtc_read_time(struct device *dev, struct rtc_time *tm)


