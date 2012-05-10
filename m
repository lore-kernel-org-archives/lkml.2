Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758332Ab2EJKMv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 06:12:51 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:47173 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757799Ab2EJKMs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 06:12:48 -0400
MIME-Version: 1.0
In-Reply-To: <CAH9JG2W-KFH9bDkq14-KayJ30Q3Uj04mWUEXr7AdVa6CFbi6eA@mail.gmail.com>
References: <1335935266-25289-1-git-send-email-thomas.abraham@linaro.org>
	<1335935266-25289-4-git-send-email-thomas.abraham@linaro.org>
	<CAH9JG2XJk+CJNFiZu0C-TK_aj2gRPP5czUvTzEeDBXNejR6qvA@mail.gmail.com>
	<CAJuYYwQqPEDP3ygkjOjeAwUr--M13KSB7JdYm8Tiok5BvJbruw@mail.gmail.com>
	<CAH9JG2W-KFH9bDkq14-KayJ30Q3Uj04mWUEXr7AdVa6CFbi6eA@mail.gmail.com>
Date: Thu, 10 May 2012 15:42:47 +0530
Message-ID: <CAJuYYwRNUoiwJL5ADgSTAEyt0yx8bhwwz-BWSC+fSrN=xXh5Kw@mail.gmail.com>
Subject: Re: [PATCH 3/7] mmc: dw_mmc: add device tree support
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Kyungmin Park <kmpark@infradead.org>
Cc: linux-mmc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-samsung-soc@vger.kernel.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, kgene.kim@samsung.com, cjb@laptop.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 May 2012 15:29, Kyungmin Park <kmpark@infradead.org> wrote:
> On 5/10/12, Thomas Abraham <thomas.abraham@linaro.org> wrote:
>> Dear Mr. Park,
>>
>> On 2 May 2012 12:25, Kyungmin Park <kmpark@infradead.org> wrote:
>>> Hi,

[...]

>>> I googled the "Synopsis Designware Mobile Storage Host Controller" and
>>> Synopsis released it as this name. but still I like the 'dw-mmc'
>>> instead of'dw-mshc'.
>>
>> Ok. Synopsis abbreviates this controller as MSHC in their datasheets
>> available online. Since device tree is more about describing the
>> hardware, using MSHC as the abbreviation will help with correlating
>> hardware specs with the dts file. So I would prefer to continue using
>> mshc as the abbreviation.
>
> Then why author of this file uses "dw-mmc" instead of "dw-mshc"? and
> it uses 'dw_mci' prefix at functions. I just worried and don't want to
> give confusion to users who uses this device.

The device tree source files are independent of any OS specific
implementations. The linux driver for this controller uses dw-mmc and
dw_mci but drivers of this controller for other operating systems
could choose use other names. Since Synopsis calls this controller as
mshc, the dts file would be closer to hardware specs if 'mshc' is used
to describe the controller.

[...]

>>>> +/* Variations in the dw_mci controller */
>>>> +#define DW_MCI_TYPE_SYNOPSIS         0
>>>> +#define DW_MCI_TYPE_EXYNOS5250               1 /* Samsung Exynos5250
>>>> Extensions */
>>> Um. it's not good idea to add specific SOC version. And as you know,
>>> exynos4 series has this controller.
>>
>> There are some differences between the Exynos4 and Exynos5 mshc
>> controllers. For instance, the DIVRATIO field in the CLKSEL register
>> is available only in Exynos5 and there are 8 phase shift values in
>> Exynos5 when compared to 4 phase shift values in Exynos4. Likewise,
>> there are some other differences. So to handle these specific
>> implementations, we need to define types (or variants) of the
>> controller. Using SoC names for the type would help in readability of
>> the different types of implementations that are defined. So I would
>> prefer to continue using SoC names for this.
>
> You mean if it supports the exynos4, then it should be add exynos4 type?
>

If the existing driver requires any Exynos4 specific extensions to
operate the controller correctly on Exynos4, then yes we should add a
Exynos4 type. The Exynos4 and Exynos5 implementations of this
controller vary in certain aspects and so we might need a Exynos4 type
as well.

Thanks,
Thomas.

[...]
