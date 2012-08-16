Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab2HPFsn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 01:48:43 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18528 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325Ab2HPFsl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 01:48:41 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 15 Aug 2012 22:43:06 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "kyle.manna@fuel7.com" <kyle.manna@fuel7.com>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 16 Aug 2012 11:18:34 +0530
Subject: RE: [PATCH] rtc: tps65910: Add RTC driver for TPS65910 PMIC RTC
Thread-Topic: [PATCH] rtc: tps65910: Add RTC driver for TPS65910 PMIC RTC
Thread-Index: Ac16d9XuenBB1iUfRmOwI8PofhMlzQA+m6cQ
Message-ID: <D958900912E20642BCBC71664EFECE3E6DDD2552AF@BGMAIL02.nvidia.com>
References: <1343284519-30505-1-git-send-email-vbyravarasu@nvidia.com>
 <20120814165211.daf24c81.akpm@linux-foundation.org>
In-Reply-To: <20120814165211.daf24c81.akpm@linux-foundation.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Already an updated patch v3 (http://lkml.org/lkml/2012/8/8/221 ) was pushed to fix these issues.
Plz review and merged that.

Thanks,
Venu


> -----Original Message-----
> From: Andrew Morton [mailto:akpm@linux-foundation.org]
> Sent: Wednesday, August 15, 2012 5:22 AM
> To: Venu Byravarasu
> Cc: a.zummo@towertech.it; sameo@linux.intel.com;
> broonie@opensource.wolfsonmicro.com; Laxman Dewangan;
> kyle.manna@fuel7.com; rtc-linux@googlegroups.com; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH] rtc: tps65910: Add RTC driver for TPS65910 PMIC RTC
> 
> On Thu, 26 Jul 2012 12:05:19 +0530
> Venu Byravarasu <vbyravarasu@nvidia.com> wrote:
> 
> > TPS65910 PMIC is a MFD with RTC as one of the device.
> > Adding RTC driver for supporting RTC device present
> > inside TPS65910 PMIC.
> >
> > Only support for RTC alarm is implemented as part of this patch.
> 
> It needs a build fix:
> 
> drivers/rtc/rtc-tps65910.c: In function 'tps65910_rtc_suspend':
> drivers/rtc/rtc-tps65910.c:313: error: request for member 'irqstat' in
> something not a structure or union
> drivers/rtc/rtc-tps65910.c: In function 'tps65910_rtc_resume':
> drivers/rtc/rtc-tps65910.c:327: error: request for member 'irqstat' in
> something not a structure or union
> 
> --- a/drivers/rtc/rtc-tps65910.c~rtc-tps65910-add-rtc-driver-for-tps65910-
> pmic-rtc-fix
> +++ a/drivers/rtc/rtc-tps65910.c
> @@ -310,7 +310,7 @@ static int tps65910_rtc_suspend(struct p
> 
>  	/* Store current list of enabled interrupts*/
>  	ret = regmap_read(tps->regmap, TPS65910_RTC_INTERRUPTS,
> -		&tps->rtc.irqstat);
> +		&tps->rtc->irqstat);
>  	if (ret < 0)
>  		return ret;
> 
> @@ -324,7 +324,7 @@ static int tps65910_rtc_resume(struct pl
> 
>  	/* Restore list of enabled interrupts before suspend */
>  	return regmap_write(tps->regmap, TPS65910_RTC_INTERRUPTS,
> -		tps->rtc.irqstat);
> +		tps->rtc->irqstat);
>  }
> 
>  static const struct dev_pm_ops tps65910_rtc_pm_ops = {
> 
> 
> but it still has problems:
> 
> drivers/rtc/rtc-tps65910.c:331: warning: initialization from incompatible
> pointer type
> drivers/rtc/rtc-tps65910.c:332: warning: initialization from incompatible
> pointer type
> 
> fix and resend, please?
