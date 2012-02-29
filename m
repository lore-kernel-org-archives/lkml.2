Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965331Ab2B2JmO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 04:42:14 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:32718 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965136Ab2B2JmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 04:42:11 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Date: Wed, 29 Feb 2012 10:42:07 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v9 1/2] ARM: EXYNOS: Change System MMU platform device
 definitions
In-reply-to: <CAHQjnOO1aADVQWxNt-J3nb0bgJvc2dfk+6qTWKWx7w+-LUVSmw@mail.gmail.com>
To: KyongHo Cho <pullip.cho@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Joerg Roedel <joro@8bytes.org>,
        Subash Patel <subash.ramaswamy@linaro.org>,
        Younglak Kim <younglak1004.kim@samsung.com>,
        Sanghyun Lee <sanghyun75.lee@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <4F4DF2EF.1090505@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.27)
 Gecko/20120216 Thunderbird/3.1.19
References: <001901ccf5e3$6a363320$3ea29960$%cho@samsung.com>
 <CAH9JG2Uvh=_GWFWyBrE-hfGTvrwvs6n37bmKaHbCovJ++EeJ7g@mail.gmail.com>
 <CAHQjnOO1aADVQWxNt-J3nb0bgJvc2dfk+6qTWKWx7w+-LUVSmw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 02/29/2012 01:25 AM, KyongHo Cho wrote:
>>>  static int exynos4_clk_hdmiphy_ctrl(struct clk *clk, int enable)
>>>  {
>>>       return s5p_gatectrl(S5P_HDMI_PHY_CONTROL, clk, enable);
>>> @@ -679,61 +684,55 @@ static struct clk exynos4_init_clocks_off[] = {
>>>               .enable         = exynos4_clk_ip_peril_ctrl,
>>>               .ctrlbit        = (1 << 14),
>>>       }, {
>>> -             .name           = "SYSMMU_MDMA",
>>> +             .name           = SYSMMU_CLOCK_NAME,
>>> +             .devname        = SYSMMU_CLOCK_DEVNAME(mfc_l, 0),
>>> +             .enable         = exynos4_clk_ip_mfc_ctrl,
>>> +             .ctrlbit        = (1 << 1),
>>> +     }, {
>>> +             .name           = SYSMMU_CLOCK_NAME,
>>> +             .devname        = SYSMMU_CLOCK_DEVNAME(mfc_r, 1),
>>> +             .enable         = exynos4_clk_ip_mfc_ctrl,
>>> +             .ctrlbit        = (1 << 2),
>>> +     }, {
>>> +             .name           = SYSMMU_CLOCK_NAME,
>>> +             .devname        = SYSMMU_CLOCK_DEVNAME(tv, 2),
>>> +             .enable         = exynos4_clk_ip_tv_ctrl,
>>> +             .ctrlbit        = (1 << 4),
>>> +     }, {
>>> +             .name           = SYSMMU_CLOCK_NAME,
>>> +             .devname        = SYSMMU_CLOCK_DEVNAME(jpeg, 3),
>>> +             .enable         = exynos4_clk_ip_cam_ctrl,
>>> +             .ctrlbit        = (1 << 11),
>>> +     }, {
>>> +             .name           = SYSMMU_CLOCK_NAME,
>>> +             .devname        = SYSMMU_CLOCK_DEVNAME(rot, 4),
>>>               .enable         = exynos4_clk_ip_image_ctrl,
>>> -             .ctrlbit        = (1 << 5),
>>> +             .ctrlbit        = (1 << 4),
>>>       }, {
>>> -             .name           = "SYSMMU_FIMC0",
>>> +             .name           = SYSMMU_CLOCK_NAME,
>>> +             .devname        = SYSMMU_CLOCK_DEVNAME(gsc0, 5),
>> It's exynos4 series clock and don't have gsc name. I don't know LSI
>> decides to use gsc instead of fimc for both exynos4 and exynos5. but
>> there's no name gsc at Spec..
> 
> gsc0 is just a name of the platform device of FIMC0 in Exynos4.

I think it's not right what you're saying. Gscalers first appeared only
in exynos5 (at least according to all specifications I have) and you already
have the corresponding change for clock-exynos5.c. FIMCs in exynos 4210, 4212
and 4412 are almost not changed, so please don't rename like this, which is 
confusing. If you need common clkdev entries for the exynos4 and exynos5 
devices, then the "devname"s above might need to be removed and required 
clock entries should be created through the CLKDEV_INIT() macro.

> It is also used for GSclaler0 in Exynos5.
> I wanted to reduce waste of platform device definitions that do not exist
> in an application processor.
> 
> If it looks confused, I will find another way.

Thanks,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
