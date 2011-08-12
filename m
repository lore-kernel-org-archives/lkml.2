Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666Ab1HLIMp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 04:12:45 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:39947 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750932Ab1HLIMm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 04:12:42 -0400
MIME-Version: 1.0
In-Reply-To: <CACVXFVPN0dS0P4rdvAhKKaTr1yuHRE_KbMiL-1PivObt9aGLhw@mail.gmail.com>
References: <1312899309-24067-1-git-send-email-keshava_mgowda@ti.com>
	<1312899309-24067-2-git-send-email-keshava_mgowda@ti.com>
	<1312899309-24067-3-git-send-email-keshava_mgowda@ti.com>
	<CACVXFVMqwzSOSvkq4q6GnR2gso8NuQD4DRumAVesQB=P_8yDaQ@mail.gmail.com>
	<CAP05o4JDz_53k73-yUXn4S3hFNZ=ccEhaee-U53M+M6qm41Y=A@mail.gmail.com>
	<CACVXFVPN0dS0P4rdvAhKKaTr1yuHRE_KbMiL-1PivObt9aGLhw@mail.gmail.com>
Date: Fri, 12 Aug 2011 13:42:32 +0530
Message-ID: <CAP05o4KNWo2B8opzhUVrxJ+SFe-b0iuVuduwxtKwdX-usU2Arg@mail.gmail.com>
Subject: Re: [PATCH 2/5 v4] arm: omap: usb: ehci and ohci hwmod structures for omap3
From: "Munegowda, Keshava" <keshava_mgowda@ti.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, balbi@ti.com, gadiyar@ti.com,
        sameo@linux.intel.com, parthab@india.ti.com, tony@atomide.com,
        khilman@ti.com, b-cousson@ti.com, paul@pwsan.com, johnstul@us.ibm.com,
        vishwanath.bs@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 12, 2011 at 12:55 PM, Ming Lei <tom.leiming@gmail.com> wrote:
> On Fri, Aug 12, 2011 at 1:46 PM, Munegowda, Keshava
> <keshava_mgowda@ti.com> wrote:
>> On Thu, Aug 11, 2011 at 8:53 PM, Ming Lei <tom.leiming@gmail.com> wrote:
>
>>>> +static struct omap_hwmod_class_sysconfig omap34xx_usb_host_hs_sysc = {
>>>> +       .rev_offs       = 0x0000,
>>>> +       .sysc_offs      = 0x0010,
>>>> +       .syss_offs      = 0x0014,
>>>> +       .sysc_flags     = (SYSC_HAS_MIDLEMODE | SYSC_HAS_SIDLEMODE),
>>>
>>> SYSC_HAS_ENAWAKEUP is missed or not needed?
>>
>> not needed. wakeup will through irq-chaining mechanism.
>
> I am wondering how irq-chaining mechanism can wakeup MPU, could you
> describe it in a little detail?
>
> In fact, I have tested usb remote wakeup on rc1 plus your patches on beagle
> xm, seems the usb mouse can't wakeup MPU at all.
>
>>>
>>>> +       .idlemodes      = (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
>>>> +                          MSTANDBY_FORCE | MSTANDBY_NO | MSTANDBY_SMART),
>>>> +       .sysc_fields    = &omap_hwmod_sysc_type1,
>>>> +};
>>>> +
>>>> +static struct omap_hwmod_class omap34xx_usb_host_hs_hwmod_class = {
>>>> +       .name = "usbhs_uhh",
>>>> +       .sysc = &omap34xx_usb_host_hs_sysc,
>>>> +};
>>>> +
>>>> +static struct omap_hwmod_ocp_if *omap34xx_usb_host_hs_masters[] = {
>>>> +       &omap34xx_usb_host_hs__l3_main_2,
>>>> +};
>>>> +
>>>> +static struct omap_hwmod_addr_space omap34xx_usb_host_hs_addrs[] = {
>>>> +       {
>>>> +               .name           = "uhh",
>>>> +               .pa_start       = 0x48064000,
>>>> +               .pa_end         = 0x480643ff,
>>>> +               .flags          = ADDR_TYPE_RT
>>>> +       },
>>>> +       {} /* Terminating Entry */
>>>> +};
>>>> +
>>>> +static struct omap_hwmod_ocp_if omap34xx_l4_cfg__usb_host_hs = {
>>>> +       .master         = &omap3xxx_l4_core_hwmod,
>>>> +       .slave          = &omap34xx_usb_host_hs_hwmod,
>>>> +       .clk            = "l4_ick",
>>>> +       .addr           = omap34xx_usb_host_hs_addrs,
>>>> +       .user           = OCP_USER_MPU | OCP_USER_SDMA,
>>>> +};
>>>
>>> Even USBHOST_L4_ICLK is used only by USBHOST_SICLK, it is better to
>>> define a "usbhost_siclk" clk for consistence with TRM.
>>
>> I dint understand, what is the change you are suggesting?
>
> From 23.2.1 of OMAP35x TRM(Rev. M), USBHOST_SICLK inside
> 'High-speed USB Host controller' is driven by L4 slave interface
> clock, so looks like l4 iclk should be parent of USBHOST_SICLK.
>
> Considered  USBHOST_L4_ICLK is used only by USBHOST_SICLK,
> you may ignore my question about it.
>
> thanks,
> --
> Ming Lei

Thanks Ming Lei

keshava
