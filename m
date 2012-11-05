Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab2KEMcH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 07:32:07 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:48625 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745Ab2KEMcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 07:32:02 -0500
MIME-Version: 1.0
In-Reply-To: <20121102152826.GQ5190@beefymiracle.amer.corp.natinst.com>
References: <cover.1351721190.git.josh.cartwright@ni.com>
	<94af5ee92c2d68f245eb902de74909aadf159be1.1351721190.git.josh.cartwright@ni.com>
	<50939378.2050500@metafoo.de>
	<20121102133850.GO5190@beefymiracle.amer.corp.natinst.com>
	<5093E2D5.2000304@metafoo.de>
	<20121102152826.GQ5190@beefymiracle.amer.corp.natinst.com>
Date: Mon, 5 Nov 2012 13:31:59 +0100
X-Google-Sender-Auth: HfS1HXSX_4BdYFMrK8wfIEu-y6Q
Message-ID: <CAHTX3dKeP-RhTXuO_9aBb=GqeGA8qgJ=RrVh+YRS0Ly8Y=X2ug@mail.gmail.com>
Subject: Re: [PATCH 5/8] ARM: zynq: add COMMON_CLK support
From: Michal Simek <michal.simek@xilinx.com>
To: Josh Cartwright <josh.cartwright@ni.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@ti.com>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Linn <John.Linn@xilinx.com>, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/2 Josh Cartwright <josh.cartwright@ni.com>:
> On Fri, Nov 02, 2012 at 04:12:21PM +0100, Lars-Peter Clausen wrote:
>> On 11/02/2012 02:38 PM, Josh Cartwright wrote:
>> > On Fri, Nov 02, 2012 at 10:33:44AM +0100, Lars-Peter Clausen wrote:
>> >> On 10/31/2012 07:58 PM, Josh Cartwright wrote:
> [...]
>> >>> +static void __init zynq_periph_clk_setup(struct device_node *np)
>> >>> +{
>> >>> + struct zynq_periph_clk *periph;
>> >>> + const char *parent_names[3];
>> >>> + struct clk_init_data init;
>> >>> + struct clk *clk;
>> >>> + int err;
>> >>> + u32 reg;
>> >>> + int i;
>> >>> +
>> >>> + err = of_property_read_u32(np, "reg", &reg);
>> >>> + WARN_ON(err);
>> >>
>> >> Shouldn't the function abort if a error happens somewhere? Continuing here
>> >> will lead to undefined behavior. Same is probably true for the other WARN_ONs.
>> >
>> > The way I see it is: the kernel is will be left in a bad state in the
>> > case of any failure, regardless of if we bail out or continue.  AFAICT,
>> > there is no clean way to recover from a failure this early.
>> >
>> > Given that, it seems simpler (albeit marginally so) just to continue; so
>> > that's what I chose to do.  I'm not opposed to bailing out, just not
>> > convinced it does anything for us.
>> >
>> The issue with this approach is that, while you get a warning, unexpected
>> seemingly unrelated side-effects may happen later on. E.g. if no reg
>> property for the clock is specified the reg variable will be uninitialized
>> and contain whatever was on the stack before. The clock will be registered
>> nonetheless and the boot process continues. Now if the clock is enabled a
>> bit in a random register will be modified, which could result in strange and
>> abnormal behavior, which can be very hard to track down.
>
> Okay.....but any reasonable person would start their debugging quest at
> the source of the WARN_ON.  If someone sees the WARN_ON message but
> stupidly chooses to ignore it, they deserves to spend the time trying to
> track down abnormal behavior, so I'm still not convinced.

I am with Lars. You would be surprised how many people do no read bootlog.
It should be handled better.

Thanks,
Michal
