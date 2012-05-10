Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758512Ab2EJJ7z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 05:59:55 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37445 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757498Ab2EJJ7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 05:59:53 -0400
MIME-Version: 1.0
In-Reply-To: <CAJuYYwQqPEDP3ygkjOjeAwUr--M13KSB7JdYm8Tiok5BvJbruw@mail.gmail.com>
References: <1335935266-25289-1-git-send-email-thomas.abraham@linaro.org>
	<1335935266-25289-4-git-send-email-thomas.abraham@linaro.org>
	<CAH9JG2XJk+CJNFiZu0C-TK_aj2gRPP5czUvTzEeDBXNejR6qvA@mail.gmail.com>
	<CAJuYYwQqPEDP3ygkjOjeAwUr--M13KSB7JdYm8Tiok5BvJbruw@mail.gmail.com>
Date: Thu, 10 May 2012 18:59:51 +0900
X-Google-Sender-Auth: e4-M8zeAmCuJNGNIUSrVht_ZKHA
Message-ID: <CAH9JG2W-KFH9bDkq14-KayJ30Q3Uj04mWUEXr7AdVa6CFbi6eA@mail.gmail.com>
Subject: Re: [PATCH 3/7] mmc: dw_mmc: add device tree support
From: Kyungmin Park <kmpark@infradead.org>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: linux-mmc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-samsung-soc@vger.kernel.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, kgene.kim@samsung.com, cjb@laptop.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/10/12, Thomas Abraham <thomas.abraham@linaro.org> wrote:
> Dear Mr. Park,
>
> On 2 May 2012 12:25, Kyungmin Park <kmpark@infradead.org> wrote:
>> Hi,
>>
>> On 5/2/12, Thomas Abraham <thomas.abraham@linaro.org> wrote:
>>> Add device tree based discovery support.
>>>
>>> Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
>>> ---
>>>  .../devicetree/bindings/mmc/synposis-dw-mshc.txt   |   85 +++++++++
>>>  drivers/mmc/host/dw_mmc-pltfm.c                    |   24 +++
>>>  drivers/mmc/host/dw_mmc.c                          |  181
>>> +++++++++++++++++++-
>>>  drivers/mmc/host/dw_mmc.h                          |   10 +
>>>  include/linux/mmc/dw_mmc.h                         |    2 +
>>>  5 files changed, 296 insertions(+), 6 deletions(-)
>>>  create mode 100644
>>> Documentation/devicetree/bindings/mmc/synposis-dw-mshc.txt
>>>
>>> diff --git a/Documentation/devicetree/bindings/mmc/synposis-dw-mshc.txt
>>> b/Documentation/devicetree/bindings/mmc/synposis-dw-mshc.txt
>>> new file mode 100644
>>> index 0000000..c1ed70e
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/mmc/synposis-dw-mshc.txt
>>> @@ -0,0 +1,85 @@
>>> +* Synopsis Designware Mobile Storage Host Controller
>>> +
>>> +The Synopsis designware mobile storage host controller is used to
>>> interface
>>> +a SoC with storage medium such as eMMC or SD/MMC cards.
>>> +
>>> +Required Properties:
>>> +
>>> +* compatible: should be one of the following
>>> +     - synopsis,dw-mshc: for controllers compliant with synopsis
>>> dw-mshc.
>> I googled the "Synopsis Designware Mobile Storage Host Controller" and
>> Synopsis released it as this name. but still I like the 'dw-mmc'
>> instead of'dw-mshc'.
>
> Ok. Synopsis abbreviates this controller as MSHC in their datasheets
> available online. Since device tree is more about describing the
> hardware, using MSHC as the abbreviation will help with correlating
> hardware specs with the dts file. So I would prefer to continue using
> mshc as the abbreviation.

Then why author of this file uses "dw-mmc" instead of "dw-mshc"? and
it uses 'dw_mci' prefix at functions. I just worried and don't want to
give confusion to users who uses this device.

