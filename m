Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759577Ab1JGHnS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 03:43:18 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:39000 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751652Ab1JGHnQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 03:43:16 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1110061030490.4611@utopia.booyaka.com>
References: <1317901123-2546-1-git-send-email-keshava_mgowda@ti.com>
	<alpine.DEB.2.00.1110061030490.4611@utopia.booyaka.com>
Date: Fri, 7 Oct 2011 13:13:15 +0530
Message-ID: <CAP05o4Kfo2fjkaSmhu1wERN4BsznMo3EFe9VMLm9gVA9iXcBzg@mail.gmail.com>
Subject: Re: [PATCH 2/5 v13] arm: omap: usb: ehci and ohci hwmod structures
 for omap3
From: "Munegowda, Keshava" <keshava_mgowda@ti.com>
To: Paul Walmsley <paul@pwsan.com>
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, balbi@ti.com, khilman@ti.com,
        b-cousson@ti.com, gadiyar@ti.com, sameo@linux.intel.com,
        parthab@india.ti.com, tony@atomide.com, johnstul@us.ibm.com,
        vishwanath.bs@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 6, 2011 at 10:05 PM, Paul Walmsley <paul@pwsan.com> wrote:
> Hi Keshava,
>
> On Thu, 6 Oct 2011, Keshava Munegowda wrote:
>
>> Following 2 hwmod structures are added
>>     1. usb_host_hs
>>          The hwmod of usbhs with uhh, ehci and ohci base addresses
>>          functional clock and ehci, ohci irqs
>>
>>     2. usb_tll_hs
>>           hwmod of usbhs with the TLL base address and irq.
>>
>> Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>
>> Reviewed-by: Partha Basak <parthab@india.ti.com>
>> ---
>>  arch/arm/mach-omap2/omap_hwmod_3xxx_data.c |  227 ++++++++++++++++++++++++++++
>>  1 files changed, 227 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
>> index 59fdb9f..b8ca690 100644
>> --- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
>> +++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
>> @@ -84,6 +84,8 @@ static struct omap_hwmod omap3xxx_mcbsp4_hwmod;
>
> ...
>
>> +static struct omap_hwmod_ocp_if omap34xx_usb_host_hs__ick = {
>> +     .master         = &omap3xxx_l4_core_hwmod,
>> +     .slave          = &omap34xx_usb_host_hs_hwmod,
>> +     .clk            = "usbhost_ick",
>> +     .addr           = omap34xx_usb_host_hs_addrs,
>> +     .user           = OCP_USER_MPU | OCP_USER_SDMA,
>> +/*
>> + * This clock should be on/off only with main clock; If auto idle is set,
>> + * the usbhs controller prevents the omap to enter in to low power mode,
>> + * hence don't use auto idle here.
>> + */
>> +     .flags          = OCPIF_SWSUP_IDLE,
>
> This is still unclear to me.  Doesn't this interface clock support
> interface clock auto-idle?  If so, then when the UHH's target port is
> forced idle and its initiator port is forced to standby, then shouldn't
> the PRCM automatically idle this interface clock?

Thanks paul;
Now I am seeing that  without  OCPIF_SWSUP_IDLE the system is going to
low power mode but after
adding HWMOD_INIT_NO_RESET flag ;  After adding this flag; I dint
check the system without this flag;
so, PRCM automatically idle this interface clock if UHH target port is
forced idle and force standby.
I can remove it now.  :-)

> Or is there some hardware problem where the PRCM won't auto-idle this
> clock when the UHH is in idle + standby?
>
>> +};
>> +
>
> ...
>
>> +static struct omap_hwmod_ocp_if omap34xx_ick_cfg__usb_tll_hs = {
>> +     .clk            = "usbtll_ick",
>> +     .addr           = omap34xx_usb_tll_hs_addrs,
>> +     .user           = OCP_USER_MPU | OCP_USER_SDMA,
>> +/*
>> + * This clock should be on/off only with main clock; If auto idle is set,
>> + * the usbhs controller prevents the omap to enter in to low power mode,
>> + * hence don't use auto idle here.
>> + */
>> +     .flags          = OCPIF_SWSUP_IDLE,
>
> Same comment here, with the exception of the part about standby since the
> TLL doesn't have an initiator port.

I will remove this also;

regards
keshava
