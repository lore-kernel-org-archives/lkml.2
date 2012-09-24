Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265Ab2IXRY0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 13:24:26 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55518 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755495Ab2IXRYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 13:24:25 -0400
Message-ID: <50609746.6020702@wwwdotorg.org>
Date: Mon, 24 Sep 2012 11:24:22 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>
Subject: Re: [PATCH] rtc: tps65910: Use platform_get_irq to get RTC irq details
References: <1348225223-32156-1-git-send-email-vbyravarasu@nvidia.com> <505C8CE9.6040201@wwwdotorg.org> <D958900912E20642BCBC71664EFECE3E6DDF60158F@BGMAIL02.nvidia.com>
In-Reply-To: <D958900912E20642BCBC71664EFECE3E6DDF60158F@BGMAIL02.nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2012 12:18 AM, Venu Byravarasu wrote:
>> -----Original Message-----
>> From: Stephen Warren [mailto:swarren@wwwdotorg.org]
>> Sent: Friday, September 21, 2012 9:21 PM
>> To: Venu Byravarasu
>> Cc: akpm@linux-foundation.org; a.zummo@towertech.it; linux-
>> kernel@vger.kernel.org; rtc-linux@googlegroups.com
>> Subject: Re: [PATCH] rtc: tps65910: Use platform_get_irq to get RTC irq
>> details
>>
>> On 09/21/2012 05:00 AM, Venu Byravarasu wrote:
>>> As RTC driver needs only irq number from platform data,
>>> using platform_get_irq(), instead of generic dev_get_platdata().
>>
>> I assume this patch depends on "mfd: tps65910: Add alarm interrupt of
>> TPS65910 RTC to mfd device list" which you posted just before? If so,
>> the two patches should go through the same tree to avoid "git bisect"
>> issues.
>>
>> Also, I thought you needed to fix the MFD driver to call
>> mfd_add_devices() only after all the IRQ stuff had been set up -
>> otherwise, when the RTC driver calls devm_request_threaded_irq(), the
>> parent IRQ domain that the IRQ points at won't exist, and the call will
>> fail.
> 
> No, I do not agree completely here.
> Current patch just changes the way to get irq info in the RTC driver.
> If proper irq number is passed from MFD, then it proceeds further and deals with it.
> In case of missing valid irq info, this returns error as in earlier case.
> 
> I agree with you that this patch alone cannot make RTC completely functional,
> till we get mfd patch as well.
> 
> However should lack of mfd changes really block this patch, as these two are
> independent  drivers.

OK, if this feature (either the RTC as a whole, or the RTC driver
retrieving and using the interrupt) doesn't already work, then as you
say there are no dependencies, so this is fine.