>
>>> +
>>> +* reg: physical base address of the dw-mshc controller and size of its
>>> memory
>>> +  region.
>>> +
>>> +* interrupts: interrupt specifier for the controller. The format and
>>> value
>>> of
>>> +  the interrupt specifier depends on the interrupt parent for the
>>> controller.
>>> +
>>> +# Slots: The slot specific information are contained within child-nodes
>>> with
>>> +  each child-node representing a supported slot. There should be
>>> atleast
>>> one
>>> +  child node representing a card slot. The name of the slot child node
>>> should
>>> +  be 'slot{n}' where n is the unique number of the slot connnected to
>>> the
>>> +  controller. The following are optional properties which can be
>>> included
>>> in
>>> +  the slot child node.
>>> +
>>> +     * bus-width: specifies the width of the data bus connected from
>>> the
>>> +       controller to the card slot. The value should be 1, 4 or 8. In
>>> case
>>> +       this property is not specified, a default value of 1 is assumed
>>> for
>>> +       this property.
>>> +
>>> +     * cd-gpios: specifies the card detect gpio line. The format of the
>>> +       gpio specifier depends on the gpio controller.
>>> +
>>> +     * wp-gpios: specifies the write protect gpio line. The format of
>>> the
>>> +       gpio specifier depends on the gpio controller.
>>> +
>>> +     * gpios: specifies a list of gpios used for command, clock and
>>> data
>>> +       bus. The first gpio is the command line and the second gpio is
>>> the
>>> +       clock line. The rest of the gpios (depending on the bus-width
>>> +       property) are the data lines in no particular order. The format
>>> of
>>> +       the gpio specifier depends on the gpio controller.
>>> +
>>> +Optional properties:
>>> +
>>> +* fifo-depth: The maximum size of the tx/rx fifo's. If this property is
>>> not
>>> +  specified, the default value of the fifo size is determined from the
>>> +  controller registers.
>>> +
>>> +*  card-detect-delay: Delay in milli-seconds before detecting card
>>> after
>>> card
>>> +   insert event. The default value is 0.
>>> +
>>> +* supports-highspeed: Enables support for high speed cards (upto 50MHz)
>>> +
>>> +* card-detection-broken: The card detection functionality is not
>>> available
>>> on
>>> +  any of the slots.
>>> +
>>> +* no-write-protect: The write protect pad of the controller is not
>>> connected
>>> +  to the write protect pin on the slot.
>>> +
>>> +Example:
>>> +
>>> +  The MSHC controller node can be split into two portions, SoC specific
>>> and
>>> +  board specific portions as listed below.
>>> +
>>> +     dwmmc0@12200000 {
>>> +             compatible = "synopsis,dw-mshc";
>>> +             reg = <0x12200000 0x1000>;
>>> +             interrupts = <0 75 0>;
>>> +     };
>>> +
>>> +     dwmmc0@12200000 {
>>> +             supports-highspeed;
>>> +             card-detection-broken;
>>> +             no-write-protect;
>>> +             fifo-depth = <0x80>;
>>> +             card-detect-delay = <200>;
>>> +
>>> +             slot0 {
>>> +                     bus-width = <8>;
>>> +                     cd-gpios = <&gpc0 2 2 3 3>;
>>> +                     gpios = <&gpc0 0 2 0 3>, <&gpc0 1 2 0 3>,
>>> +                             <&gpc1 0 2 3 3>, <&gpc1 1 2 3 3>,
>>> +                             <&gpc1 2 2 3 3>, <&gpc1 3 2 3 3>,
>>> +                             <&gpc0 3 2 3 3>, <&gpc0 4 2 3 3>,
>>> +                             <&gpc0 5 2 3 3>, <&gpc0 6 2 3 3>;
>>> +             };
>>> +     };
>>> diff --git a/drivers/mmc/host/dw_mmc-pltfm.c
>>> b/drivers/mmc/host/dw_mmc-pltfm.c
>>> index 92ec3eb..2b2c9bd 100644
>>> --- a/drivers/mmc/host/dw_mmc-pltfm.c
>>> +++ b/drivers/mmc/host/dw_mmc-pltfm.c
>>> @@ -19,8 +19,24 @@
>>>  #include <linux/mmc/host.h>
>>>  #include <linux/mmc/mmc.h>
>>>  #include <linux/mmc/dw_mmc.h>
>>> +#include <linux/of.h>
>>>  #include "dw_mmc.h"
>>>
>>> +#ifdef CONFIG_OF
>>> +static struct dw_mci_drv_data synopsis_drv_data = {
>>> +     .ctrl_type      = DW_MCI_TYPE_SYNOPSIS,
>>> +};
>>> +
>>> +static const struct of_device_id dw_mci_pltfm_match[] = {
>>> +     { .compatible = "synopsis,dw-mshc",
>>> +                     .data = (void *)&synopsis_drv_data, },
>>> +     {},
>>> +};
>>> +MODULE_DEVICE_TABLE(of, dw_mci_pltfm_match);
>>> +#else
>>> +static const struct of_device_id dw_mci_pltfm_match[];
>>> +#endif
>>> +
>>>  static int dw_mci_pltfm_probe(struct platform_device *pdev)
>>>  {
>>>       struct dw_mci *host;
>>> @@ -51,6 +67,13 @@ static int dw_mci_pltfm_probe(struct platform_device
>>> *pdev)
>>>       if (!host->regs)
>>>               goto err_free;
>>>       platform_set_drvdata(pdev, host);
>>> +
>>> +     if (pdev->dev.of_node) {
>>> +             const struct of_device_id *match;
>>> +             match = of_match_node(dw_mci_pltfm_match,
>>> pdev->dev.of_node);
>>> +             host->drv_data = match->data;
>>> +     }
>>> +
>>>       ret = dw_mci_probe(host);
>>>       if (ret)
>>>               goto err_out;
>>> @@ -111,6 +134,7 @@ static struct platform_driver dw_mci_pltfm_driver =
>>> {
>>>       .remove         = __exit_p(dw_mci_pltfm_remove),
>>>       .driver         = {
>>>               .name           = "dw_mmc",
>>> +             .of_match_table = of_match_ptr(dw_mci_pltfm_match),
>>>               .pm             = &dw_mci_pltfm_pmops,
>>>       },
>>>  };
>>> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
>>> index 38cb7f8..bcf66d7 100644
>>> --- a/drivers/mmc/host/dw_mmc.c
>>> +++ b/drivers/mmc/host/dw_mmc.c
>>> @@ -33,9 +33,13 @@
>>>  #include <linux/bitops.h>
>>>  #include <linux/regulator/consumer.h>
>>>  #include <linux/workqueue.h>
>>> +#include <linux/of.h>
>>> +#include <linux/of_gpio.h>
>>>
>>>  #include "dw_mmc.h"
>>>
>>> +#define NUM_PINS(x) (x + 2)
>>> +
>>>  /* Common flag combinations */
>>>  #define DW_MCI_DATA_ERROR_FLAGS      (SDMMC_INT_DTO | SDMMC_INT_DCRC |
>>> \
>>>                                SDMMC_INT_HTO | SDMMC_INT_SBE  | \
>>> @@ -86,6 +90,8 @@ struct idmac_desc {
>>>  struct dw_mci_slot {
>>>       struct mmc_host         *mmc;
>>>       struct dw_mci           *host;
>>> +     int                     wp_gpio;
>>> +     int                     cd_gpio;
>>>
>>>       u32                     ctype;
>>>
>>> @@ -816,6 +822,8 @@ static int dw_mci_get_ro(struct mmc_host *mmc)
>>>               read_only = 0;
>>>       else if (brd->get_ro)
>>>               read_only = brd->get_ro(slot->id);
>>> +     else if (gpio_is_valid(slot->wp_gpio))
>>> +             read_only = gpio_get_value(slot->wp_gpio);
>>>       else
>>>               read_only =
>>>                       mci_readl(slot->host, WRTPRT) & (1 << slot->id) ? 1
>>> : 0;
>>> @@ -837,6 +845,8 @@ static int dw_mci_get_cd(struct mmc_host *mmc)
>>>               present = 1;
>>>       else if (brd->get_cd)
>>>               present = !brd->get_cd(slot->id);
>>> +     else if (gpio_is_valid(slot->cd_gpio))
>>> +             present = gpio_get_value(slot->cd_gpio);
>>>       else
>>>               present = (mci_readl(slot->host, CDETECT) & (1 <<
>>> slot->id))
>>>                       == 0 ? 1 : 0;
>>> @@ -1747,6 +1757,96 @@ static void dw_mci_work_routine_card(struct
>>> work_struct *work)
>>>       }
>>>  }
>>>
>>> +#ifdef CONFIG_OF
>>> +static struct device_node *dw_mci_of_find_slot_node(struct device *dev,
>>> u8
>>> slot)
>>> +{
>>> +     struct device_node *np;
>>> +     char name[7];
>>> +
>>> +     if (!dev || !dev->of_node)
>>> +             return NULL;
>>> +
>>> +     for_each_child_of_node(dev->of_node, np) {
>>> +             sprintf(name, "slot%d", slot);
>>> +             if (!strcmp(name, np->name))
>>> +                     return np;
>>> +     }
>>> +     return NULL;
>>> +}
>>> +
>>> +static u32 dw_mci_of_get_bus_wd(struct device *dev, u8 slot)
>>> +{
>>> +     struct device_node *np = dw_mci_of_find_slot_node(dev, slot);
>>> +     u32 bus_wd = 1;
>>> +
>>> +     if (!np)
>>> +             return 1;
>>> +
>>> +     if (of_property_read_u32(np, "bus-width", &bus_wd))
>>> +             dev_err(dev, "bus-width property not found, assuming
>>> width"
>>> +                             " as 1\n");
>>> +     return bus_wd;
>>> +}
>>> +
>>> +static int dw_mci_of_setup_bus(struct dw_mci *host, u8 slot, u32
>>> bus_wd)
>>> +{
>>> +     struct device_node *np = dw_mci_of_find_slot_node(&host->dev,
>>> slot);
>>> +     int idx, gpio, ret;
>>> +
>>> +     for (idx = 0; idx < NUM_PINS(bus_wd); idx++) {
>>> +             gpio = of_get_gpio(np, idx);
>>> +             if (!gpio_is_valid(gpio)) {
>>> +                     dev_err(&host->dev, "invalid gpio: %d\n", gpio);
>>> +                     return -EINVAL;
>>> +             }
>>> +
>>> +             ret = devm_gpio_request(&host->dev, gpio, "dw-mci-bus");
>>> +             if (ret) {
>>> +                     dev_err(&host->dev, "gpio [%d] request failed\n",
>>> gpio);
>>> +                     return -EBUSY;
>>> +             }
>>> +     }
>>> +
>>> +     host->slot[slot]->wp_gpio = -1;
>>> +     gpio = of_get_named_gpio(np, "wp_gpios", 0);
>>> +     if (!gpio_is_valid(gpio)) {
>>> +             dev_info(&host->dev, "wp gpio not available");
>>> +     } else {
>>> +             ret = devm_gpio_request(&host->dev, gpio, "dw-mci-wp");
>>> +             if (ret)
>>> +                     dev_info(&host->dev, "gpio [%d] request failed\n",
>>> +                                             gpio);
>>> +             else
>>> +                     host->slot[slot]->wp_gpio = gpio;
>>> +     }
>>> +
>>> +     host->slot[slot]->cd_gpio = -1;
>>> +     gpio = of_get_named_gpio(np, "cd-gpios", 0);
>>> +     if (!gpio_is_valid(gpio)) {
>>> +             dev_info(&host->dev, "cd gpio not available");
>>> +     } else {
>>> +             ret = devm_gpio_request(&host->dev, gpio, "dw-mci-cd");
>>> +             if (ret)
>>> +                     dev_err(&host->dev, "gpio [%d] request failed\n",
>>> gpio);
>>> +             else
>>> +                     host->slot[slot]->cd_gpio = gpio;
>>> +     }
>>> +
>>> +     return 0;
>>> +}
>>> +
>>> +#else /* CONFIG_OF */
>>> +static u32 dw_mci_of_get_bus_wd(struct device *dev, u8 slot)
>>> +{
>>> +     return 1;
>>> +}
>>> +
>>> +static int dw_mci_of_setup_bus(struct dw_mci *host, u8 slot, u32
>>> bus_wd)
>>> +{
>>> +     return -EINVAL;
>>> +}
>>> +#endif /* CONFIG_OF */
>>> +
>>>  static int __init dw_mci_init_slot(struct dw_mci *host, unsigned int
>>> id)
>>>  {
>>>       struct mmc_host *mmc;
>>> @@ -1760,6 +1860,7 @@ static int __init dw_mci_init_slot(struct dw_mci
>>> *host, unsigned int id)
>>>       slot->id = id;
>>>       slot->mmc = mmc;
>>>       slot->host = host;
>>> +     host->slot[id] = slot;
>>>
>>>       mmc->ops = &dw_mci_ops;
>>>       mmc->f_min = DIV_ROUND_UP(host->bus_hz, 510);
>>> @@ -1780,12 +1881,21 @@ static int __init dw_mci_init_slot(struct dw_mci
>>> *host, unsigned int id)
>>>       if (host->pdata->caps)
>>>               mmc->caps = host->pdata->caps;
>>>
>>> +     mmc->caps |= host->drv_data->caps;
>>> +
>>>       if (host->pdata->caps2)
>>>               mmc->caps2 = host->pdata->caps2;
>>>
>>> -     if (host->pdata->get_bus_wd)
>>> +     if (host->pdata->get_bus_wd) {
>>>               if (host->pdata->get_bus_wd(slot->id) >= 4)
>>>                       mmc->caps |= MMC_CAP_4_BIT_DATA;
>>> +     } else if (host->dev.of_node) {
>>> +             unsigned int bus_width;
>>> +             bus_width = dw_mci_of_get_bus_wd(&host->dev, slot->id);
>>> +             if (bus_width >= 4)
>>> +                     mmc->caps |= MMC_CAP_4_BIT_DATA;
>> In case of bus_width has 8; then how to handle it? maybe it's missing
>> one.
>
>
> Yes, this was not correct. I will fix this. Thanks for pointing this out.
>
>
>>> +             dw_mci_of_setup_bus(host, slot->id, bus_width);
>>> +     }
>>>
>>>       if (host->pdata->quirks & DW_MCI_QUIRK_HIGHSPEED)
>>>               mmc->caps |= MMC_CAP_SD_HIGHSPEED | MMC_CAP_MMC_HIGHSPEED;
>>> @@ -1830,7 +1940,6 @@ static int __init dw_mci_init_slot(struct dw_mci
>>> *host, unsigned int id)
>>>       else
>>>               clear_bit(DW_MMC_CARD_PRESENT, &slot->flags);
>>>
>>> -     host->slot[id] = slot;
>>>       mmc_add_host(mmc);
>>>
>>>  #if defined(CONFIG_DEBUG_FS)
>>> @@ -1923,15 +2032,75 @@ static bool mci_wait_reset(struct device *dev,
>>> struct dw_mci *host)
>>>       return false;
>>>  }
>>>
>>> +#ifdef CONFIG_OF
>>> +static struct dw_mci_of_quirks {
>>> +     char *quirk;
>>> +     int id;
>>> +} of_quriks[] = {
>>> +     {
>>> +             .quirk  = "supports-highspeed",
>>> +             .id     = DW_MCI_QUIRK_HIGHSPEED,
>>> +     }, {
>>> +             .quirk  = "card-detection-broken",
>>> +             .id     = DW_MCI_QUIRK_BROKEN_CARD_DETECTION,
>>> +     }, {
>>> +             .quirk  = "no-write-protect",
>>> +             .id     = DW_MCI_QUIRK_NO_WRITE_PROTECT,
>>> +     },
>>> +     { }
>>> +};
>>> +
>>> +static struct dw_mci_board *dw_mci_parse_dt(struct dw_mci *host)
>>> +{
>>> +     struct dw_mci_board *pdata;
>>> +     struct device *dev = &host->dev;
>>> +     struct device_node *np = dev->of_node, *slot;
>>> +     u32 timing[3];
>>> +     int idx, cnt;
>>> +
>>> +     pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
>>> +     if (!pdata) {
>>> +             dev_err(dev, "could not allocate memory for pdata\n");
>>> +             return ERR_PTR(-ENOMEM);
>>> +     }
>>> +
>>> +     /* find out number of slots supported */
>>> +     for_each_child_of_node(np, slot)
>>> +             pdata->num_slots++;
>>> +
>>> +     /* get quirks */
>>> +     cnt = sizeof(of_quriks) / sizeof(struct dw_mci_of_quirks);
>>> +     for (idx = 0; idx < cnt; idx++)
>>> +             if (of_get_property(np, of_quriks[idx].quirk, NULL))
>>> +                     pdata->quirks |= of_quriks[idx].id;
>>> +
>>> +     if (of_property_read_u32(np, "fifo-depth", &pdata->fifo_depth))
>>> +             dev_info(dev, "fifo-depth property not found, using "
>>> +                             "value of FIFOTH register as default\n");
>>> +
>>> +     of_property_read_u32(np, "card-detect-delay",
>>> &pdata->detect_delay_ms);
>>> +
>>> +     return pdata;
>>> +}
>>> +
>>> +#else /* CONFIG_OF */
>>> +static struct dw_mci_board *dw_mci_parse_dt(struct dw_mci *host)
>>> +{
>>> +     return ERR_PTR(-EINVAL);
>>> +}
>>> +#endif /* CONFIG_OF */
>>> +
>>>  int dw_mci_probe(struct dw_mci *host)
>>>  {
>>>       int width, i, ret = 0;
>>>       u32 fifo_size;
>>>
>>> -     if (!host->pdata || !host->pdata->init) {
>>> -             dev_err(&host->dev,
>>> -                     "Platform data must supply init function\n");
>>> -             return -ENODEV;
>>> +     if (!host->pdata) {
>>> +             host->pdata = dw_mci_parse_dt(host);
>>> +             if (IS_ERR(host->pdata)) {
>>> +                     dev_err(&host->dev, "platform data not
>>> available\n");
>>> +                     return -EINVAL;
>>> +             }
>>>       }
>>>
>>>       if (!host->pdata->select_slot && host->pdata->num_slots > 1) {
>>> diff --git a/drivers/mmc/host/dw_mmc.h b/drivers/mmc/host/dw_mmc.h
>>> index 15c27e1..8b8862b 100644
>>> --- a/drivers/mmc/host/dw_mmc.h
>>> +++ b/drivers/mmc/host/dw_mmc.h
>>> @@ -182,4 +182,14 @@ extern int dw_mci_suspend(struct dw_mci *host);
>>>  extern int dw_mci_resume(struct dw_mci *host);
>>>  #endif
>>>
>>> +/* Variations in the dw_mci controller */
>>> +#define DW_MCI_TYPE_SYNOPSIS         0
>>> +#define DW_MCI_TYPE_EXYNOS5250               1 /* Samsung Exynos5250
>>> Extensions */
>> Um. it's not good idea to add specific SOC version. And as you know,
>> exynos4 series has this controller.
>
> There are some differences between the Exynos4 and Exynos5 mshc
> controllers. For instance, the DIVRATIO field in the CLKSEL register
> is available only in Exynos5 and there are 8 phase shift values in
> Exynos5 when compared to 4 phase shift values in Exynos4. Likewise,
> there are some other differences. So to handle these specific
> implementations, we need to define types (or variants) of the
> controller. Using SoC names for the type would help in readability of
> the different types of implementations that are defined. So I would
> prefer to continue using SoC names for this.

You mean if it supports the exynos4, then it should be add exynos4 type?

Thank you,
Kyungmin Park
>
> Thanks,
> Thomas.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
