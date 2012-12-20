Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470Ab2LTFv3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 00:51:29 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:52671 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518Ab2LTFvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 00:51:22 -0500
MIME-Version: 1.0
In-Reply-To: <CAD=FV=Ved4TSr7v413u5_o2cBrfegGrpKe1V2qKwQ36v-MQTHA@mail.gmail.com>
References: <1355841786-13307-1-git-send-email-gautam.vivek@samsung.com>
	<1355841786-13307-2-git-send-email-gautam.vivek@samsung.com>
	<CAD=FV=Ved4TSr7v413u5_o2cBrfegGrpKe1V2qKwQ36v-MQTHA@mail.gmail.com>
Date: Thu, 20 Dec 2012 11:21:20 +0530
Message-ID: <CAFp+6iEGhrSh+oFnv1s_Tqdzxh_nhy=NEhCetVF20KVehy3PLw@mail.gmail.com>
Subject: Re: [PATCH v5 1/4] ARM: EXYNOS: Update & move usb-phy types to
 generic include layer
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Doug Anderson <dianders@chromium.org>
Cc: Vivek Gautam <gautam.vivek@samsung.com>, jg1.han@samsung.com,
        yulgon.kim@samsung.com, linux-samsung-soc@vger.kernel.org,
        Praveen Paneri <p.paneri@samsung.com>, gregkh@linuxfoundation.org,
        devicetree-discuss@lists.ozlabs.org, linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        balbi@ti.com, kishon@ti.com, Kukjin Kim <kgene.kim@samsung.com>,
        stern@rowland.harvard.edu, rob.herring@calxeda.com,
        sylvester.nawrocki@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug,


On Thu, Dec 20, 2012 at 3:18 AM, Doug Anderson <dianders@chromium.org> wrote:
> Vivek,
>
> On Tue, Dec 18, 2012 at 6:43 AM, Vivek Gautam <gautam.vivek@samsung.com> wrote:
>> Updating the names of usb-phy types to more generic names:
>> USB_PHY_TYPE_DEIVCE & USB_PHY_TYPE_HOST; and further update
>> its dependencies.
>
> Since you're changing the name, I would have expected to see a removal
> of the old enum type in this patch.  I don't see it.  After applying
> all of your patches I find that S5P_USB_PHY_HOST and
> S5P_USB_PHY_DEVICE are still defined and used.
>

True that we should have removed the earlier defined enums, infact i
did the same
in patchset v4 for this series. But since in this patchset i separated
out drivers and
architecture part, i thought it would be easier to remove them in one
shot in a latter commit
which will actually touch upon all architecture related code
(mach-exynos/setup-usb-phy.c,
mach-s5pv210/setup-usb-phy.c, and include/plat/usb-phy.h) once this
approach is accepted.

> $ git grep S5P_USB_PHY_HOST
> arch/arm/mach-exynos/setup-usb-phy.c:   else if (type == S5P_USB_PHY_HOST)
> arch/arm/mach-exynos/setup-usb-phy.c:   else if (type == S5P_USB_PHY_HOST)
> arch/arm/plat-samsung/include/plat/usb-phy.h:   S5P_USB_PHY_HOST,
>
> I believe that those usages of the old enum should also be switched
> over and the old enum removed.
>
Sure, those enums need to be removed.
If you say i will submit a patch for the same.

