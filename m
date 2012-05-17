Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761986Ab2EQOqo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 10:46:44 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:62388 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761981Ab2EQOqm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 10:46:42 -0400
MIME-Version: 1.0
In-Reply-To: <20120516174740.GW30400@pengutronix.de>
References: <1337135616-8988-1-git-send-email-rob.lee@linaro.org>
 <1337135616-8988-5-git-send-email-rob.lee@linaro.org> <20120516174740.GW30400@pengutronix.de>
From: Rob Lee <rob.lee@linaro.org>
Date: Thu, 17 May 2012 09:46:21 -0500
Message-ID: <CAMXH7KGBK=FkggQxJBaNZ-CZDQm=bV9ZtuB3Yf6vykR5FULA8A@mail.gmail.com>
Subject: Re: [PATCH v4 4/7] ARM: imx: Enable imx53 low power idle
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: kernel@pengutronix.de, shawn.guo@linaro.org,
        u.kleine-koenig@pengutronix.de, richard.zhao@freescale.com,
        amit.kucheria@linaro.org, daniel.lezcano@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org, jj@chaosbits.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 12:47 PM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> On Tue, May 15, 2012 at 09:33:33PM -0500, Robert Lee wrote:
>> Add various functionality needed to enable a imx53 low power idle
>> state.  This includes adding the imx53 gpc_dvfs clock and making a
>> common imx5_late_init function and initializing all imx53
>>  MACHINE_STATE late_init calls to imx5_late_init.
>>
>> Signed-off-by: Robert Lee <rob.lee@linaro.org>
>> ---
>>  arch/arm/mach-imx/clock-mx51-mx53.c     |    1 +
>>  arch/arm/mach-imx/imx53-dt.c            |    1 +
>>  arch/arm/mach-imx/mach-mx53_ard.c       |    1 +
>>  arch/arm/mach-imx/mach-mx53_evk.c       |    1 +
>>  arch/arm/mach-imx/mach-mx53_loco.c      |    1 +
>>  arch/arm/mach-imx/mach-mx53_smd.c       |    1 +
>>  arch/arm/mach-imx/mm-imx5.c             |    7 ++++++-
>>  arch/arm/plat-mxc/include/mach/common.h |    1 +
>>  8 files changed, 13 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/mach-imx/clock-mx51-mx53.c b/arch/arm/mach-imx/clock-mx51-mx53.c
>> index 0847050..decedc6 100644
>> --- a/arch/arm/mach-imx/clock-mx51-mx53.c
>> +++ b/arch/arm/mach-imx/clock-mx51-mx53.c
>> @@ -1529,6 +1529,7 @@ static struct clk_lookup mx53_lookups[] = {
>>       _REGISTER_CLOCK("imx-ssi.1", NULL, ssi2_clk)
>>       _REGISTER_CLOCK("imx-ssi.2", NULL, ssi3_clk)
>>       _REGISTER_CLOCK("imx-keypad", NULL, dummy_clk)
>> +     _REGISTER_CLOCK(NULL, "gpc_dvfs", gpc_dvfs_clk)
>
> This has to be rebased against the common clock patches.
>

Ok.

>>       .timer = &mx53_smd_timer,
>>       .init_machine = mx53_smd_board_init,
>> +     .init_late      = imx5_init_late,
>>       .restart        = mxc_restart,
>>  MACHINE_END
>> diff --git a/arch/arm/mach-imx/mm-imx5.c b/arch/arm/mach-imx/mm-imx5.c
>> index bb38747..7740739 100644
>> --- a/arch/arm/mach-imx/mm-imx5.c
>> +++ b/arch/arm/mach-imx/mm-imx5.c
>> @@ -216,8 +216,13 @@ void __init imx53_soc_init(void)
>>                                       ARRAY_SIZE(imx53_audmux_res));
>>  }
>>
>> +void __init imx5_init_late(void)
>> +{
>> +     imx5_pm_init();
>> +}
>> +
>>  void __init imx51_init_late(void)
>>  {
>>       mx51_neon_fixup();
>> -     imx5_pm_init();
>> +     imx5_init_late();
>>  }
>
> Where would you add i.MX53 specific code above? Hint: imx5_init_late is
> the wrong function name.

I added imx5_init_late for late_init functionality that is common
among all imx5.  For example, in the future imx50 may use it as well.
But I can remove this and repeat the imx5_pm_init() calls for each
platform if you prefer that.

Thanks,
Rob

>
> Sascha
>
> --
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
