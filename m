Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751698Ab1IZO2R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 10:28:17 -0400
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:32823 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751169Ab1IZO2P convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 10:28:15 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1109240101120.22872@utopia.booyaka.com>
References: <1316691479-1849-1-git-send-email-keshava_mgowda@ti.com>
	<1316691479-1849-2-git-send-email-keshava_mgowda@ti.com>
	<1316691479-1849-3-git-send-email-keshava_mgowda@ti.com>
	<alpine.DEB.2.00.1109221115320.10719@utopia.booyaka.com>
	<CAP05o4+Zc2z6sBOX_rQeoDQ9PneypcLRCyBbaaB2m+ZjeXZnaw@mail.gmail.com>
	<alpine.DEB.2.00.1109240101120.22872@utopia.booyaka.com>
Date: Mon, 26 Sep 2011 19:51:40 +0530
Message-ID: <CAP05o4+uwuFL8XNFG-wmUW8voYQ4kywyU9Qn-Mng7kv=TzZm9w@mail.gmail.com>
Subject: Re: [PATCH 2/5 v11] arm: omap: usb: ehci and ohci hwmod structures
 for omap3
From: "Munegowda, Keshava" <keshava_mgowda@ti.com>
To: Paul Walmsley <paul@pwsan.com>
Cc: parthab@india.ti.com, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        b-cousson@ti.com, balbi@ti.com, gadiyar@ti.com, sameo@linux.intel.com,
        tony@atomide.com, khilman@ti.com, johnstul@us.ibm.com,
        vishwanath.bs@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 24, 2011 at 12:45 PM, Paul Walmsley <paul@pwsan.com> wrote:
> On Fri, 23 Sep 2011, Munegowda, Keshava wrote:
>
>> On Thu, Sep 22, 2011 at 11:31 PM, Paul Walmsley <paul@pwsan.com> wrote:
>> >
>> > On Thu, 22 Sep 2011, Keshava Munegowda wrote:
>> >> 4. usb_tll_hs hwmod of usbhs with the TLL base address and irq.
>> >>
>> >> Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>
>> >> Reviewed-by: Partha Basak <parthab@india.ti.com>
>> >> ---
>> >>  arch/arm/mach-omap2/omap_hwmod_3xxx_data.c |  271 ++++++++++++++++++++++++++++
>> >>  1 files changed, 271 insertions(+), 0 deletions(-)
>> >>
>> >> diff --git a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
>> >> index 59fdb9f..d79f728 100644
>> >> --- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
>> >> +++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
>
>> >> +static struct omap_hwmod_ocp_if omap34xx_f128m_cfg__usb_host_hs = {
>> >> +     .clk            = "usbhost_120m_fck",
>> >
>> > This doesn't look right.  This is an interface structure record, so it
>> > should be associated with an interface clock.  Is the hardware really
>> > using the functional clock as the interface clock?  Or, as seems more
>> > likely...
>>
>>
>> Agreed, how about:
>>
>> main clock: usbhost_120m_fck
>> optional f clock: usbhost_48m_fck
>
> Assuming the interface clock is enabled, which one of these clocks is
> needed for UHH register accesses to complete successfully?


it is usbhost_48m_fck ;
so,
main clock: usbhost_48m_fck
optional clock : usbhost_120m_fck

do you agree?

>
>> interface clock: usbhost_ick.
>>
>>
>>
>> >> +     .user           = OCP_USER_MPU,
>> >> +     .flags          = OCPIF_SWSUP_IDLE,
>> >
>> > ... is this just a hack?  OCPIF_SWSUP_IDLE is intended to work around
>> > hardware autoidle bugs only.  Are you sure this shouldn't be defined as an
>> > optional clock instead?
>>
>> yes ! it was causeing resets, hence you this flag.
>
> usbhost_120m_fck is not an interface clock.  That is probably what was
> causing the problem you describe.

yes , you are right ! its not an interface clock.


>
>> >> +static struct omap_hwmod omap34xx_usb_host_hs_hwmod = {
>> >> +     .name           = "usb_host_hs",
>> >> +     .class          = &omap34xx_usb_host_hs_hwmod_class,
>> >> +     .main_clk       = "usbhost_ick",
>> >
>> > Is this really the main clock?  The main clock is the clock that drives
>> > the register logic in the IP block.  Looks to me, based on the integration
>> > document in the 34xx TRM vZR, that this module has a functional clock.  In
>> > general, the only time that the main_clk should be an interface clock is
>> > when the clock is a combined interface and functional clock.  The mailbox
>> > IP block is a classic example.
>>
>> As I mentioned above;  I can make
>>
>> main clock: usbhost_120m_fck
>> optional f clock: usbhost_48m_fck
>> interface clock: usbhost_ick.
>>
>> do you agree?
>
> The interface clock should definitely be usbhost_ick, no doubt about it.
>
> But, as I mentioned above, to determine which functional clock should be
> the main clock, you first need to know which of those two clocks need to
> be enabled for register accesses to that module to succeed.
>
> I did this work a few years ago, by trial and error since it was largely
> undocumented.  It was needed since the OMAP3 clk_enable() code waits for
> the PRCM to request that the IP block exit idle before returning.
> You might want to take a look at arch/arm/mach-omap2/clock3xxx_data.c.
>
>> >> +static struct omap_hwmod omap34xx_usb_tll_hs_hwmod = {
>> >> +     .name           = "usb_tll_hs",
>> >> +     .class          = &omap34xx_usb_tll_hs_hwmod_class,
>> >> +     .mpu_irqs       = omap34xx_usb_tll_hs_irqs,
>> >> +     .main_clk       = "usbtll_ick",
>> >
>> > Is this really the main clock?  The main clock is the clock that drives
>> > the register logic in the IP block.  Looks to me, based on the integration
>> > document in the 34xx TRM vZR, that this module has a functional clock.
>>
>> I can make
>>
>> main clock: usbtll_fck
>> interface clock: usbtll_ick.
>>
>> do you agree?
>
> Doesn't that make more sense?

yes, I will do this change.


keshava