>> Signed-off-by: Praveen Paneri <p.paneri@samsung.com>
>> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>> ---
>>  drivers/usb/host/ehci-s5p.c         |    9 +++++----
>>  drivers/usb/host/ohci-exynos.c      |    9 +++++----
>>  include/linux/usb/samsung_usb_phy.h |   16 ++++++++++++++++
>>  3 files changed, 26 insertions(+), 8 deletions(-)
>>  create mode 100644 include/linux/usb/samsung_usb_phy.h
>>
>> diff --git a/drivers/usb/host/ehci-s5p.c b/drivers/usb/host/ehci-s5p.c
>> index 319dcfa..46ca5ef 100644
>> --- a/drivers/usb/host/ehci-s5p.c
>> +++ b/drivers/usb/host/ehci-s5p.c
>> @@ -17,6 +17,7 @@
>>  #include <linux/platform_device.h>
>>  #include <linux/of_gpio.h>
>>  #include <linux/platform_data/usb-ehci-s5p.h>
>> +#include <linux/usb/samsung_usb_phy.h>
>>  #include <plat/usb-phy.h>
>>
>>  #define EHCI_INSNREG00(base)                   (base + 0x90)
>> @@ -164,7 +165,7 @@ static int s5p_ehci_probe(struct platform_device *pdev)
>>         }
>>
>>         if (pdata->phy_init)
>> -               pdata->phy_init(pdev, S5P_USB_PHY_HOST);
>> +               pdata->phy_init(pdev, USB_PHY_TYPE_HOST);
>>
>>         ehci = hcd_to_ehci(hcd);
>>         ehci->caps = hcd->regs;
>> @@ -198,7 +199,7 @@ static int s5p_ehci_remove(struct platform_device *pdev)
>>         usb_remove_hcd(hcd);
>>
>>         if (pdata && pdata->phy_exit)
>> -               pdata->phy_exit(pdev, S5P_USB_PHY_HOST);
>> +               pdata->phy_exit(pdev, USB_PHY_TYPE_HOST);
>>
>>         clk_disable_unprepare(s5p_ehci->clk);
>>
>> @@ -229,7 +230,7 @@ static int s5p_ehci_suspend(struct device *dev)
>>         rc = ehci_suspend(hcd, do_wakeup);
>>
>>         if (pdata && pdata->phy_exit)
>> -               pdata->phy_exit(pdev, S5P_USB_PHY_HOST);
>> +               pdata->phy_exit(pdev, USB_PHY_TYPE_HOST);
>>
>>         clk_disable_unprepare(s5p_ehci->clk);
>>
>> @@ -246,7 +247,7 @@ static int s5p_ehci_resume(struct device *dev)
>>         clk_prepare_enable(s5p_ehci->clk);
>>
>>         if (pdata && pdata->phy_init)
>> -               pdata->phy_init(pdev, S5P_USB_PHY_HOST);
>> +               pdata->phy_init(pdev, USB_PHY_TYPE_HOST);
>>
>>         /* DMA burst Enable */
>>         writel(EHCI_INSNREG00_ENABLE_DMA_BURST, EHCI_INSNREG00(hcd->regs));
>> diff --git a/drivers/usb/host/ohci-exynos.c b/drivers/usb/host/ohci-exynos.c
>> index aa3b884..804fb62 100644
>> --- a/drivers/usb/host/ohci-exynos.c
>> +++ b/drivers/usb/host/ohci-exynos.c
>> @@ -15,6 +15,7 @@
>>  #include <linux/of.h>
>>  #include <linux/platform_device.h>
>>  #include <linux/platform_data/usb-exynos.h>
>> +#include <linux/usb/samsung_usb_phy.h>
>>  #include <plat/usb-phy.h>
>>
>>  struct exynos_ohci_hcd {
>> @@ -153,7 +154,7 @@ static int exynos_ohci_probe(struct platform_device *pdev)
>>         }
>>
>>         if (pdata->phy_init)
>> -               pdata->phy_init(pdev, S5P_USB_PHY_HOST);
>> +               pdata->phy_init(pdev, USB_PHY_TYPE_HOST);
>>
>>         ohci = hcd_to_ohci(hcd);
>>         ohci_hcd_init(ohci);
>> @@ -184,7 +185,7 @@ static int exynos_ohci_remove(struct platform_device *pdev)
>>         usb_remove_hcd(hcd);
>>
>>         if (pdata && pdata->phy_exit)
>> -               pdata->phy_exit(pdev, S5P_USB_PHY_HOST);
>> +               pdata->phy_exit(pdev, USB_PHY_TYPE_HOST);
>>
>>         clk_disable_unprepare(exynos_ohci->clk);
>>
>> @@ -229,7 +230,7 @@ static int exynos_ohci_suspend(struct device *dev)
>>         clear_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags);
>>
>>         if (pdata && pdata->phy_exit)
>> -               pdata->phy_exit(pdev, S5P_USB_PHY_HOST);
>> +               pdata->phy_exit(pdev, USB_PHY_TYPE_HOST);
>>
>>         clk_disable_unprepare(exynos_ohci->clk);
>>
>> @@ -249,7 +250,7 @@ static int exynos_ohci_resume(struct device *dev)
>>         clk_prepare_enable(exynos_ohci->clk);
>>
>>         if (pdata && pdata->phy_init)
>> -               pdata->phy_init(pdev, S5P_USB_PHY_HOST);
>> +               pdata->phy_init(pdev, USB_PHY_TYPE_HOST);
>>
>>         ohci_resume(hcd, false);
>>
>> diff --git a/include/linux/usb/samsung_usb_phy.h b/include/linux/usb/samsung_usb_phy.h
>> new file mode 100644
>> index 0000000..9167826
>> --- /dev/null
>> +++ b/include/linux/usb/samsung_usb_phy.h
>> @@ -0,0 +1,16 @@
>> +/*
>> + * Copyright (C) 2012 Samsung Electronics Co.Ltd
>> + *             http://www.samsung.com/
>> + *
>> + * Defines phy types for samsung usb phy controllers - HOST or DEIVCE.
>> + *
>> + * This program is free software; you can redistribute  it and/or modify it
>> + * under  the terms of  the GNU General  Public License as published by the
>> + * Free Software Foundation;  either version 2 of the  License, or (at your
>> + * option) any later version.
>> + */
>> +
>> +enum samsung_usb_phy_type {
>> +       USB_PHY_TYPE_DEVICE,
>> +       USB_PHY_TYPE_HOST,
>> +};
>> --
>> 1.7.6.5
>>
>> _______________________________________________
>> devicetree-discuss mailing list
>> devicetree-discuss@lists.ozlabs.org
>> https://lists.ozlabs.org/listinfo/devicetree-discuss
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss



-- 
Thanks & Regards
Vivek
