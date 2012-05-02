Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab2EBNun (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 09:50:43 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63363 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186Ab2EBNum convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 09:50:42 -0400
MIME-Version: 1.0
In-Reply-To: <20120502032336.GU2194@S2101-09.ap.freescale.net>
References: <1335924760-796-1-git-send-email-rob.lee@linaro.org>
 <1335924760-796-4-git-send-email-rob.lee@linaro.org> <20120502032336.GU2194@S2101-09.ap.freescale.net>
From: Rob Lee <rob.lee@linaro.org>
Date: Wed, 2 May 2012 08:50:20 -0500
Message-ID: <CAMXH7KHnN3YDwM6crgaFqwrgb4W=CErjgNiTPaZ8wrZ5dvKLuw@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] ARM: imx: Add imx6q cpuidle driver
To: Shawn Guo <shawn.guo@linaro.org>
Cc: kernel@pengutronix.de, amit.kucheria@linaro.org, daniel.lezcano@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org, jj@chaosbits.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 1, 2012 at 10:23 PM, Shawn Guo <shawn.guo@linaro.org> wrote:
> On Tue, May 01, 2012 at 09:12:40PM -0500, Robert Lee wrote:
>> Add basic imx6q cpuidle driver.  For now, only basic WFI state is
>> supported.  Deeper idle states will be added in the future.
>>
>> Signed-off-by: Robert Lee <rob.lee@linaro.org>
>> ---
>>  arch/arm/mach-imx/cpuidle-imx6q.c |   33 +++++++++++++++++++++++++++++++++
>
> So, this file is not needed any more, I guess.
>

Yes, I missed that.  It shouldn't have been part of the patch.

>>  arch/arm/mach-imx/mach-imx6q.c    |   18 ++++++++++++++++++
>>  2 files changed, 51 insertions(+)
>>  create mode 100644 arch/arm/mach-imx/cpuidle-imx6q.c
>>
>> diff --git a/arch/arm/mach-imx/cpuidle-imx6q.c b/arch/arm/mach-imx/cpuidle-imx6q.c
>> new file mode 100644
>> index 0000000..b74557f
>> --- /dev/null
>> +++ b/arch/arm/mach-imx/cpuidle-imx6q.c
>> @@ -0,0 +1,33 @@
>> +/*
>> + * Copyright 2012 Freescale Semiconductor, Inc.
>> + * Copyright 2012 Linaro Ltd.
>> + *
>> + * The code contained herein is licensed under the GNU General Public
>> + * License. You may obtain a copy of the GNU General Public License
>> + * Version 2 or later at the following locations:
>> + *
>> + * http://www.opensource.org/licenses/gpl-license.html
>> + * http://www.gnu.org/copyleft/gpl.html
>> + */
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/init.h>
>> +#include <linux/cpuidle.h>
>> +#include <linux/export.h>
>> +#include <asm/cpuidle.h>
>> +#include <mach/cpuidle.h>
>> +
>> +static struct cpuidle_driver imx6q_cpuidle_driver = {
>> +     .name                   = "imx6q_cpuidle",
>> +     .owner                  = THIS_MODULE,
>> +     .en_core_tk_irqen       = 1,
>> +     .states[0]              = ARM_CPUIDLE_WFI_STATE,
>> +     .state_count            = 1,
>> +};
>> +
>> +int __init imx6q_cpuidle_init(void)
>> +{
>> +     imx_cpuidle_set_driver(&imx6q_cpuidle_driver);
>> +
>> +     return 0;
>> +}
>> diff --git a/arch/arm/mach-imx/mach-imx6q.c b/arch/arm/mach-imx/mach-imx6q.c
>> index da6c1d9..21e2051 100644
>> --- a/arch/arm/mach-imx/mach-imx6q.c
>> +++ b/arch/arm/mach-imx/mach-imx6q.c
>> @@ -21,6 +21,9 @@
>>  #include <linux/of_platform.h>
>>  #include <linux/phy.h>
>>  #include <linux/micrel_phy.h>
>> +#include <linux/export.h>
>> +#include <linux/cpuidle.h>
>> +#include <asm/cpuidle.h>
>>  #include <asm/smp_twd.h>
>>  #include <asm/hardware/cache-l2x0.h>
>>  #include <asm/hardware/gic.h>
>> @@ -29,6 +32,7 @@
>>  #include <asm/system_misc.h>
>>  #include <mach/common.h>
>>  #include <mach/hardware.h>
>> +#include <mach/cpuidle.h>
>
> The headers here are mostly sorted in names, so please ...
>

Do you mean sorted alphabetically per group?  So the last three
includes should look like this instead?
...
#include <mach/common.h>
#include <mach/cpuidle.h>
#include <mach/hardware.h>
...
Thanks,
Rob

> Regards,
> Shawn
>
>>
>>  void imx6q_restart(char mode, const char *cmd)
>>  {
>> @@ -86,6 +90,19 @@ static void __init imx6q_init_machine(void)
>>       imx6q_pm_init();
>>  }
>>
>> +static struct cpuidle_driver imx6q_cpuidle_driver = {
>> +     .name                   = "imx6q_cpuidle",
>> +     .owner                  = THIS_MODULE,
>> +     .en_core_tk_irqen       = 1,
>> +     .states[0]              = ARM_CPUIDLE_WFI_STATE,
>> +     .state_count            = 1,
>> +};
>> +
>> +static void __init imx6q_init_late(void)
>> +{
>> +     imx_cpuidle_init(&imx6q_cpuidle_driver);
>> +}
>> +
>>  static void __init imx6q_map_io(void)
>>  {
>>       imx_lluart_map_io();
>> @@ -142,6 +159,7 @@ DT_MACHINE_START(IMX6Q, "Freescale i.MX6 Quad (Device Tree)")
>>       .handle_irq     = imx6q_handle_irq,
>>       .timer          = &imx6q_timer,
>>       .init_machine   = imx6q_init_machine,
>> +     .init_late      = imx6q_init_late,
>>       .dt_compat      = imx6q_dt_compat,
>>       .restart        = imx6q_restart,
>>  MACHINE_END
>> --
>> 1.7.10
>>
