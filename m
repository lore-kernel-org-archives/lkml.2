Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab1ITOft (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 10:35:49 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:59981 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751684Ab1ITOfr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 10:35:47 -0400
MIME-Version: 1.0
In-Reply-To: <4E77AA21.3040304@ti.com>
References: <1316092970-2440-1-git-send-email-keshava_mgowda@ti.com>
	<1316092970-2440-2-git-send-email-keshava_mgowda@ti.com>
	<4E77AA21.3040304@ti.com>
Date: Tue, 20 Sep 2011 20:05:44 +0530
Message-ID: <CAP05o4LE+9pWkePa3d3pMaoCi1g2Wo06-GJ5Ve4pKreMCajHNA@mail.gmail.com>
Subject: Re: [PATCH 1/5 v9] arm: omap: usb: ehci and ohci hwmod structures for omap4
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
        "Sripathy, Vishwanath" <vishwanath.bs@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 2:16 AM, Cousson, Benoit <b-cousson@ti.com> wrote:
> Keshava,
>
> I've just replied to your previous v8 version about the comments you didn't
> take into account.
> I just have one minor nit on that one I missed previously, plus a couple of
> clarifications.
>
> On 9/15/2011 3:22 PM, Munegowda, Keshava wrote:
>>
>> From: Benoit Cousson<b-cousson@ti.com>
>>
>> Following 4 hwmod structures are added:
>> UHH hwmod of usbhs with uhh base address and functional clock,
>> EHCI hwmod with irq and base address,
>> OHCI hwmod with irq and base address,
>> TLL hwmod of usbhs with the TLL base address and irq.
>>
>> Signed-off-by: Benoit Cousson<b-cousson@ti.com>
>> Signed-off-by: Keshava Munegowda<keshava_mgowda@ti.com>
>> ---
>>  arch/arm/mach-omap2/omap_hwmod_44xx_data.c |  249
>> +++++++++++++++++++++++++++-
>>  1 files changed, 248 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
>> b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
>> index 6201422..f06efa6 100644
>> --- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
>> +++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
>> @@ -68,6 +68,10 @@ static struct omap_hwmod omap44xx_mmc2_hwmod;
>>  static struct omap_hwmod omap44xx_mpu_hwmod;
>>  static struct omap_hwmod omap44xx_mpu_private_hwmod;
>>  static struct omap_hwmod omap44xx_usb_otg_hs_hwmod;
>> +static struct omap_hwmod omap44xx_usb_host_hs_hwmod;
>> +static struct omap_hwmod omap44xx_usbhs_ohci_hwmod;
>> +static struct omap_hwmod omap44xx_usbhs_ehci_hwmod;
>> +static struct omap_hwmod omap44xx_usb_tll_hs_hwmod;
>>
>>  /*
>>   * Interconnects omap_hwmod structures
>> @@ -5336,6 +5340,244 @@ static struct omap_hwmod omap44xx_wd_timer3_hwmod
>> = {
>>        .omap_chip      = OMAP_CHIP_INIT(CHIP_IS_OMAP4430),
>>  };
>>
>> +/*
>> + * 'usb_host_hs' class
>> + * high-speed multi-port usb host controller
>> + */
>> +static struct omap_hwmod_ocp_if omap44xx_usb_host_hs__l3_main_2 = {
>> +       .master         =&omap44xx_usb_host_hs_hwmod,
>> +       .slave          =&omap44xx_l3_main_2_hwmod,
>> +       .clk            = "l3_div_ck",
>> +       .user           = OCP_USER_MPU | OCP_USER_SDMA,
>> +};
>> +
>> +static struct omap_hwmod_class_sysconfig omap44xx_usb_host_hs_sysc = {
>> +       .rev_offs       = 0x0000,
>> +       .sysc_offs      = 0x0010,
>> +       .syss_offs      = 0x0014,
>> +       .sysc_flags     = (SYSC_HAS_MIDLEMODE | SYSC_HAS_SIDLEMODE),
>> +       .idlemodes      = (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
>> +                       SIDLE_SMART_WKUP | MSTANDBY_FORCE | MSTANDBY_NO |
>> +                       MSTANDBY_SMART | MSTANDBY_SMART_WKUP),
>> +       .sysc_fields    =&omap_hwmod_sysc_type2,
>> +};
>> +
>> +static struct omap_hwmod_class omap44xx_usb_host_hs_hwmod_class = {
>> +       .name = "usbhs_uhh",
>> +       .sysc =&omap44xx_usb_host_hs_sysc,
>> +};
>> +
>> +static struct omap_hwmod_ocp_if *omap44xx_usb_host_hs_masters[] = {
>> +       &omap44xx_usb_host_hs__l3_main_2,
>> +};
>> +
>> +static struct omap_hwmod_addr_space omap44xx_usb_host_hs_addrs[] = {
>> +       {
>> +               .name           = "uhh",
>> +               .pa_start       = 0x4a064000,
>> +               .pa_end         = 0x4a0647ff,
>> +               .flags          = ADDR_TYPE_RT
>> +       },
>> +       {}
>> +};
>> +
>> +static struct omap_hwmod_ocp_if omap44xx_l4_cfg__usb_host_hs = {
>> +       .master         =&omap44xx_l4_cfg_hwmod,
>> +       .slave          =&omap44xx_usb_host_hs_hwmod,
>> +       .clk            = "l4_div_ck",
>> +       .addr           = omap44xx_usb_host_hs_addrs,
>> +       .user           = OCP_USER_MPU | OCP_USER_SDMA,
>> +};
>> +
>> +static struct omap_hwmod_ocp_if *omap44xx_usb_host_hs_slaves[] = {
>> +       &omap44xx_l4_cfg__usb_host_hs,
>> +};
>> +
>> +static struct omap_hwmod omap44xx_usb_host_hs_hwmod = {
>> +       .name           = "usbhs_uhh",
>> +       .class          =&omap44xx_usb_host_hs_hwmod_class,
>> +       .clkdm_name     = "l3_init_clkdm",
>> +       .main_clk       = "usb_host_hs_fck",
>> +       .prcm = {
>> +               .omap4 = {
>> +                       .clkctrl_offs =
>> OMAP4_CM_L3INIT_USB_HOST_CLKCTRL_OFFSET,
>> +                       .context_offs =
>> OMAP4_RM_L3INIT_USB_HOST_CONTEXT_OFFSET,
>> +                       .modulemode   = MODULEMODE_SWCTRL,
>> +               },
>> +       },
>> +       .slaves         = omap44xx_usb_host_hs_slaves,
>> +       .slaves_cnt     = ARRAY_SIZE(omap44xx_usb_host_hs_slaves),
>> +       .masters        = omap44xx_usb_host_hs_masters,
>> +       .masters_cnt    = ARRAY_SIZE(omap44xx_usb_host_hs_masters),
>> +       .flags          = HWMOD_SWSUP_SIDLE | HWMOD_SWSUP_MSTANDBY,
>
> Why do you need these flags? These flags are reserved for non-standard
> behavior / HW bugs. I know that this IP is full of various bugs, but it will
> be nice to add some explanation in the changelog and a small comment here as
> well.
>
>> +       .omap_chip      = OMAP_CHIP_INIT(CHIP_IS_OMAP4430),
>> +};
>> +
>> +/* 'usbhs_ohci' class */
>> +static struct omap_hwmod_class omap44xx_usbhs_ohci_hwmod_class = {
>> +       .name = "usbhs_ohci",
>> +};
>> +
>> +static struct omap_hwmod_irq_info omap44xx_usbhs_ohci_irqs[] = {
>> +       { .name = "ohci-irq", .irq = 76 + OMAP44XX_IRQ_GIC_START },
>> +       { .irq = -1 }
>> +};
>> +
>> +static struct omap_hwmod_addr_space omap44xx_usbhs_ohci_addrs[] = {
>> +       {
>> +               .name           = "ohci",
>> +               .pa_start       = 0x4A064800,
>> +               .pa_end         = 0x4A064BFF,
>
> Nit: Please use lower case for hexa value. This is applicable for the whole
> patch.
>
>> +               .flags          = ADDR_MAP_ON_INIT
>> +       },
>> +       {}
>> +};
>> +
>> +static struct omap_hwmod_ocp_if omap44xx_l4_cfg__usbhs_ohci = {
>> +       .master         =&omap44xx_l4_cfg_hwmod,
>> +       .slave          =&omap44xx_usbhs_ohci_hwmod,
>> +       .clk            = "l4_div_ck",
>> +       .addr           = omap44xx_usbhs_ohci_addrs,
>> +       .user           = OCP_USER_MPU | OCP_USER_SDMA,
>> +};
>> +
>> +static struct omap_hwmod_ocp_if *omap44xx_usbhs_ohci_slaves[] = {
>> +       &omap44xx_l4_cfg__usbhs_ohci,
>> +};
>> +
>> +static struct omap_hwmod_ocp_if *omap44xx_usbhs_ohci_masters[] = {
>> +       &omap44xx_usb_host_hs__l3_main_2,
>> +};
>> +
>> +static struct omap_hwmod omap44xx_usbhs_ohci_hwmod = {
>> +       .name           = "usbhs_ohci",
>> +       .class          =&omap44xx_usbhs_ohci_hwmod_class,
>> +       .clkdm_name     = "l3_init_clkdm",
>> +       .mpu_irqs       = omap44xx_usbhs_ohci_irqs,
>> +       .slaves         = omap44xx_usbhs_ohci_slaves,
>> +       .slaves_cnt     = ARRAY_SIZE(omap44xx_usbhs_ohci_slaves),
>> +       .masters        = omap44xx_usbhs_ohci_masters,
>> +       .masters_cnt    = ARRAY_SIZE(omap44xx_usbhs_ohci_masters),
>> +       .omap_chip      = OMAP_CHIP_INIT(CHIP_IS_OMAP4430),
>> +       .flags          = HWMOD_INIT_NO_RESET | HWMOD_NO_IDLEST,
>
> Same question about these flags. Why do you need these? Please add some
> explanation.
>
> That comment is applicable for the remaining flags. These flags are probably
> all needed for that kind of IP, but the least you should do is to add some
> explanation.
>
> Thanks,
> Benoit
>

Hi Benoit
         I have posted v10 covering all your comments which you have
mentioned in this mail

regards
keshava
