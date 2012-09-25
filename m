Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab2IYEnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 00:43:50 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:12179 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab2IYEnt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 00:43:49 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 24 Sep 2012 21:34:33 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>
Date: Tue, 25 Sep 2012 10:13:43 +0530
Subject: RE: [PATCH] rtc: tps65910: Use platform_get_irq to get RTC irq
 details
Thread-Topic: [PATCH] rtc: tps65910: Use platform_get_irq to get RTC irq
 details
Thread-Index: Ac2aeXd15CtmTQOKSFGaTaZBfgRCMgAXpJJg
Message-ID: <D958900912E20642BCBC71664EFECE3E6DDF601733@BGMAIL02.nvidia.com>
References: <1348225223-32156-1-git-send-email-vbyravarasu@nvidia.com>
 <505C8CE9.6040201@wwwdotorg.org>
 <D958900912E20642BCBC71664EFECE3E6DDF60158F@BGMAIL02.nvidia.com>
 <50609746.6020702@wwwdotorg.org>
In-Reply-To: <50609746.6020702@wwwdotorg.org>
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
> Sent: Monday, September 24, 2012 10:54 PM
> To: Venu Byravarasu
> Cc: akpm@linux-foundation.org; a.zummo@towertech.it; linux-
> kernel@vger.kernel.org; rtc-linux@googlegroups.com
> Subject: Re: [PATCH] rtc: tps65910: Use platform_get_irq to get RTC irq
> details
> 
> On 09/24/2012 12:18 AM, Venu Byravarasu wrote:
> >> -----Original Message-----
> >> From: Stephen Warren [mailto:swarren@wwwdotorg.org]
> >> Sent: Friday, September 21, 2012 9:21 PM
> >> To: Venu Byravarasu
> >> Cc: akpm@linux-foundation.org; a.zummo@towertech.it; linux-
> >> kernel@vger.kernel.org; rtc-linux@googlegroups.com
> >> Subject: Re: [PATCH] rtc: tps65910: Use platform_get_irq to get RTC irq
> >> details
> >>
> >> On 09/21/2012 05:00 AM, Venu Byravarasu wrote:
> >>> As RTC driver needs only irq number from platform data,
> >>> using platform_get_irq(), instead of generic dev_get_platdata().
> >>
> >> I assume this patch depends on "mfd: tps65910: Add alarm interrupt of
> >> TPS65910 RTC to mfd device list" which you posted just before? If so,
> >> the two patches should go through the same tree to avoid "git bisect"
> >> issues.
> >>
> >> Also, I thought you needed to fix the MFD driver to call
> >> mfd_add_devices() only after all the IRQ stuff had been set up -
> >> otherwise, when the RTC driver calls devm_request_threaded_irq(), the
> >> parent IRQ domain that the IRQ points at won't exist, and the call will
> >> fail.
> >
> > No, I do not agree completely here.
> > Current patch just changes the way to get irq info in the RTC driver.
> > If proper irq number is passed from MFD, then it proceeds further and
> deals with it.
> > In case of missing valid irq info, this returns error as in earlier case.
> >
> > I agree with you that this patch alone cannot make RTC completely
> functional,
> > till we get mfd patch as well.
> >
> > However should lack of mfd changes really block this patch, as these two
> are
> > independent  drivers.
> 
> OK, if this feature (either the RTC as a whole, or the RTC driver
> retrieving and using the interrupt) doesn't already work, then as you
> say there are no dependencies, so this is fine.

Thanks Stephen.
Will remove the unrelated changes as pointed by you on 1st patch and
send updated patch.
 

