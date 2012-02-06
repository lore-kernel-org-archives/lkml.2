Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981Ab2BFWid (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 17:38:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48207 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755015Ab2BFWic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 17:38:32 -0500
Date: Mon, 6 Feb 2012 14:38:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>, <linux-kernel@vger.kernel.org>,
        David Dajun Chen <dchen@diasemi.com>, <sameo@linux.intel.com>
Subject: Re: [PATCH 06/07] RTC: RTC driver for DA9052/53 PMIC v1
Message-Id: <20120206143820.9808fba7.akpm@linux-foundation.org>
In-Reply-To: <1328532545.30549.83.camel@dhruva>
References: <1328532545.30549.83.camel@dhruva>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Feb 2012 18:19:05 +0530
Ashish Jangam <ashish.jangam@kpitcummins.com> wrote:

> RTC Driver for Dialog Semiconductor DA9052/53 PMICs.
> 
> This patch is functionally tested on Samsung SMDKV6410.
> 
> ...
>
>  drivers/rtc/Kconfig      |    7 +
>  drivers/rtc/Makefile     |    1 +
>  drivers/rtc/rtc-da9052.c |  293 ++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 301 insertions(+), 0 deletions(-)

I assume that this patch is mergeable without any of the other six
patches in this series.  It compiles OK...

>
> ...
>
> +static int da9052_read_alarm(struct da9052 *da9052, struct rtc_time *rtc_tm)
> +{
> +	int ret;
> +	uint8_t v[5] = {0, 0, 0, 0, 0};

These initalised local arrays are expensive.  The below patch reduces
the module's text size by over 100 bytes.

The arrays whcih are passed to da9052_group_write() surely didn't need
initalisation, and I trust that's also the case with the arrays which
are passed to da9052_group_read()?

>
> ...
>

From: Andrew Morton <akpm@linux-foundation.org>
Subject: rtc-rtc-driver-for-da9052-53-pmic-v1-fix

- clean up file header layout
- remove unneeded initialisation of local arrays

Cc: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: David Dajun Chen <dchen@diasemi.com>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
Cc: David Dajun Chen <dchen@diasemi.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-da9052.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/rtc/rtc-da9052.c~rtc-rtc-driver-for-da9052-53-pmic-v1-fix drivers/rtc/rtc-da9052.c
--- a/drivers/rtc/rtc-da9052.c~rtc-rtc-driver-for-da9052-53-pmic-v1-fix
+++ a/drivers/rtc/rtc-da9052.c
@@ -1,9 +1,9 @@
 /*
  * Real time clock driver for DA9052
  *
- *Copyright(c) 2012 Dialog Semiconductor Ltd.
+ * Copyright(c) 2012 Dialog Semiconductor Ltd.
  *
- *Author: Dajun Dajun Chen <dajun.chen@diasemi.com>
+ * Author: Dajun Dajun Chen <dajun.chen@diasemi.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -69,7 +69,7 @@ static irqreturn_t da9052_rtc_irq(int ir
 static int da9052_read_alarm(struct da9052 *da9052, struct rtc_time *rtc_tm)
 {
 	int ret;
-	uint8_t v[5] = {0, 0, 0, 0, 0};
+	uint8_t v[5];
 
 	ret = da9052_group_read(da9052, DA9052_ALARM_MI_REG, 5, v);
 	if (ret != 0) {
@@ -92,7 +92,7 @@ static int da9052_read_alarm(struct da90
 static int da9052_set_alarm(struct da9052 *da9052, struct rtc_time *rtc_tm)
 {
 	int ret;
-	uint8_t v[3] = {0, 0, 0};
+	uint8_t v[3];
 
 	rtc_tm->tm_year -= 100;
 	rtc_tm->tm_mon += 1;
@@ -136,7 +136,7 @@ static int da9052_rtc_get_alarm_status(s
 static int da9052_rtc_read_time(struct device *dev, struct rtc_time *rtc_tm)
 {
 	struct da9052_rtc *rtc = dev_get_drvdata(dev);
-	uint8_t v[6] = {0, 0, 0, 0, 0, 0};
+	uint8_t v[6];
 	int ret;
 
 	ret = da9052_group_read(rtc->da9052, DA9052_COUNT_S_REG, 6, v);
@@ -164,7 +164,7 @@ static int da9052_rtc_read_time(struct d
 static int da9052_rtc_set_time(struct device *dev, struct rtc_time *tm)
 {
 	struct da9052_rtc *rtc;
-	uint8_t v[6] = {0, 0, 0, 0, 0, 0};
+	uint8_t v[6];
 
 	rtc = dev_get_drvdata(dev);
 
_

