Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031637Ab2CGAKp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 19:10:45 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:42741 "EHLO
	mail-lpp01m020-f174.google.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758988Ab2CGAKo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 19:10:44 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of pullip.linux@gmail.com designates 10.112.85.33 as permitted sender) smtp.mail=pullip.linux@gmail.com; dkim=pass header.i=pullip.linux@gmail.com
MIME-Version: 1.0
In-Reply-To: <CAH9JG2Uvc27UMcsy_Apqo+Td_td_18C6i3vvC8aroBse2=+53w@mail.gmail.com>
References: <002101ccfb73$8684c240$938e46c0$%cho@samsung.com>
	<CAH9JG2Uvc27UMcsy_Apqo+Td_td_18C6i3vvC8aroBse2=+53w@mail.gmail.com>
Date: Wed, 7 Mar 2012 09:10:42 +0900
X-Google-Sender-Auth: ogsWR0vnjPNcb2Bn3fJFUvEhfZc
Message-ID: <CAHQjnOP_mEck35PwhDd7v=MKc+ONFRFxa7i=ro0iMxWy-fuFNw@mail.gmail.com>
Subject: Re: [PATCH v10 2/3] ARM: EXYNOS: Change System MMU platform device definitions
From: KyongHo Cho <pullip.cho@samsung.com>
To: Kyungmin Park <kyungmin.park@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Subash Patel <subash.ramaswamy@linaro.org>,
        Younglak Kim <younglak1004.kim@samsung.com>,
        iommu@lists.linux-foundation.org, Kukjin Kim <kgene.kim@samsung.com>,
        Sanghyun Lee <sanghyun75.lee@samsung.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 6, 2012 at 7:03 PM, Kyungmin Park <kyungmin.park@samsung.com> wrote:
>>
>> -#define S5P_SYSMMU_TOTAL_IPNUM               EXYNOS4_SYSMMU_TOTAL_IPNUM
>> +#define SYSMMU_DEVNAME_BASE "exynos-sysmmu"
>> +
>> +#define SYSMMU_CLOCK_NAME "sysmmu"
>> +#define SYSMMU_CLOCK_NAME2 "sysmmu_mc"
> What's the meaning of "mc"?
It stands for multi clock gating source.
ISP block has a lot of System MMUs and I merged them in a single
platform device to control them easier. However it is required to access
2 control registers to gating  their clocks. "sysmmu_mc" is prepared for the
case that requires 2 clock descriptors for clock gating.

>> +
>> +#ifdef CONFIG_EXYNOS_DEV_SYSMMU
>> +#include <linux/device.h>
>> +struct platform_device;
>> +
>> +#define SYSMMU_PLATDEV(ipname) exynos_device_sysmmu_##ipname
>> +
>> +extern struct platform_device SYSMMU_PLATDEV(mfc_l);
>> +extern struct platform_device SYSMMU_PLATDEV(mfc_r);
>> +extern struct platform_device SYSMMU_PLATDEV(tv);
>> +extern struct platform_device SYSMMU_PLATDEV(jpeg);
>> +extern struct platform_device SYSMMU_PLATDEV(rot);
> Where's the fimc platform_device?
>
> I think you only tested it with exynos5.

True. I am sorry that I have missed to define it externally.
Thank you.

Cho KyongHo.
