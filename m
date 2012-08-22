Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab2HVEhF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 00:37:05 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:52652 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab2HVEhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 00:37:02 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdYiJOkHrjZ22_0onRHc0ApmBLj+tXPa4SrPo2h0d=fJHA@mail.gmail.com>
References: <1345060656-32201-1-git-send-email-thomas.abraham@linaro.org>
	<1345060656-32201-3-git-send-email-thomas.abraham@linaro.org>
	<CACRpkdYiJOkHrjZ22_0onRHc0ApmBLj+tXPa4SrPo2h0d=fJHA@mail.gmail.com>
Date: Wed, 22 Aug 2012 10:07:01 +0530
Message-ID: <CAJuYYwRyzKyT97kc9UkPgQq8-1_QwBCfgjnN9sv6ccWtg4Fp0Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] pinctrl: add exynos4210 specific extensions for
 samsung pinctrl driver
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, kgene.kim@samsung.com, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 August 2012 17:32, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Wed, Aug 15, 2012 at 9:57 PM, Thomas Abraham
> <thomas.abraham@linaro.org> wrote:
>
>> Add information about the Exynos4210 pin banks and driver data which is
>> used by the Samsung pinctrl driver. In addition to this, the support for
>> external gpio and wakeup interrupt support is included and hooked up with
>> the Samsung pinctrl driver.
>
> OK...
>
>> diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
>> +config PINCTRL_EXYNOS4
>> +       bool "Pinctrl driver data for Exynos4 SoC"
>> +       depends on ARCH_EXYNOS4 && OF
>
> Since you depend on PINCTRL_SAMSUNG which depends
> on OF you don't need to depend on OF here.

Ok.

>
>> +       depends on PINCTRL_SAMSUNG
>> +       select PINMUX
>> +       select PINCONF
>
> So as noted in the main driver, let PINCTRL_SAMSUNG
> select PINMUX and PINCONF and you need only select
> PINCTRL_SAMSUNG here.

Ok.

>
>> diff --git a/drivers/pinctrl/pinctrl-exynos.c b/drivers/pinctrl/pinctrl-exynos.c
> (...)
>> +#include <linux/interrupt.h>
>> +#include <linux/irqdomain.h>
>> +#include <linux/irq.h>
>> +#include <linux/of_irq.h>
>
> Do you need these includes? Didn't you put them
> all in "pinctrl-samsung.h"?

Yes, I will fix this.

>
> Overall this looks good and straight-forward, but I cannot figure
> out how the samsung_pinctrl_soc_data is passed to the main
> driver, it seems to be through some DT node but I cannot figure
> this out. Can you explain this?

The main driver uses the .data field of the of_device_id structure to
pass the pointer of the SoC data. So, upon match of a compatible value
which is supported by the main driver with that in dt, the
of_match_node() call can be used to find out the corresponding SoC
data. There are included in the first patch (reference:
samsung_pinctrl_get_soc_data() function and samsung_pinctrl_dt_mach
structure).

>
> Yours,
> Linus Walleij

Thanks,
Thomas.
