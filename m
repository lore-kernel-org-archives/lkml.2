Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab2IXGSw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 02:18:52 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7405 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754965Ab2IXGSa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 02:18:30 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 23 Sep 2012 23:18:29 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>
Date: Mon, 24 Sep 2012 11:48:24 +0530
Subject: RE: [PATCH] rtc: tps65910: Use platform_get_irq to get RTC irq
 details
Thread-Topic: [PATCH] rtc: tps65910: Use platform_get_irq to get RTC irq
 details
Thread-Index: Ac2YEO3kzL0cZq9zSmO7qJcjrq0MRwCB9RMA
Message-ID: <D958900912E20642BCBC71664EFECE3E6DDF60158F@BGMAIL02.nvidia.com>
References: <1348225223-32156-1-git-send-email-vbyravarasu@nvidia.com>
 <505C8CE9.6040201@wwwdotorg.org>
In-Reply-To: <505C8CE9.6040201@wwwdotorg.org>
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

> -----Original Message-----
> From: Stephen Warren [mailto:swarren@wwwdotorg.org]
> Sent: Friday, September 21, 2012 9:21 PM
> To: Venu Byravarasu
> Cc: akpm@linux-foundation.org; a.zummo@towertech.it; linux-
> kernel@vger.kernel.org; rtc-linux@googlegroups.com
> Subject: Re: [PATCH] rtc: tps65910: Use platform_get_irq to get RTC irq
> details
> 
> On 09/21/2012 05:00 AM, Venu Byravarasu wrote:
> > As RTC driver needs only irq number from platform data,
> > using platform_get_irq(), instead of generic dev_get_platdata().
> 
> I assume this patch depends on "mfd: tps65910: Add alarm interrupt of
> TPS65910 RTC to mfd device list" which you posted just before? If so,
> the two patches should go through the same tree to avoid "git bisect"
> issues.
> 
> Also, I thought you needed to fix the MFD driver to call
> mfd_add_devices() only after all the IRQ stuff had been set up -
> otherwise, when the RTC driver calls devm_request_threaded_irq(), the
> parent IRQ domain that the IRQ points at won't exist, and the call will
> fail.

No, I do not agree completely here.
Current patch just changes the way to get irq info in the RTC driver.
If proper irq number is passed from MFD, then it proceeds further and deals with it.
In case of missing valid irq info, this returns error as in earlier case.

I agree with you that this patch alone cannot make RTC completely functional,
till we get mfd patch as well.

However should lack of mfd changes really block this patch, as these two are
independent  drivers.
 
> 
> Also, the MFD patch you sent to create add the IRQ resource into the RTC
> device's resource list sets the IRQ number to TPS65910_IRQ_RTC_ALARM,
> which is the offset within the IRQ domain, not the absolute Linux IRQ
> number. Where does the base of the IRQ domain get added on such that
> this is an actual IRQ numbmer not an offset?
> 
> > -	dev_dbg(&pdev->dev, "Enabling rtc-tps65910.\n");
> > +	dev_dbg(&pdev->dev, "Enabling tps65910 rtc.\n");
> 
> Unrelated change.

Fine, I can move all of the unrelated changes mentioned here to different patch. 

> 
> > -	irq = pmic_plat_data->irq_base;
> > +	irq  = platform_get_irq(pdev, 0);
> 
> There are two spaces there before the =.
> 
> > -		"rtc-tps65910", &pdev->dev);
> > +		"tps65910-rtc", &pdev->dev);
> 
> Unrelated change.
> 
> > -		.name	= "rtc-tps65910",
> > +		.name	= "tps65910-rtc",
> 
> Unrelated change.
