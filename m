Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757992Ab1I3Kd0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 06:33:26 -0400
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:43608 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755386Ab1I3KdZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 06:33:25 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1109300156140.12185@utopia.booyaka.com>
References: <1317361216-28248-1-git-send-email-keshava_mgowda@ti.com>
	<alpine.DEB.2.00.1109300107150.32653@utopia.booyaka.com>
	<alpine.DEB.2.00.1109300156140.12185@utopia.booyaka.com>
Date: Fri, 30 Sep 2011 16:03:23 +0530
Message-ID: <CAP05o4+VPcMXn8hB6f2buyET1tR+KZu1tMm=xh5DKrrjsuomnw@mail.gmail.com>
Subject: Re: [PATCH 2/5 v12] arm: omap: usb: ehci and ohci hwmod structures
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

On Fri, Sep 30, 2011 at 1:32 PM, Paul Walmsley <paul@pwsan.com> wrote:
> Hi
>
> a few more comments
>
> On Fri, 30 Sep 2011, Paul Walmsley wrote:
>
>> On Fri, 30 Sep 2011, Keshava Munegowda wrote:
>>
>> > +static struct omap_hwmod_ocp_if omap34xx_l4_cfg__usb_host_hs = {
>> > +   .master         = &omap3xxx_l4_core_hwmod,
>> > +   .slave          = &omap34xx_usb_host_hs_hwmod,
>> > +   .clk            = "l4_ick",
>> > +   .addr           = omap34xx_usb_host_hs_addrs,
>> > +   .user           = OCP_USER_MPU | OCP_USER_SDMA,
>> > +};
>> > +
>> > +static struct omap_hwmod_ocp_if omap34xx_usb_host_hs__ick = {
>
> This is missing master, slave, and addr fields.  But see the comment
> below.
>
>> > +   .clk            = "usbhost_ick",
>> > +   .user           = OCP_USER_MPU,
>> > +   .flags          = OCPIF_SWSUP_IDLE,
>>
>> Does this really need OCPIF_SWSUP_IDLE?  If so, then there is a hardware
>> bug, and some explanation is needed.
>
> Could you describe why there are two struct omap_hwmod_ocp_if records
> here?  It seems to me that these should just be combined into one struct
> omap_hwmod_ocp_if record?  Looking at the clock3xxx_data.c file, the
> usbhost_ick struct clk has l4_ick as its parent, so l4_ick shouldn't need
> to be mentioned explicitly?


Thanks ! I will do this.



..
>
>> > +static struct omap_hwmod_ocp_if omap34xx_f_cfg__usb_tll_hs = {
>> > +   .clk            = "usbtll_ick",
>> > +   .user           = OCP_USER_MPU,
>> > +   .flags          = OCPIF_SWSUP_IDLE,
>> > +};
>>
>> Does this really need OCPIF_SWSUP_IDLE?  If so, then there is a hardware
>> bug, and some explanation is needed.
>>
>> > +
>> > +static struct omap_hwmod_ocp_if omap34xx_l4_cfg__usb_tll_hs = {
>> > +   .master         = &omap3xxx_l4_core_hwmod,
>> > +   .slave          = &omap34xx_usb_tll_hs_hwmod,
>> > +   .clk            = "l4_ick",
>> > +   .addr           = omap34xx_usb_tll_hs_addrs,
>> > +   .user           = OCP_USER_MPU | OCP_USER_SDMA,
>> > +};
>
> Same problem here.  Seems like omap34xx_l4_cfg__usb_tll_hs and
> omap34xx_f_cfg__usb_tll_hs should be combined into one record.

Thanks ! I will do this.
