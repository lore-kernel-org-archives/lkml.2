Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986Ab2ATRwD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 12:52:03 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50047 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889Ab2ATRv7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 12:51:59 -0500
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF1780DAB186@HQMAIL01.nvidia.com>
References: <CAA+hA=RBqpSmntS2h+6xMQuRvSRHenmDgrYSSzMXHtOCpU+HCQ@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF17761F18F8@HQMAIL01.nvidia.com>
	<7FE21149F4667147B645348EC605788507F698@039-SN2MPN1-013.039d.mgd.msft.net>
	<74CDBE0F657A3D45AFBB94109FB122FF177EE39E6B@HQMAIL01.nvidia.com>
	<20120107135445.GI4790@S2101-09.ap.freescale.net>
	<74CDBE0F657A3D45AFBB94109FB122FF177EE3A6E5@HQMAIL01.nvidia.com>
	<20120112033941.GH20968@S2101-09.ap.freescale.net>
	<74CDBE0F657A3D45AFBB94109FB122FF17801D1DCC@HQMAIL01.nvidia.com>
	<20120113034558.GA12184@S2101-09.ap.freescale.net>
	<74CDBE0F657A3D45AFBB94109FB122FF17801D1F9D@HQMAIL01.nvidia.com>
	<20120114012213.GD1810@S2101-09.ap.freescale.net>
	<CACRpkdYmxQd7aaRhs+xc5nizC7OjwRzsduq-28kVTLjhTGjVZw@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF17801D230A@HQMAIL01.nvidia.com>
	<CACRpkdZj9KGCoq2G2nHymUe2WxJLUVfGT4e=uCDq6kuZFNYU7Q@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF1780DAB186@HQMAIL01.nvidia.com>
Date: Fri, 20 Jan 2012 18:51:58 +0100
Message-ID: <CACRpkdYfDta1P4fDSZs=9he=+p++d1G-YSQQ98R=yCNZ6RYQ+A@mail.gmail.com>
Subject: Re: [RFC PATCH v3 2/5] pinctrl: add dt binding support for pinmux mappings
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Shawn Guo <shawn.guo@linaro.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Dong Aisheng <dongas86@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 8:30 PM, Stephen Warren <swarren@nvidia.com> wrote:
> Linus Walleij wrote at Thursday, January 19, 2012 9:56 AM:

>>     ChangeLog v5->v6:
>>
>>     - Create an abstract pin group concept that can sort pins into
>>       named and enumerated groups no matter what the use of these
>>       groups may be, one possible usecase is a group of pins being
>>       muxed in or so. The intention is however to also use these
>>       groups for other pin control activities.
>
> To me, "activities" above reads as pin configuration, since muxing is
> an activity that's covered by this patch, and pin config is an additional
> one. If doesn't imply virtual groups, which are data not an activity.

Yes, but the text also says "also". So I do not see how one of the
use cases excludes the other.

> I still feel that virtual groups don't have much purpose, since the
> whole reason I asked that the pin mux mapping table allow multiple
> entries to be allowed for each (map name, device) pair was to allow
> grouping of the lowest-level muxable entity into groups that the
> device used. So, defining these virtual groups is a completely
> redundant way of achieving the same goal.

I don't see it quite that way. I saw the support of multiple groups
per pinmux as a compromise to get code that would be useful
no matter how you chose to model it. And groups that would be
useful for other purposes than muxing alone.

It so happens that for the U300 some of the defined groups are
1-to-1 to the muxable entitity in a register, so it actually mostly
conforms to that, with the exception of the groups I created for
power pins and EMIF...

But the latter groups does indeed group things that share
something hardware-related in common, while that is not
a setting in a mux register, but something else, like being used
to transfer data to the same memory module in the EMIF
case.

