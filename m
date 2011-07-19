Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120Ab1GSGCl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 02:02:41 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55877 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab1GSGCk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 02:02:40 -0400
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
In-Reply-To: <04a601cc4520$d2d97b40$788c71c0$%kim@samsung.com>
References: <1309395085-22084-1-git-send-email-myungjoo.ham@samsung.com>
	<1309395085-22084-2-git-send-email-myungjoo.ham@samsung.com>
	<04a601cc4520$d2d97b40$788c71c0$%kim@samsung.com>
Date: Tue, 19 Jul 2011 15:02:39 +0900
X-Google-Sender-Auth: I_zN58mnlyyi4pCkKNc993I73T8
Message-ID: <CAJ0PZbRsnO-W4P=3kZvcSn+st4p38ARjsE458TzSreHAche1gw@mail.gmail.com>
Subject: Re: [PATCH 2/2] ARM: EXYNOS4: Add more registers to be saved and
 restored for PM
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Jaecheol Lee <jc.lee@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 5:00 PM, Kukjin Kim <kgene.kim@samsung.com> wrote:
> MyungJoo Ham wrote:
>>
>> We need more registers to be saved and restored for PM of Exynos4210.
>> Otherwise, with additional drivers running, suspend-to-RAM fails to wake
>> up properly. This patch adds registers omitted in the initial PM
>> patches.
>>
>> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  arch/arm/mach-exynos4/pm.c |   77
>> +++++++++++++++++++++++++++++++++++++++++++-
>>  1 files changed, 76 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/arm/mach-exynos4/pm.c b/arch/arm/mach-exynos4/pm.c
>> index a103c13..24c9265 100644
>> --- a/arch/arm/mach-exynos4/pm.c
>> +++ b/arch/arm/mach-exynos4/pm.c
>> @@ -27,6 +27,8 @@
>>  #include <plat/cpu.h>
>>  #include <plat/pm.h>
>>  #include <plat/pll.h>
>> +#include <plat/regs-srom.h>
>> +#include <plat/regs-timer.h>
>>
>>  #include <mach/regs-irq.h>
>>  #include <mach/regs-gpio.h>
>> @@ -60,14 +62,20 @@ static struct sleep_save exynos4_vpll_save[] = {
>>
>>  static struct sleep_save exynos4_core_save[] = {
>>       /* CMU side */
>> +     SAVE_ITEM(S5P_CLKSRC_LEFTBUS),
>
> I think, the reset/default value(0x0, SCLKMPLL) has no problem.
>
>> +     SAVE_ITEM(S5P_CLKOUT_CMU_LEFTBUS),
>
> This is for debugging? So I think no need this.
>
>> +     SAVE_ITEM(S5P_CLKSRC_RIGHTBUS),
>
> Same as 'CLKSRC_LEFTBUS'
>
>> +     SAVE_ITEM(S5P_CLKOUT_CMU_RIGHTBUS),
>
> Same as 'CMU_LEFTBUS'
>
>> +     SAVE_ITEM(S5P_CLKOUT_CMU_TOP),
>
> For debugging...
>
>> +     SAVE_ITEM(S5P_CLKOUT_CMU_DMC),
>
> Same as above.
>
> (snip)
>
>> +     SAVE_ITEM(S5P_APLL_LOCK),
>> +     SAVE_ITEM(S5P_MPLL_LOCK),
>> +     SAVE_ITEM(S5P_APLL_CON0),
>> +     SAVE_ITEM(S5P_APLL_CON1),
>> +     SAVE_ITEM(S5P_MPLL_CON0),
>> +     SAVE_ITEM(S5P_MPLL_CON1),
>
> Basically, these value should be set in boot-loader after wake up.
>
> (snip)
>
>> +     /* PMU */
>> +     SAVE_ITEM(S5P_HDMI_PHY_CONTROL),
>> +     SAVE_ITEM(S5P_USBOTG_PHY_CONTROL),
>> +     SAVE_ITEM(S5P_USBHOST_PHY_CONTROL),
>> +     SAVE_ITEM(S5P_DAC_CONTROL),
>> +     SAVE_ITEM(S5P_MIPI_CONTROL0),
>> +     SAVE_ITEM(S5P_MIPI_CONTROL1),
>> +     SAVE_ITEM(S5P_ADC_CONTROL),
>> +     SAVE_ITEM(S5P_PCIE_CONTROL),
>> +     SAVE_ITEM(S5P_SATA_CONTROL),
>> +     SAVE_ITEM(S5P_PMU_DEBUG),
>> +     SAVE_ITEM(S5P_ARM_CORE0_CONFIGURATION),
>> +     SAVE_ITEM(S5P_ARM_CORE1_CONFIGURATION),
>> +     SAVE_ITEM(S5P_ARM_CPU_L2_0_CONFIGURATION),
>> +     SAVE_ITEM(S5P_ARM_CPU_L2_1_CONFIGURATION),
>> +     SAVE_ITEM(S5P_XUSBXTI_CONFIGURATION),
>> +     SAVE_ITEM(S5P_XXTI_CONFIGURATION),
>> +     SAVE_ITEM(S5P_PMU_CAM_CONF),
>> +     SAVE_ITEM(S5P_PMU_TV_CONF),
>> +     SAVE_ITEM(S5P_PMU_MFC_CONF),
>> +     SAVE_ITEM(S5P_PMU_G3D_CONF),
>> +     SAVE_ITEM(S5P_PMU_LCD0_CONF),
>> +     SAVE_ITEM(S5P_PMU_LCD1_CONF),
>> +     SAVE_ITEM(S5P_MAUDIO_CONFIGURATION),
>> +     SAVE_ITEM(S5P_PMU_GPS_CONF),
>
> Since PMU part is alive block, so no need.
>
>> +
>> +     /* System Controller side */
>> +     SAVE_ITEM(S3C_VA_SYS + 0x0210),
>> +     SAVE_ITEM(S3C_VA_SYS + 0x0214),
>> +     SAVE_ITEM(S3C_VA_SYS + 0x0218),
>> +     SAVE_ITEM(S3C_VA_SYS + 0x0220),
>> +     SAVE_ITEM(S3C_VA_SYS + 0x0230),
>
> Hmm..really need this?
>
>> +
>>       /* GIC side */
>>       SAVE_ITEM(S5P_VA_GIC_CPU + 0x000),
>>       SAVE_ITEM(S5P_VA_GIC_CPU + 0x004),
>> @@ -232,11 +286,32 @@ static struct sleep_save exynos4_core_save[] = {
>>       SAVE_ITEM(S5P_VA_GIC_DIST + 0xC20),
>>       SAVE_ITEM(S5P_VA_GIC_DIST + 0xC24),
>>
>> -
>>       SAVE_ITEM(S5P_VA_COMBINER_BASE + 0x000),
>>       SAVE_ITEM(S5P_VA_COMBINER_BASE + 0x010),
>>       SAVE_ITEM(S5P_VA_COMBINER_BASE + 0x020),
>>       SAVE_ITEM(S5P_VA_COMBINER_BASE + 0x030),
>> +     SAVE_ITEM(S5P_VA_COMBINER_BASE + 0x040),
>> +     SAVE_ITEM(S5P_VA_COMBINER_BASE + 0x050),
>> +     SAVE_ITEM(S5P_VA_COMBINER_BASE + 0x060),
>> +     SAVE_ITEM(S5P_VA_COMBINER_BASE + 0x070),
>> +     SAVE_ITEM(S5P_VA_COMBINER_BASE + 0x080),
>> +     SAVE_ITEM(S5P_VA_COMBINER_BASE + 0x090),
>
> No need to save/restore external GIC part...
>
> (snip)
>
>> +     /* PWM Register */
>> +     SAVE_ITEM(S3C2410_TCFG0),
>> +     SAVE_ITEM(S3C2410_TCFG1),
>> +     SAVE_ITEM(S3C64XX_TINT_CSTAT),
>> +     SAVE_ITEM(S3C2410_TCON),
>> +     SAVE_ITEM(S3C2410_TCNTB(0)),
>> +     SAVE_ITEM(S3C2410_TCMPB(0)),
>> +     SAVE_ITEM(S3C2410_TCNTO(0)),
>
> PWM? I'm not sure why this is needed here.
>
> (snip)
>
> Others, ok.
>
> Thanks.
>
> Best regards,
> Kgene.
> --
> Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
> SW Solution Development Team, Samsung Electronics Co., Ltd.
>
>
Hello,


Removing the registers you've mentioned didn't break the PM test as
NURI board also does not use debug clocks.

And, PWM driver appears to backup and restore ctirical register; thus,
we don't need to back them up at pm.c. That's good.

For PLLs, I'll let it rely on bootloader as you've mentioned.

The corrected patch will follow this reply soon.


Thanks.

- MyungJoo

-- 
MyungJoo Ham (함명주), Ph.D.
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: 82-10-6714-2858
