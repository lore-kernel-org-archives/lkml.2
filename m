Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330Ab1KOGUM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 01:20:12 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65349 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab1KOGUK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 01:20:10 -0500
MIME-Version: 1.0
In-Reply-To: <CAH9JG2UDZ92zFiiPQYxbNJgLqcqGv_D9dFNdqJa2o+BxiUzygg@mail.gmail.com>
References: <1321333132-17662-1-git-send-email-pullip.cho@samsung.com>
	<1321333132-17662-2-git-send-email-pullip.cho@samsung.com>
	<CAH9JG2UDZ92zFiiPQYxbNJgLqcqGv_D9dFNdqJa2o+BxiUzygg@mail.gmail.com>
Date: Tue, 15 Nov 2011 15:12:41 +0900
X-Google-Sender-Auth: o6FJH69Z6vGqAwOh6DkpoaNQfRA
Message-ID: <CAHQjnOOMq9icOWY-b1z0YaJKZcx-b=Kv9ZT9dnwHAjVM5=hCrQ@mail.gmail.com>
Subject: Re: [PATCH v6 1/2] ARM: EXYNOS: Change System MMU platform device definitions
From: KyongHo Cho <pullip.cho@samsung.com>
To: Kyungmin Park <kmpark@infradead.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>,
        Sanghyun Lee <sanghyun75.lee@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        YoungLak Kim <younglak1004.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 2:37 PM, Kyungmin Park <kmpark@infradead.org> wrote:
>> @@ -988,6 +989,21 @@ static struct platform_device *universal_devices[]
>> __initdata = {
>>       &cam_i_core_fixed_reg_dev,
>>       &cam_s_if_fixed_reg_dev,
>>       &s5p_device_fimc_md,
>> +     &SYSMMU_PLATDEV(sss),
>> +     &SYSMMU_PLATDEV(jpeg),
>> +     &SYSMMU_PLATDEV(fimd1),
>> +     &SYSMMU_PLATDEV(2d),
>> +     &SYSMMU_PLATDEV(rot),
>> +     &SYSMMU_PLATDEV(mdma),
>> +     &SYSMMU_PLATDEV(tv),
>> +     &SYSMMU_PLATDEV(mfc_l),
>> +     &SYSMMU_PLATDEV(mfc_r),
>> +     &SYSMMU_PLATDEV(fimc0),
>> +     &SYSMMU_PLATDEV(fimc1),
>> +     &SYSMMU_PLATDEV(fimc2),
>> +     &SYSMMU_PLATDEV(fimc3),
>> +     &SYSMMU_PLATDEV(fimd0),
>> +     &SYSMMU_PLATDEV(pcie),
> Platform device is optional for each board and pcie doesn't used at
> mobile board. Does it require to register all platform devices at
> board?

Of course we make them selectable in menuconfig according
to the selection of their host devices. But the array definition will
contain lots of #ifdef.

And I defined System MMU dev for PCIe for future use
although it is useless in mobile devices.

>>
>> +static void __init sysmmu_init(void)
>> +{
>> +     ASSIGN_SYSMMU_POWERDOMAIN(fimc0, &exynos4_device_pd[PD_CAM].dev);
>> +     ASSIGN_SYSMMU_POWERDOMAIN(fimc1, &exynos4_device_pd[PD_CAM].dev);
>> +     ASSIGN_SYSMMU_POWERDOMAIN(fimc2, &exynos4_device_pd[PD_CAM].dev);
>> +     ASSIGN_SYSMMU_POWERDOMAIN(fimc3, &exynos4_device_pd[PD_CAM].dev);
>> +     ASSIGN_SYSMMU_POWERDOMAIN(jpeg, &exynos4_device_pd[PD_CAM].dev);
>> +     ASSIGN_SYSMMU_POWERDOMAIN(mfc_l, &exynos4_device_pd[PD_MFC].dev);
>> +     ASSIGN_SYSMMU_POWERDOMAIN(mfc_r, &exynos4_device_pd[PD_MFC].dev);
>> +     ASSIGN_SYSMMU_POWERDOMAIN(fimd0, &exynos4_device_pd[PD_LCD0].dev);
>> +     ASSIGN_SYSMMU_POWERDOMAIN(rot, &exynos4_device_pd[PD_LCD0].dev);
>> +     ASSIGN_SYSMMU_POWERDOMAIN(mdma, &exynos4_device_pd[PD_LCD0].dev);
>> +     ASSIGN_SYSMMU_POWERDOMAIN(tv, &exynos4_device_pd[PD_TV].dev);
>> +
>> +     sysmmu_set_owner(&SYSMMU_PLATDEV(fimc0).dev, &s5p_device_fimc0.dev);
>> +     sysmmu_set_owner(&SYSMMU_PLATDEV(fimc1).dev, &s5p_device_fimc1.dev);
>> +     sysmmu_set_owner(&SYSMMU_PLATDEV(fimc2).dev, &s5p_device_fimc2.dev);
>> +     sysmmu_set_owner(&SYSMMU_PLATDEV(fimc3).dev, &s5p_device_fimc3.dev);
>> +     sysmmu_set_owner(&SYSMMU_PLATDEV(mfc_l).dev, &s5p_device_mfc.dev);
>> +     sysmmu_set_owner(&SYSMMU_PLATDEV(mfc_r).dev, &s5p_device_mfc.dev);
>> +     sysmmu_set_owner(&SYSMMU_PLATDEV(fimd0).dev, &s5p_device_fimd0.dev);
>> +     sysmmu_set_owner(&SYSMMU_PLATDEV(tv).dev, &s5p_device_mixer.dev);
>> +}
>> +
>>  static void __init universal_machine_init(void)
>>  {
>>       universal_sdhci_init();
>> @@ -1040,6 +1080,8 @@ static void __init universal_machine_init(void)
>>
>>       universal_camera_init();
>>
>> +     sysmmu_init();
> I think how do you implement the sysmm_init at cpu or common file? and
> board select it to use iommu or not. no need to implement the almost
> same codes at each board.
>
It is not easy to move sysmmu_init() out from mach_*.c files because System MMU
configuration is vary from boards and APs. It is just machine-specific.

> Otherwise looks good.
>
Thank you :)

KyongHo.
