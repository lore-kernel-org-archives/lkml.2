Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409Ab1ISUdm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 16:33:42 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:43298 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682Ab1ISUdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 16:33:39 -0400
Message-ID: <4E77A717.8020504@ti.com>
Date: Mon, 19 Sep 2011 22:33:27 +0200
From: "Cousson, Benoit" <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: "Munegowda, Keshava" <keshava_mgowda@ti.com>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Balbi, Felipe" <balbi@ti.com>, "Gadiyar, Anand" <gadiyar@ti.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "parthab@india.ti.com" <parthab@india.ti.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "Hilman, Kevin" <khilman@ti.com>, "paul@pwsan.com" <paul@pwsan.com>,
        "johnstul@us.ibm.com" <johnstul@us.ibm.com>,
        "Sripathy, Vishwanath" <vishwanath.bs@ti.com>,
        "Quadros, Roger" <rogerq@ti.com>
Subject: Re: [PATCH 1/5 v8] arm: omap: usb: ehci and ohci hwmod structures
 for omap4
References: <1314255697-15411-1-git-send-email-keshava_mgowda@ti.com> <1314255697-15411-2-git-send-email-keshava_mgowda@ti.com> <4E70DB58.9070901@ti.com> <CAP05o4KG36-Aa_KeyYe34Rr7E4nYK6w3WB57GzTw24M6PKFsuw@mail.gmail.com> <CAP05o4LbG4xinrkdztJWdO3bMj0WQtEBsOLp7oJ9W0SYGE1fmg@mail.gmail.com>
In-Reply-To: <CAP05o4LbG4xinrkdztJWdO3bMj0WQtEBsOLp7oJ9W0SYGE1fmg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, it looks like the second half of the answer was in a second email... 
that makes sense:-)

On 9/15/2011 9:22 AM, Munegowda, Keshava wrote:
> On Thu, Sep 15, 2011 at 11:25 AM, Munegowda, Keshava
> <keshava_mgowda@ti.com>  wrote:
>> On Wed, Sep 14, 2011 at 10:20 PM, Cousson, Benoit<b-cousson@ti.com>  wrote:
>>> Hi Keshava,
>>>
>>> On 8/25/2011 9:01 AM, Munegowda, Keshava wrote:
>>>> From: Benoit Cousson<b-cousson@ti.com>
>>>>
>>>> Following 4 hwmod structures are added:
>>>> UHH hwmod of usbhs with uhh base address and functional clock,
>>>> EHCI hwmod with irq and base address,
>>>> OHCI hwmod with irq and base address,
>>>> TLL hwmod of usbhs with the TLL base address and irq.
>>>>
>>>> Signed-off-by: Benoit Cousson<b-cousson@ti.com>
>>>
>>> That version is really different compared to my original patch, so you should highlight the diff you introduced.
>
> Since there are too many changes are done compare to your original
> patch; i prefer keep a single patch,rather
> keeping your original patch and my changes are another patch.

This is not really what I was asking for. You changed at least 30% of 
the original patch without mentioning anything in the changelog.
You should at least add a history to clarify what part you edited / 
added compared to the original.

>>>> Signed-off-by: Keshava Munegowda<keshava_mgowda@ti.com>
>>>> ---
>>>>    arch/arm/mach-omap2/omap_hwmod_44xx_data.c |  247 ++++++++++++++++++++++++++++
>>>>    1 files changed, 247 insertions(+), 0 deletions(-)
>>>>
>>>> diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
>>>> index 6201422..0bc01dd 100644
>>>> --- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
>>>> +++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
>>>> @@ -68,6 +68,10 @@ static struct omap_hwmod omap44xx_mmc2_hwmod;
>>>>    static struct omap_hwmod omap44xx_mpu_hwmod;
>>>>    static struct omap_hwmod omap44xx_mpu_private_hwmod;
>>>>    static struct omap_hwmod omap44xx_usb_otg_hs_hwmod;
>>>> +static struct omap_hwmod omap44xx_usb_host_hs_hwmod;
>>>> +static struct omap_hwmod omap44xx_usbhs_ohci_hwmod;
>>>> +static struct omap_hwmod omap44xx_usbhs_ehci_hwmod;
>>>> +static struct omap_hwmod omap44xx_usb_tll_hs_hwmod;
>>>
>>> None of the 3 last entries are master, and thus should not need any backward declaration.
>
> yes, I will make this change.

