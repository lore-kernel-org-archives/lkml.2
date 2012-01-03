Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019Ab2ACWje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:39:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40093 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756000Ab2ACWj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:39:28 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:33:21 2012
Message-Id: <20120103223321.347442641@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:32:37 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Matt Turner <mattst88@gmail.com>,
        Nico Macrionitis <acrux@cruxppc.org>,
        Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
        John Stultz <john.stultz@linaro.org>
Subject: [04/75] rtc: m41t80: Workaround broken alarm functionality
In-Reply-To: <20120103223332.GA4112@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Stultz <john.stultz@linaro.org>

commit c3b79770e51ab1fd4201f3b54edf30113b9ce74f upstream.

The m41t80 driver can read and set the alarm, but it doesn't
seem to have a functional alarm irq.

This causes failures when the generic core sees alarm functions,
but then cannot use them properly for things like UIE mode.

Disabling the alarm functions allows proper error reporting,
and possible fallback to emulated modes. Once someone fixes
the alarm irq functionality, this can be restored.

CC: Matt Turner <mattst88@gmail.com>
CC: Nico Macrionitis <acrux@cruxppc.org>
CC: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Reported-by: Matt Turner <mattst88@gmail.com>
Reported-by: Nico Macrionitis <acrux@cruxppc.org>
Tested-by: Nico Macrionitis <acrux@cruxppc.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/rtc/rtc-m41t80.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/rtc/rtc-m41t80.c
+++ b/drivers/rtc/rtc-m41t80.c
@@ -357,10 +357,19 @@ static int m41t80_rtc_read_alarm(struct
 static struct rtc_class_ops m41t80_rtc_ops = {
 	.read_time = m41t80_rtc_read_time,
 	.set_time = m41t80_rtc_set_time,
+	/*
+	 * XXX - m41t80 alarm functionality is reported broken.
+	 * until it is fixed, don't register alarm functions.
+	 *
 	.read_alarm = m41t80_rtc_read_alarm,
 	.set_alarm = m41t80_rtc_set_alarm,
+	*/
 	.proc = m41t80_rtc_proc,
+	/*
+	 * See above comment on broken alarm
+	 *
 	.alarm_irq_enable = m41t80_rtc_alarm_irq_enable,
+	*/
 };
 
 #if defined(CONFIG_RTC_INTF_SYSFS) || defined(CONFIG_RTC_INTF_SYSFS_MODULE)


