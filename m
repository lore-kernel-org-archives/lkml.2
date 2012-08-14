Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab2HNXwP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 19:52:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54645 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283Ab2HNXwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 19:52:13 -0400
Date: Tue, 14 Aug 2012 16:52:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Venu Byravarasu <vbyravarasu@nvidia.com>
Cc: <a.zummo@towertech.it>, <sameo@linux.intel.com>,
        <broonie@opensource.wolfsonmicro.com>, <ldewangan@nvidia.com>,
        <kyle.manna@fuel7.com>, <rtc-linux@googlegroups.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rtc: tps65910: Add RTC driver for TPS65910 PMIC RTC
Message-Id: <20120814165211.daf24c81.akpm@linux-foundation.org>
In-Reply-To: <1343284519-30505-1-git-send-email-vbyravarasu@nvidia.com>
References: <1343284519-30505-1-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jul 2012 12:05:19 +0530
Venu Byravarasu <vbyravarasu@nvidia.com> wrote:

> TPS65910 PMIC is a MFD with RTC as one of the device.
> Adding RTC driver for supporting RTC device present
> inside TPS65910 PMIC.
> 
> Only support for RTC alarm is implemented as part of this patch.

It needs a build fix:

drivers/rtc/rtc-tps65910.c: In function 'tps65910_rtc_suspend':
drivers/rtc/rtc-tps65910.c:313: error: request for member 'irqstat' in something not a structure or union
drivers/rtc/rtc-tps65910.c: In function 'tps65910_rtc_resume':
drivers/rtc/rtc-tps65910.c:327: error: request for member 'irqstat' in something not a structure or union

--- a/drivers/rtc/rtc-tps65910.c~rtc-tps65910-add-rtc-driver-for-tps65910-pmic-rtc-fix
+++ a/drivers/rtc/rtc-tps65910.c
@@ -310,7 +310,7 @@ static int tps65910_rtc_suspend(struct p
 
 	/* Store current list of enabled interrupts*/
 	ret = regmap_read(tps->regmap, TPS65910_RTC_INTERRUPTS,
-		&tps->rtc.irqstat);
+		&tps->rtc->irqstat);
 	if (ret < 0)
 		return ret;
 
@@ -324,7 +324,7 @@ static int tps65910_rtc_resume(struct pl
 
 	/* Restore list of enabled interrupts before suspend */
 	return regmap_write(tps->regmap, TPS65910_RTC_INTERRUPTS,
-		tps->rtc.irqstat);
+		tps->rtc->irqstat);
 }
 
 static const struct dev_pm_ops tps65910_rtc_pm_ops = {


but it still has problems:

drivers/rtc/rtc-tps65910.c:331: warning: initialization from incompatible pointer type
drivers/rtc/rtc-tps65910.c:332: warning: initialization from incompatible pointer type

fix and resend, please?