But you didn't...

>>>>    /*
>>>>     * Interconnects omap_hwmod structures
>>>> @@ -5336,6 +5340,245 @@ static struct omap_hwmod omap44xx_wd_timer3_hwmod = {
>>>>        .omap_chip      = OMAP_CHIP_INIT(CHIP_IS_OMAP4430),
>>>>    };
>>>>
>>>> +/*
>>>> + * 'usb_host_hs' class
>>>> + * high-speed multi-port usb host controller
>>>> + */
>>>> +static struct omap_hwmod_ocp_if omap44xx_usb_host_hs__l3_main_2 = {
>>>> +     .master         =&omap44xx_usb_host_hs_hwmod,
>>>> +     .slave          =&omap44xx_l3_main_2_hwmod,
>>>> +     .clk            = "l3_div_ck",
>>>> +     .user           = OCP_USER_MPU | OCP_USER_SDMA,
>>>> +};
>>>> +
>>>> +static struct omap_hwmod_class_sysconfig omap44xx_usb_host_hs_sysc = {
>>>> +     .rev_offs       = 0x0000,
>>>> +     .sysc_offs      = 0x0010,
>>>> +     .syss_offs      = 0x0014,
>>>> +     .sysc_flags     = (SYSC_HAS_MIDLEMODE | SYSC_HAS_SIDLEMODE),
>>>> +     .idlemodes      = (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
>>>> +                             SIDLE_SMART_WKUP | MSTANDBY_FORCE |
>>>> +                             MSTANDBY_NO | MSTANDBY_SMART |
>>>> +                             MSTANDBY_SMART_WKUP),
>>>
>>> Minor, but it should be:
>>> +       .idlemodes      = (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
>>> +                          SIDLE_SMART_WKUP | MSTANDBY_FORCE | MSTANDBY_NO |
>>> +                          MSTANDBY_SMART | MSTANDBY_SMART_WKUP),
>>>
>>>> +     .sysc_fields    =&omap_hwmod_sysc_type2,
>>>> +};
>>>> +
>>>> +static struct omap_hwmod_class omap44xx_usb_host_hs_hwmod_class = {
>>>> +     .name = "usbhs_uhh",
>>>> +     .sysc =&omap44xx_usb_host_hs_sysc,
>>>> +};
>>>> +
>>>> +static struct omap_hwmod_ocp_if *omap44xx_usb_host_hs_masters[] = {
>>>> +&omap44xx_usb_host_hs__l3_main_2,
>>>> +};
>>>> +
>>>> +static struct omap_hwmod_addr_space omap44xx_usb_host_hs_addrs[] = {
>>>> +     {
>>>> +             .name           = "uhh",
>>>
>>> In general, there is no name for unique entry. And if you need a name, you should find something relevant considering this is local to the hwmod.

No answer and no change on that one.

>>>> +             .pa_start       = 0x4a064000,
>>>> +             .pa_end         = 0x4a0647ff,
>>>> +             .flags          = ADDR_TYPE_RT
>>>> +     },
>>>> +     {} /* Terminating Entry */
>>>
>>> That comment is useless. Paul added one space inside the terminator as well.
>>>
>>>> +};
>>>> +
>>>> +static struct omap_hwmod_ocp_if omap44xx_l4_cfg__usb_host_hs = {
>>>> +     .master         =&omap44xx_l4_cfg_hwmod,
>>>> +     .slave          =&omap44xx_usb_host_hs_hwmod,
>>>> +     .clk            = "l4_div_ck",
>>>> +     .addr           = omap44xx_usb_host_hs_addrs,
>>>> +     .user           = OCP_USER_MPU | OCP_USER_SDMA,
>>>> +};
>>>> +
>>>> +static struct omap_hwmod_ocp_if *omap44xx_usb_host_hs_slaves[] = {
>>>> +&omap44xx_l4_cfg__usb_host_hs,
>>>> +};
>>>> +
>>>> +static struct omap_hwmod omap44xx_usb_host_hs_hwmod = {
>>>> +     .name           = "usbhs_uhh",
>>>> +     .class          =&omap44xx_usb_host_hs_hwmod_class,
>>>> +     .clkdm_name     = "l3_init_clkdm",
>>>> +     .main_clk       = "usb_host_hs_fck",
>>>> +     .prcm = {
>>>> +             .omap4 = {
>>>> +                     .clkctrl_offs = OMAP4_CM_L3INIT_USB_HOST_CLKCTRL_OFFSET,
>>>> +                     .context_offs = OMAP4_RM_L3INIT_USB_HOST_CONTEXT_OFFSET,
>>>> +                     .modulemode   = MODULEMODE_SWCTRL,
>>>> +             },
>>>> +     },
>>>> +     .slaves         = omap44xx_usb_host_hs_slaves,
>>>> +     .slaves_cnt     = ARRAY_SIZE(omap44xx_usb_host_hs_slaves),
>>>> +     .masters        = omap44xx_usb_host_hs_masters,
>>>> +     .masters_cnt    = ARRAY_SIZE(omap44xx_usb_host_hs_masters),
>>>> +     .flags          = HWMOD_SWSUP_SIDLE | HWMOD_SWSUP_MSTANDBY,
>>>> +     .omap_chip      = OMAP_CHIP_INIT(CHIP_IS_OMAP4430),
>>>> +};
>>>> +
>>>> +/* 'usbhs_ohci' class */
>>>> +static struct omap_hwmod_class omap44xx_usbhs_ohci_hwmod_class = {
>>>> +     .name = "usbhs_ohci",
>>>
>>> In the context of devicetree and considering what Felipe did for the USB3, I'm wondering if you should define hwmods for ohci and ehci.
>>> I'm not 100% sure it will apply here, but cannot you add the register entries inside the usb_host_hs hwmod and create the devices using that?
>>>
>>> There is no PRCM entry for them so they do not need to be omap_device.
>
>
> you need , ehci and ohci as a different hwmods, because later we can
> add the mux to ehc and ochi independently.

So what? Why do you need 2 hwmods for that? cannot you have regular 
platform_device for that purpose?

>>>> +};
>>>> +
>>>> +static struct omap_hwmod_irq_info omap44xx_usbhs_ohci_irqs[] = {
>>>> +     { .name = "ohci-irq", .irq = 76 + OMAP44XX_IRQ_GIC_START },
>>>
>>> Same comment that before about address space name.
>>>
>>>> +     { .irq = -1 } /* Terminating IRQ */
>>>> +};
>>>> +
>>>> +static struct omap_hwmod_addr_space omap44xx_usbhs_ohci_addrs[] = {
>>>> +     {
>>>> +             .name           = "ohci",
>>>
>>> Same comment than before.
>>>
>>>> +             .pa_start       = 0x4A064800,
>>>> +             .pa_end         = 0x4A064BFF,
>>>> +             .flags          = ADDR_MAP_ON_INIT
>>>
>>> Why do you need that flag?
>
> This address space does not has sysconfig; so hwmod need not to map to
> this address.
> driver will to ioremap.

I do agree for the first part, but that does not explain why you did add 
that flag? Have you check the behavior of that flag?
No using the ADDR_TYPE_RT does not mean you have to add that flag.

>>>> +     },
>>>> +     {}
>>>> +};
>>>> +
>>>> +static struct omap_hwmod_ocp_if omap44xx_l4_cfg__usbhs_ohci = {
>>>> +     .master         =&omap44xx_l4_cfg_hwmod,
>>>> +     .slave          =&omap44xx_usbhs_ohci_hwmod,
>>>> +     .clk            = "l4_div_ck",
>>>> +     .addr           = omap44xx_usbhs_ohci_addrs,
>>>> +     .user           = OCP_USER_MPU | OCP_USER_SDMA,
>>>> +};
>>>> +
>>>> +static struct omap_hwmod_ocp_if *omap44xx_usbhs_ohci_slaves[] = {
>>>> +&omap44xx_l4_cfg__usbhs_ohci,
>>>> +};
>>>> +
>>>> +static struct omap_hwmod_ocp_if *omap44xx_usbhs_ohci_masters[] = {
>>>> +&omap44xx_usb_host_hs__l3_main_2,
>>>> +};
>>>> +
>>>> +static struct omap_hwmod omap44xx_usbhs_ohci_hwmod = {
>>>> +     .name           = "usbhs_ohci",
>>>> +     .class          =&omap44xx_usbhs_ohci_hwmod_class,
>>>> +     .clkdm_name     = "l3_init_clkdm",
>>>> +     .mpu_irqs       = omap44xx_usbhs_ohci_irqs,
>>>> +     .slaves         = omap44xx_usbhs_ohci_slaves,
>>>> +     .slaves_cnt     = ARRAY_SIZE(omap44xx_usbhs_ohci_slaves),
>>>> +     .masters        = omap44xx_usbhs_ohci_masters,
>>>> +     .masters_cnt    = ARRAY_SIZE(omap44xx_usbhs_ohci_masters),
>>>
>>> Assuming you need hwmod entries for that, these master entries are useless and probably wrong.
>>> The TRM just documents 2 ports for usb_host_hs and 1 port for usb_tll_hs.
>
> ports are not specific to usbhs or tll,  port 1 and port2  can be used
> in phy or tll modes.

OK, sorry for the confusion, but I was referring to the ocp ports, 
because slaves and masters are both OCP connections lists.

>>> You will still need the slave for the address space.
>>>
>>>> +     .omap_chip      = OMAP_CHIP_INIT(CHIP_IS_OMAP4430),
>>>> +     .flags          = HWMOD_INIT_NO_RESET | HWMOD_NO_IDLEST,
>>>> +};
>>>> +
>>>> +/* 'usbhs_ehci' class */
>>>> +static struct omap_hwmod_class omap44xx_usbhs_ehci_hwmod_class = {
>>>> +     .name = "usbhs_ehci",
>>>> +};
>>>> +
>>>> +static struct omap_hwmod_irq_info omap44xx_usbhs_ehci_irqs[] = {
>>>> +     { .name = "ehci-irq", .irq = 77 + OMAP44XX_IRQ_GIC_START },
>>>> +     { .irq = -1 } /* Terminating IRQ */
>>>> +};
>>>> +
>>>> +static struct omap_hwmod_addr_space omap44xx_usbhs_ehci_addrs[] = {
>>>> +     {
>>>> +             .name           = "ehci",
>>>> +             .pa_start       = 0x4A064C00,
>>>> +             .pa_end         = 0x4A064FFF,
>>>> +             .flags          = ADDR_MAP_ON_INIT
>>>> +     },
>>>> +     {} /* Terminating Entry */
>>>> +};
>>>> +
>>>> +static struct omap_hwmod_ocp_if omap44xx_l4_cfg__usbhs_ehci = {
>>>> +     .master         =&omap44xx_l4_cfg_hwmod,
>>>> +     .slave          =&omap44xx_usbhs_ehci_hwmod,
>>>> +     .clk            = "l4_div_ck",
>>>> +     .addr           = omap44xx_usbhs_ehci_addrs,
>>>> +     .user           = OCP_USER_MPU | OCP_USER_SDMA,
>>>> +};
>>>> +
>>>> +static struct omap_hwmod_ocp_if *omap44xx_usbhs_ehci_slaves[] = {
>>>> +&omap44xx_l4_cfg__usbhs_ehci,
>>>> +};
>>>> +
>>>> +static struct omap_hwmod_ocp_if *omap44xx_usbhs_ehci_masters[] = {
>>>> +&omap44xx_usb_host_hs__l3_main_2,
>>>> +};
>>>> +
>>>> +
>>>> +static struct omap_hwmod omap44xx_usbhs_ehci_hwmod = {
>>>> +     .name           = "usbhs_ehci",
>>>> +     .class          =&omap44xx_usbhs_ehci_hwmod_class,
>>>> +     .clkdm_name     = "l3_init_clkdm",
>>>> +     .mpu_irqs       = omap44xx_usbhs_ehci_irqs,
>>>> +     .slaves         = omap44xx_usbhs_ehci_slaves,
>>>> +     .slaves_cnt     = ARRAY_SIZE(omap44xx_usbhs_ehci_slaves),
>>>> +     .masters        = omap44xx_usbhs_ehci_masters,
>>>> +     .masters_cnt    = ARRAY_SIZE(omap44xx_usbhs_ehci_masters),
>>>> +     .omap_chip      = OMAP_CHIP_INIT(CHIP_IS_OMAP4430),
>>>> +     .flags          = HWMOD_INIT_NO_RESET | HWMOD_NO_IDLEST,
>>>> +};
>>>> +
>>>> +/*
>>>> + * 'usb_tll_hs' class
>>>> + * usb_tll_hs module is the adapter on the usb_host_hs ports
>>>> + */
>>>> +static struct omap_hwmod_class_sysconfig omap44xx_usb_tll_hs_sysc = {
>>>> +     .rev_offs       = 0x0000,
>>>> +     .sysc_offs      = 0x0010,
>>>> +     .syss_offs      = 0x0014,
>>>> +     .sysc_flags     = (SYSC_HAS_AUTOIDLE | SYSC_HAS_SIDLEMODE |
>>>> +                             SYSC_HAS_SOFTRESET | SYSC_HAS_ENAWAKEUP |
>>>> +                             SYSC_HAS_CLOCKACTIVITY),
>>>> +     .idlemodes      = (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART),
>>>> +     .sysc_fields    =&omap_hwmod_sysc_type1,
>>>> +};
>>>> +
>>>> +static struct omap_hwmod_class omap44xx_usb_tll_hs_hwmod_class = {
>>>> +     .name = "usbhs_tll",
>>>> +     .sysc =&omap44xx_usb_tll_hs_sysc,
>>>> +};
>>>> +
>>>> +static struct omap_hwmod_irq_info omap44xx_usb_tll_hs_irqs[] = {
>>>> +     { .name = "tll-irq", .irq = 78 + OMAP44XX_IRQ_GIC_START },
>>>> +     { .irq = -1 } /* Terminating IRQ */
>>>> +};
>>>> +
>>>> +static struct omap_hwmod_addr_space omap44xx_usb_tll_hs_addrs[] = {
>>>> +     {
>>>> +             .name           = "tll",
>>>> +             .pa_start       = 0x4a062000,
>>>> +             .pa_end         = 0x4a063fff,
>>>> +             .flags          = ADDR_TYPE_RT
>>>> +     },
>>>> +     {} /* Terminating Entry */
>>>> +};
>>>> +
>>>> +static struct omap_hwmod_ocp_if omap44xx_l4_cfg__usb_tll_hs = {
>>>> +     .master         =&omap44xx_l4_cfg_hwmod,
>>>> +     .slave          =&omap44xx_usb_tll_hs_hwmod,
>>>> +     .clk            = "l4_div_ck",
>>>> +     .addr           = omap44xx_usb_tll_hs_addrs,
>>>> +     .user           = OCP_USER_MPU | OCP_USER_SDMA,
>>>> +};
>>>> +
>>>> +static struct omap_hwmod_ocp_if *omap44xx_usb_tll_hs_slaves[] = {
>>>> +&omap44xx_l4_cfg__usb_tll_hs,
>>>> +};
>>>> +
>>>> +static struct omap_hwmod omap44xx_usb_tll_hs_hwmod = {
>>>> +     .name           = "usbhs_tll",
>>>> +     .class          =&omap44xx_usb_tll_hs_hwmod_class,
>>>> +     .clkdm_name     = "l3_init_clkdm",
>>>> +     .mpu_irqs       = omap44xx_usb_tll_hs_irqs,
>>>> +     .main_clk       = "usb_tll_hs_ick",
>>>> +     .prcm = {
>>>> +             .omap4 = {
>>>> +                     .clkctrl_offs = OMAP4_CM_L3INIT_USB_TLL_CLKCTRL_OFFSET,
>>>> +                     .context_offs = OMAP4_RM_L3INIT_USB_TLL_CONTEXT_OFFSET,
>>>> +                     .modulemode   = MODULEMODE_HWCTRL,
>>>> +             },
>>>> +     },
>>>> +     .slaves         = omap44xx_usb_tll_hs_slaves,
>>>> +     .slaves_cnt     = ARRAY_SIZE(omap44xx_usb_tll_hs_slaves),
>>>> +     .flags          = HWMOD_SWSUP_SIDLE,
>>>> +     .omap_chip      = OMAP_CHIP_INIT(CHIP_IS_OMAP4430),
>>>> +};
>>>> +
>>>>    static __initdata struct omap_hwmod *omap44xx_hwmods[] = {
>>>>
>>>>        /* dmm class */
>>>> @@ -5482,6 +5725,10 @@ static __initdata struct omap_hwmod *omap44xx_hwmods[] = {
>>>>        &omap44xx_wd_timer2_hwmod,
>>>>        &omap44xx_wd_timer3_hwmod,
>>>>
>>>> +&omap44xx_usb_host_hs_hwmod,
>>>> +&omap44xx_usbhs_ohci_hwmod,
>>>> +&omap44xx_usbhs_ehci_hwmod,
>>>> +&omap44xx_usb_tll_hs_hwmod,
>>>
>>> This list is ordered, so it should be something like that:
>
> yes, i will do this.

Thanks,
Benoit
