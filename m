Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751130Ab1GVXT2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 19:19:28 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:34784 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab1GVXT1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 19:19:27 -0400
Subject: Re: [PATCH] rtc-tegra: properly initialize spinlock
Mime-Version: 1.0 (Apple Message framework v1244.3)
Content-Type: text/plain; charset=us-ascii
From: Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
In-Reply-To: <20110722151338.9b1e9594.akpm@linux-foundation.org>
Date: Fri, 22 Jul 2011 16:19:19 -0700
Cc: =?iso-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Andrew Chew <achew@nvidia.com>, linux-rt-users@vger.kernel.org,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        jkastner@redhat.com
Content-Transfer-Encoding: 8BIT
Message-Id: <58E25CAF-EAC4-4613-81B2-D713F5DC8CEF@gmail.com>
References: <1311323756-18013-1-git-send-email-u.kleine-koenig@pengutronix.de> <20110722151338.9b1e9594.akpm@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.1244.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 22, 2011, at 3:13 PM, Andrew Morton wrote:

> On Fri, 22 Jul 2011 10:35:56 +0200
> Uwe Kleine-K__nig <u.kleine-koenig@pengutronix.de> wrote:
> 
>> Using __SPIN_LOCK_UNLOCKED for a dynamically allocated lock is wrong and
>> breaks with PREEMPT_RT_FULL.
> 
> Please define "breaks".  Lockdep warnings?  Deadlocks?

Narrr, I think its a compile-time problem with the static initializer.

Sven

> 
>> diff --git a/drivers/rtc/rtc-tegra.c b/drivers/rtc/rtc-tegra.c
>> index 2fc31aa..75259fe 100644
>> --- a/drivers/rtc/rtc-tegra.c
>> +++ b/drivers/rtc/rtc-tegra.c
>> @@ -343,7 +343,7 @@ static int __devinit tegra_rtc_probe(struct platform_device *pdev)
>> 
>> 	/* set context info. */
>> 	info->pdev = pdev;
>> -	info->tegra_rtc_lock = __SPIN_LOCK_UNLOCKED(info->tegra_rtc_lock);
>> +	spin_lock_init(&info->tegra_rtc_lock);
>> 
>> 	platform_set_drvdata(pdev, info);
>> 
>> -- 
>> 1.7.5.4
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