> For DT bindings, I think we (at least myself, Shawn, and Dong) have
> agreed that with my binding proposal, you can get the same effect as
> virtual groups without the driver needing to define them (this is
> certainly true even if I misrepresent others' understanding). For the
> non-DT case, I proposed that the virtual groups could be represented
> as #defines/macros that could be used while initializing the board's
> mapping table, each containing n lines of entries as appropriate. Then,
> non-DT and DT could have equivalent sysfs output for pinctrl.
>
> That all said, I suppose that if the pinctrl driver were to expose some
> virtual groups, there's the possibility this will reduce the size of
> the device tree or static board mapping files, since they won't need
> so many entries or rows.

I don't understand these concepts well enough to have an opinion
on it. I will need to see the proposed code first...

> I'd be happy if we adopted the following policy
> (...)
> pinctrl drivers MUST enumerate all pins that are affected by the muxing
> or pin configuration capabilities of the pinctrl driver.

OK (split in separate clause when you write the documentation
patch for this)

> Where the HW
> muxes or configures pins in terms of groups, this list MUST include
> ALL pins in the groups that the pinctrl driver defines.

I think this requirement is to be broader:

- when your driver define pin groups, the pins in these groups need to
  be defined and registered as well.

Nothing of drivers with muxes.

I actually wanted to add code that verifies this on the existing
drivers, so they can't present groups to the subsystem if they
contain enumerated pins that does not exist.

So I'd say, isn't it better if we simply write some code that
checks this on registered groups and make sure you cannot
register groups with non-existing pin? That's 100 times
better than any written policy that would tend to be overlooked
anyway.

> Pinctrl drivers
> MAY expose a subset of pins present on the SoC, and grow this list over
> time as needed, provided the previous conditions are met.

OK (separate clause)

> (well, that's already a requirement of the pinctrl subsystem just due
> to how it works internally)

Yes. And it is better to write code than policies.

> If the HW muxes and configures pins on a per-pin basis, the pinctrl
> driver MUST enumerate a group for each individual pin included in the
> pin enumeration above, and allow muxing and pin configuration operations
> to be applied to these groups.

NACK, sorry.

Basically my argument (which was in the previous mail)
is that it doesn't make sense for the core or any policy to dictate
how a driver for a certain hardware shall present its groups; it's
up to the driver.

I already had this example in the previous mail:

----------------8<------------------------8<-----------------------
Example: pins {0, 1} can be used for I2C, or GPIO.
It doesn't make sense to mux in SCL on pin 0 and
have GPIO on pin 1, so defining a group of {0, 1}
and associate that with a mux setting for I2C is the
sensible thing to do IMO, even though this is in
practice achived by writing mux registers for two
different pins.
----------------8<------------------------8<-----------------------

I know this may be highly suitable for Tegra, so then have it as a
rule for your driver, problem solved? I don't see why this need
to be enforced across the entire subsystem.

> If the HW muxes and configures pins on a per-group basis, the pinctrl
> driver MUST enumerate all groups that are affected by the muxing
> or pin configuration capabilities of the pinctrl driver.

OK (separate clause)

> Pinctrl drivers
> MAY need to enumerate a group for each individual pin included in the

cut "need to". If the driver writer want to present each pin as
a group, s/he can go ahead and do that. But we need not impose that.
It's a fair compromise I think.

> pin enumeration above, e.g. if representing "GPIO" as a mux function.
> pinctrl drivers MAY expose a subset of groups present on the SoC, and
> grow this list over time as needed, provided the previous conditions
> are met.

Then OK (separate clause)

> (again, that's really just how pinctrl already works)

There is no driver in the kernel that define single-pin groups, so
it is not how it works. But it is possible and allowed
to do drivers like that.

> pinctrl drivers MAY expose additional groups. This feature may be used
> to represent higher-level groupings of the HW's raw muxable pins

So you are saying that a pin may be part of more than one group
and thus overlap?

This is true though.

> or groups.

Groups of groups? Never heard of that before.

In that case I think new abstractions are needed. And there is
no point in documenting groups of groups until there is code
to support it for sure.

> This may be useful in order to e.g. represent all pins involved
> in a single SD interface, so their muxing may be represented in a single
> pin mux mapping table entry. Such groups MUST still define a valid list
> of the individual pins included in the group.

I'm fine with the simple statement of allowing
a pin to be part of more than one group.

> Individual pinctrl drivers
> are responsible for any iteration required when muxing/configuration such
> "virtual" groups. This feature MAY be used irrespective of whether the
> underlying HW muxes or configures pins on a per-pin or per-group basis.
>
> (this explicitly allows "virtual" groups)

This is how I already implemented things, and I don't think of these
groups as "virtual" at all. That some certain group of pins does not
have a common register associated with it (say a mux register) does
not mean that they do not belong together anyway, like the U300
EMIF0 pins. There is nothing "virtual" about that, it's highly
physical.

So I am resisting the terminology of "virtual"

> Does that seem reasonable?

The stuff I marked OK is... forcing hardware with per-pin control
registers to present per-pin groups doesn't play well with me.

> (is it worth adding this to the documentation of pinctrl?)

For some instances it is better to write code. Like code that
(maybe optionally?) verifies that the groups registered by
a pin controller does not contain undefined pins.

Yours,
Linus Walleij
