Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab1IMHKJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 03:10:09 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43337 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754743Ab1IMHKH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 03:10:07 -0400
From: "Ravi, Deepthy" <deepthy.ravi@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mchehab@infradead.org" <mchehab@infradead.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
        "Hiremath, Vaibhav" <hvaibhav@ti.com>
Date: Tue, 13 Sep 2011 12:36:20 +0530
Subject: RE: [PATCH 1/8] omap3evm: Enable regulators for camera interface
Thread-Topic: [PATCH 1/8] omap3evm: Enable regulators for camera interface
Thread-Index: AcxuR98Ggsdoa+x+QrSckXE7Ax44nADm8SeW
Message-ID: <ADF30F4D7BDE934D9B632CE7D5C7ACA4047C4D090831@dbde03.ent.ti.com>
References: <1315488831-15998-1-git-send-email-deepthy.ravi@ti.com>,<201109081851.53078.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201109081851.53078.laurent.pinchart@ideasonboard.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
> ________________________________________
> From: Laurent Pinchart [laurent.pinchart@ideasonboard.com]
> Sent: Thursday, September 08, 2011 10:21 PM
> To: Ravi, Deepthy
> Cc: linux-omap@vger.kernel.org; tony@atomide.com; linux@arm.linux.org.uk; linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org; mchehab@infradead.org; linux-media@vger.kernel.org; g.liakhovetski@gmx.de; Hiremath, Vaibhav
> Subject: Re: [PATCH 1/8] omap3evm: Enable regulators for camera interface
>
> Hi,
>
> On Thursday 08 September 2011 15:33:51 Deepthy Ravi wrote:
>> From: Vaibhav Hiremath <hvaibhav@ti.com>
>>
>> Enabled 1v8 and 2v8 regulator output, which is being used by
>> camera module.
>
> Thanks for the patch. Just one minor comment below.
>
>> Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
>> Signed-off-by: Deepthy Ravi <deepthy.ravi@ti.com>
>> ---
>>  arch/arm/mach-omap2/board-omap3evm.c |   40
>> ++++++++++++++++++++++++++++++++++ 1 files changed, 40 insertions(+), 0
>> deletions(-)
>>
>> diff --git a/arch/arm/mach-omap2/board-omap3evm.c
>> b/arch/arm/mach-omap2/board-omap3evm.c index a1184b3..8333ee4 100644
>> --- a/arch/arm/mach-omap2/board-omap3evm.c
>> +++ b/arch/arm/mach-omap2/board-omap3evm.c
>> @@ -273,6 +273,44 @@ static struct omap_dss_board_info omap3_evm_dss_data =
>> { .default_device     = &omap3_evm_lcd_device,
>>  };
>>
>> +static struct regulator_consumer_supply omap3evm_vaux3_supply = {
>> +     .supply         = "cam_1v8",
>> +};
>> +
>> +static struct regulator_consumer_supply omap3evm_vaux4_supply = {
>> +     .supply         = "cam_2v8",
>> +};
>> +
>> +/* VAUX3 for CAM_1V8 */
>> +static struct regulator_init_data omap3evm_vaux3 = {
>> +     .constraints = {
>> +             .min_uV                 = 1800000,
>> +             .max_uV                 = 1800000,
>> +             .apply_uV               = true,
>> +             .valid_modes_mask       = REGULATOR_MODE_NORMAL
>> +                                     | REGULATOR_MODE_STANDBY,
>> +             .valid_ops_mask         = REGULATOR_CHANGE_MODE
>> +                                     | REGULATOR_CHANGE_STATUS,
>> +             },
>> +     .num_consumer_supplies  = 1,
>> +     .consumer_supplies      = &omap3evm_vaux3_supply,
>
> I might be wrong, but I think we're standardizing on using REGULATOR_SUPPLY
> arrays as described in commit 786b01a8c1db0c0decca55d660a2a3ebd7cfb26b
> ("cleanup regulator supply definitions in mach-omap2").
>
[Deepthy Ravi] Yes, you are right. I will modify it.
>> +};
>> +
>> +/* VAUX4 for CAM_2V8 */
>> +static struct regulator_init_data omap3evm_vaux4 = {
>> +     .constraints = {
>> +             .min_uV                 = 1800000,
>> +             .max_uV                 = 1800000,
>> +             .apply_uV               = true,
>> +             .valid_modes_mask       = REGULATOR_MODE_NORMAL
>> +                     | REGULATOR_MODE_STANDBY,
>> +             .valid_ops_mask         = REGULATOR_CHANGE_MODE
>> +                     | REGULATOR_CHANGE_STATUS,
>> +     },
>> +     .num_consumer_supplies  = 1,
>> +     .consumer_supplies      = &omap3evm_vaux4_supply,
>> +};
>> +
>>  static struct regulator_consumer_supply omap3evm_vmmc1_supply[] = {
>>       REGULATOR_SUPPLY("vmmc", "omap_hsmmc.0"),
>>  };
>> @@ -499,6 +537,8 @@ static struct twl4030_platform_data omap3evm_twldata =
>> { .vio                = &omap3evm_vio,
>>       .vmmc1          = &omap3evm_vmmc1,
>>       .vsim           = &omap3evm_vsim,
>> +     .vaux3          = &omap3evm_vaux3,
>> +     .vaux4          = &omap3evm_vaux4,
>>  };
>>
>>  static int __init omap3_evm_i2c_init(void)
>
> --
> Regards,
>
> Laurent Pinchart
>

Thanks,
Deepthy Ravi.
