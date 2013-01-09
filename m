Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934123Ab3AIUla (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:41:30 -0500
Received: from mail.kernel.org ([198.145.19.201]:43964 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934091Ab3AIUlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:41:22 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Tony Prisk <linux@prisktech.co.nz>, Edgar Toernig <froese@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 116/123] drivers/rtc/rtc-vt8500.c: correct handling of CR_24H bitfield
Date: Wed,  9 Jan 2013 12:35:55 -0800
Message-Id: <20130109201513.261961789@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Prisk <linux@prisktech.co.nz>

commit 532db570e5181abc8f4f7bfa6c77c69ec2240198 upstream.

Control register bitfield for 12H/24H mode is handled incorrectly.
Setting CR_24H actually enables 12H mode.  This patch renames the define
and changes the initialization code to correctly set 24H mode.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
Cc: Edgar Toernig <froese@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/rtc/rtc-vt8500.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/rtc/rtc-vt8500.c
+++ b/drivers/rtc/rtc-vt8500.c
@@ -70,7 +70,7 @@
 				| ALARM_SEC_BIT)
 
 #define VT8500_RTC_CR_ENABLE	(1 << 0)	/* Enable RTC */
-#define VT8500_RTC_CR_24H	(1 << 1)	/* 24h time format */
+#define VT8500_RTC_CR_12H	(1 << 1)	/* 12h time format */
 #define VT8500_RTC_CR_SM_ENABLE	(1 << 2)	/* Enable periodic irqs */
 #define VT8500_RTC_CR_SM_SEC	(1 << 3)	/* 0: 1Hz/60, 1: 1Hz */
 #define VT8500_RTC_CR_CALIB	(1 << 4)	/* Enable calibration */
@@ -249,7 +249,7 @@ static int __devinit vt8500_rtc_probe(st
 	}
 
 	/* Enable RTC and set it to 24-hour mode */
-	writel(VT8500_RTC_CR_ENABLE | VT8500_RTC_CR_24H,
+	writel(VT8500_RTC_CR_ENABLE,
 	       vt8500_rtc->regbase + VT8500_RTC_CR);
 
 	vt8500_rtc->rtc = rtc_device_register("vt8500-rtc", &pdev->dev,


