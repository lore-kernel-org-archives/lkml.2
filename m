Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687Ab1ITOu5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 10:50:57 -0400
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:43084 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750910Ab1ITOuz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 10:50:55 -0400
MIME-Version: 1.0
In-Reply-To: <4E77A717.8020504@ti.com>
References: <1314255697-15411-1-git-send-email-keshava_mgowda@ti.com>
	<1314255697-15411-2-git-send-email-keshava_mgowda@ti.com>
	<4E70DB58.9070901@ti.com>
	<CAP05o4KG36-Aa_KeyYe34Rr7E4nYK6w3WB57GzTw24M6PKFsuw@mail.gmail.com>
	<CAP05o4LbG4xinrkdztJWdO3bMj0WQtEBsOLp7oJ9W0SYGE1fmg@mail.gmail.com>
	<4E77A717.8020504@ti.com>
Date: Tue, 20 Sep 2011 20:20:53 +0530
Message-ID: <CAP05o4+=XPr26b6RY6f5BC3x31vCFdsfT90Da=vqo7HkbzTb2A@mail.gmail.com>
Subject: Re: [PATCH 1/5 v8] arm: omap: usb: ehci and ohci hwmod structures for omap4
From: "Munegowda, Keshava" <keshava_mgowda@ti.com>
To: "Cousson, Benoit" <b-cousson@ti.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
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
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 2:03 AM, Cousson, Benoit <b-cousson@ti.com> wrote:
> OK, it looks like the second half of the answer was in a second email...
> that makes sense:-)
>
> On 9/15/2011 9:22 AM, Munegowda, Keshava wrote:
>>
>> On Thu, Sep 15, 2011 at 11:25 AM, Munegowda, Keshava
>> <keshava_mgowda@ti.com>  wrote:
>>>
>>> On Wed, Sep 14, 2011 at 10:20 PM, Cousson, Benoit<b-cousson@ti.com>
>>>  wrote:
>>>>
>>>> Hi Keshava,
>>>>
>>>> On 8/25/2011 9:01 AM, Munegowda, Keshava wrote:
>>>>>
>>>>> From: Benoit Cousson<b-cousson@ti.com>
>>>>>
>>>>> Following 4 hwmod structures are added:
>>>>> UHH hwmod of usbhs with uhh base address and functional clock,
>>>>> EHCI hwmod with irq and base address,
>>>>> OHCI hwmod with irq and base address,
>>>>> TLL hwmod of usbhs with the TLL base address and irq.
>>>>>
>>>>> Signed-off-by: Benoit Cousson<b-cousson@ti.com>
>>>>
>>>> That version is really different compared to my original patch, so you
>>>> should highlight the diff you introduced.
>>
>> Since there are too many changes are done compare to your original
>> patch; i prefer keep a single patch,rather
>> keeping your original patch and my changes are another patch.
>
> This is not really what I was asking for. You changed at least 30% of the
> original patch without mentioning anything in the changelog.
> You should at least add a history to clarify what part you edited / added
> compared to the original.
>
>>>>> Signed-off-by: Keshava Munegowda<keshava_mgowda@ti.com>
>>>>> ---
>>>>>   arch/arm/mach-omap2/omap_hwmod_44xx_data.c |  247
>>>>> ++++++++++++++++++++++++++++
>>>>>   1 files changed, 247 insertions(+), 0 deletions(-)
>>>>>
>>>>> diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
>>>>> b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
>>>>> index 6201422..0bc01dd 100644
>>>>> --- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
>>>>> +++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
>>>>> @@ -68,6 +68,10 @@ static struct omap_hwmod omap44xx_mmc2_hwmod;
>>>>>   static struct omap_hwmod omap44xx_mpu_hwmod;
>>>>>   static struct omap_hwmod omap44xx_mpu_private_hwmod;
>>>>>   static struct omap_hwmod omap44xx_usb_otg_hs_hwmod;
>>>>> +static struct omap_hwmod omap44xx_usb_host_hs_hwmod;
>>>>> +static struct omap_hwmod omap44xx_usbhs_ohci_hwmod;
>>>>> +static struct omap_hwmod omap44xx_usbhs_ehci_hwmod;
>>>>> +static struct omap_hwmod omap44xx_usb_tll_hs_hwmod;
>>>>
>>>> None of the 3 last entries are master, and thus should not need any
>>>> backward declaration.
>>
>> yes, I will make this change.
>
> But you didn't...

