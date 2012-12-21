Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601Ab2LUSOG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 13:14:06 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:47246 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab2LUSN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 13:13:56 -0500
MIME-Version: 1.0
In-Reply-To: <CAFp+6iFSZjfVJp23j2dEz0hRap07RMo68GJpsQM7YqOMBCbqsQ@mail.gmail.com>
References: <1355416562-25539-1-git-send-email-gautam.vivek@samsung.com>
	<1355416562-25539-2-git-send-email-gautam.vivek@samsung.com>
	<20121215072312.EBCAA3E0C06@localhost>
	<CAFp+6iHoS4XJWHNrsyVsQS4bYZs1PUNEGsRr=EqAS7kpm2XGMQ@mail.gmail.com>
	<CAFp+6iFSZjfVJp23j2dEz0hRap07RMo68GJpsQM7YqOMBCbqsQ@mail.gmail.com>
Date: Fri, 21 Dec 2012 10:13:50 -0800
Message-ID: <CAD=FV=X=GRz0ZuFSqEHPy6i2ULtHk==M2_gaCvdmd=81YMNmMg@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] ARM: Exynos5250: Enabling ehci-s5p driver
From: Doug Anderson <dianders@chromium.org>
To: Vivek Gautam <gautamvivek1987@gmail.com>
Cc: linux-samsung-soc@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        devicetree-discuss@lists.ozlabs.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Vivek Gautam <gautam.vivek@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek,


On Fri, Dec 21, 2012 at 12:16 AM, Vivek Gautam
<gautamvivek1987@gmail.com> wrote:
> Hi all,
>
>
> On Wed, Dec 19, 2012 at 7:20 PM, Vivek Gautam <gautamvivek1987@gmail.com> wrote:
>> CC: Doug Anderson
>>
>>
>> On Sat, Dec 15, 2012 at 12:53 PM, Grant Likely
>> <grant.likely@secretlab.ca> wrote:
>>> On Thu, 13 Dec 2012 22:06:01 +0530, Vivek Gautam <gautam.vivek@samsung.com> wrote:
>>>> diff --git a/arch/arm/mach-exynos/mach-exynos5-dt.c b/arch/arm/mach-exynos/mach-exynos5-dt.c
>>>> index 462e5ac..b3b9af1 100644
>>>> --- a/arch/arm/mach-exynos/mach-exynos5-dt.c
>>>> +++ b/arch/arm/mach-exynos/mach-exynos5-dt.c
>>>> @@ -110,6 +110,8 @@ static const struct of_dev_auxdata exynos5250_auxdata_lookup[] __initconst = {
>>>>                               "samsung-i2s.1", NULL),
>>>>       OF_DEV_AUXDATA("samsung,samsung-i2s", 0x12D70000,
>>>>                               "samsung-i2s.2", NULL),
>>>> +     OF_DEV_AUXDATA("samsung,exynos4210-ehci", EXYNOS5_PA_EHCI,
>>>> +                             "s5p-ehci", NULL),
>>>
>>> I'm assuming the above change is temporary. What is left to be done to
>>> drop the auxdata in theses two patches?
>>>
>>> Otherwise the patch looks fine.
>>>
>>> Acked-by: Grant Likely <grant.likely@secretlab.ca>
>
> Any more thought about this patch?
> Or does this change seems fine?

I'm fairly certain we can just drop the OF_DEV_AUXDATA entry here.  I
haven't been following this as closely as I should, but I know that
the comment for this table says that the whole purpose is to override
device names and that it should be temporary.  We don't need to do any
overriding of device names here, do we?

When I drop this (and the ohci and phy) entries from my table I can
still boot and still can use USB.  The big difference is what shows up
in dmesg

[    1.605000] s5p-ehci s5p-ehci: S5P EHCI Host Controller

Becomes:

[    1.550000] s5p-ehci 12110000.usb: S5P EHCI Host Controller

...and some sysfs paths change.

-Doug