If I remove these backward declaration It is causing compilation error;
This is because omap44xx_l4_cfg__usbhs_ohci structures includes
omap44xx_usbhs_ohci_hwmod structure and then this structure
omap44xx_usbhs_ohci_hwmod
is defined; you need backward declaration;
please let me know if i am missing anything here.


>>>>>   /*
>>>>>    * Interconnects omap_hwmod structures
>>>>> @@ -5336,6 +5340,245 @@ static struct omap_hwmod
>>>>> omap44xx_wd_timer3_hwmod = {
>>>>>       .omap_chip      = OMAP_CHIP_INIT(CHIP_IS_OMAP4430),
>>>>>   };
>>>>>
>>>>> +/*
>>>>> + * 'usb_host_hs' class
>>>>> + * high-speed multi-port usb host controller
>>>>> + */
>>>>> +static struct omap_hwmod_ocp_if omap44xx_usb_host_hs__l3_main_2 = {
>>>>> +     .master         =&omap44xx_usb_host_hs_hwmod,
>>>>> +     .slave          =&omap44xx_l3_main_2_hwmod,
>>>>> +     .clk            = "l3_div_ck",
>>>>> +     .user           = OCP_USER_MPU | OCP_USER_SDMA,
>>>>> +};
>>>>> +
>>>>> +static struct omap_hwmod_class_sysconfig omap44xx_usb_host_hs_sysc = {
>>>>> +     .rev_offs       = 0x0000,
>>>>> +     .sysc_offs      = 0x0010,
>>>>> +     .syss_offs      = 0x0014,
>>>>> +     .sysc_flags     = (SYSC_HAS_MIDLEMODE | SYSC_HAS_SIDLEMODE),
>>>>> +     .idlemodes      = (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
>>>>> +                             SIDLE_SMART_WKUP | MSTANDBY_FORCE |
>>>>> +                             MSTANDBY_NO | MSTANDBY_SMART |
>>>>> +                             MSTANDBY_SMART_WKUP),
>>>>
>>>> Minor, but it should be:
>>>> +       .idlemodes      = (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
>>>> +                          SIDLE_SMART_WKUP | MSTANDBY_FORCE |
>>>> MSTANDBY_NO |
>>>> +                          MSTANDBY_SMART | MSTANDBY_SMART_WKUP),
>>>>
>>>>> +     .sysc_fields    =&omap_hwmod_sysc_type2,
>>>>> +};
>>>>> +
>>>>> +static struct omap_hwmod_class omap44xx_usb_host_hs_hwmod_class = {
>>>>> +     .name = "usbhs_uhh",
>>>>> +     .sysc =&omap44xx_usb_host_hs_sysc,
>>>>> +};
>>>>> +
>>>>> +static struct omap_hwmod_ocp_if *omap44xx_usb_host_hs_masters[] = {
>>>>> +&omap44xx_usb_host_hs__l3_main_2,
>>>>> +};
>>>>> +
>>>>> +static struct omap_hwmod_addr_space omap44xx_usb_host_hs_addrs[] = {
>>>>> +     {
>>>>> +             .name           = "uhh",
>>>>
>>>> In general, there is no name for unique entry. And if you need a name,
>>>> you should find something relevant considering this is local to the hwmod.
>
> No answer and no change on that one.

The usbhs driver internally uses platform_get_resource_byname , hence
it is useful.


>>>>> +             .pa_start       = 0x4a064000,
>>>>> +             .pa_end         = 0x4a0647ff,
>>>>> +             .flags          = ADDR_TYPE_RT
>>>>> +     },
>>>>> +     {} /* Terminating Entry */
>>>>
>>>> That comment is useless. Paul added one space inside the terminator as
>>>> well.
>>>>
>>>>> +};
>>>>> +
>>>>> +static struct omap_hwmod_ocp_if omap44xx_l4_cfg__usb_host_hs = {
>>>>> +     .master         =&omap44xx_l4_cfg_hwmod,
>>>>> +     .slave          =&omap44xx_usb_host_hs_hwmod,
>>>>> +     .clk            = "l4_div_ck",
>>>>> +     .addr           = omap44xx_usb_host_hs_addrs,
>>>>> +     .user           = OCP_USER_MPU | OCP_USER_SDMA,
>>>>> +};
>>>>> +
>>>>> +static struct omap_hwmod_ocp_if *omap44xx_usb_host_hs_slaves[] = {
>>>>> +&omap44xx_l4_cfg__usb_host_hs,
>>>>> +};
>>>>> +
>>>>> +static struct omap_hwmod omap44xx_usb_host_hs_hwmod = {
>>>>> +     .name           = "usbhs_uhh",
>>>>> +     .class          =&omap44xx_usb_host_hs_hwmod_class,
>>>>> +     .clkdm_name     = "l3_init_clkdm",
>>>>> +     .main_clk       = "usb_host_hs_fck",
>>>>> +     .prcm = {
>>>>> +             .omap4 = {
>>>>> +                     .clkctrl_offs =
>>>>> OMAP4_CM_L3INIT_USB_HOST_CLKCTRL_OFFSET,
>>>>> +                     .context_offs =
>>>>> OMAP4_RM_L3INIT_USB_HOST_CONTEXT_OFFSET,
>>>>> +                     .modulemode   = MODULEMODE_SWCTRL,
>>>>> +             },
>>>>> +     },
>>>>> +     .slaves         = omap44xx_usb_host_hs_slaves,
>>>>> +     .slaves_cnt     = ARRAY_SIZE(omap44xx_usb_host_hs_slaves),
>>>>> +     .masters        = omap44xx_usb_host_hs_masters,
>>>>> +     .masters_cnt    = ARRAY_SIZE(omap44xx_usb_host_hs_masters),
>>>>> +     .flags          = HWMOD_SWSUP_SIDLE | HWMOD_SWSUP_MSTANDBY,
>>>>> +     .omap_chip      = OMAP_CHIP_INIT(CHIP_IS_OMAP4430),
>>>>> +};
>>>>> +
>>>>> +/* 'usbhs_ohci' class */
>>>>> +static struct omap_hwmod_class omap44xx_usbhs_ohci_hwmod_class = {
>>>>> +     .name = "usbhs_ohci",
>>>>
>>>> In the context of devicetree and considering what Felipe did for the
>>>> USB3, I'm wondering if you should define hwmods for ohci and ehci.
>>>> I'm not 100% sure it will apply here, but cannot you add the register
>>>> entries inside the usb_host_hs hwmod and create the devices using that?
>>>>
>>>> There is no PRCM entry for them so they do not need to be omap_device.
>>
>>
>> you need , ehci and ohci as a different hwmods, because later we can
>> add the mux to ehc and ochi independently.
>
> So what? Why do you need 2 hwmods for that? cannot you have regular
> platform_device for that purpose?
>
>>>>> +};
>>>>> +
>>>>> +static struct omap_hwmod_irq_info omap44xx_usbhs_ohci_irqs[] = {
>>>>> +     { .name = "ohci-irq", .irq = 76 + OMAP44XX_IRQ_GIC_START },
>>>>
>>>> Same comment that before about address space name.
>>>>
>>>>> +     { .irq = -1 } /* Terminating IRQ */
>>>>> +};
>>>>> +
>>>>> +static struct omap_hwmod_addr_space omap44xx_usbhs_ohci_addrs[] = {
>>>>> +     {
>>>>> +             .name           = "ohci",
>>>>
>>>> Same comment than before.
>>>>
>>>>> +             .pa_start       = 0x4A064800,
>>>>> +             .pa_end         = 0x4A064BFF,
>>>>> +             .flags          = ADDR_MAP_ON_INIT
>>>>
>>>> Why do you need that flag?
>>
>> This address space does not has sysconfig; so hwmod need not to map to
>> this address.
>> driver will to ioremap.
>
> I do agree for the first part, but that does not explain why you did add
> that flag? Have you check the behavior of that flag?
> No using the ADDR_TYPE_RT does not mean you have to add that flag.

In hwmod code, I am seeing that ioremap is done if ADDR_TYPE_RT is set.
But, for ehci and ohci address space , the usbhs driver does it
ioremap indirectly
by child drivers ehci and ohci; hence I feel ADDR_MAP_ON_INIT sufficient.

regards
keshava
