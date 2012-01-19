Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932772Ab2ASTak (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 14:30:40 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18403 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932675Ab2ASTah convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 14:30:37 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 19 Jan 2012 11:30:20 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Shawn Guo <shawn.guo@linaro.org>,
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
Date: Thu, 19 Jan 2012 11:30:18 -0800
Subject: RE: [RFC PATCH v3 2/5] pinctrl: add dt binding support for pinmux
 mappings
Thread-Topic: [RFC PATCH v3 2/5] pinctrl: add dt binding support for pinmux
 mappings
Thread-Index: AczWyzMif/kBporVRSGMg/01Ujw1bAAEkpMA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1780DAB186@HQMAIL01.nvidia.com>
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
In-Reply-To: <CACRpkdZj9KGCoq2G2nHymUe2WxJLUVfGT4e=uCDq6kuZFNYU7Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote at Thursday, January 19, 2012 9:56 AM:
> On Tue, Jan 17, 2012 at 8:50 PM, Stephen Warren <swarren@nvidia.com> wrote:
> > Linus Walleij wrote at Monday, January 16, 2012 9:09 AM:
> 
> >> As you can see none of the text above claims that the group is
> >> about hardware-defined groups or anything like that.
> >
> > Well, I guess that's true, but didn't we only add the concept of groups
> > to the pinctrl subsystem in order to support Tegra's HW-group-based
> > muxing?
> 
> The groups appeared in v6 of the very first patchset, this is
> from git log drivers/pinctrl
> 
>     ChangeLog v5->v6:
> 
>     - Create an abstract pin group concept that can sort pins into
>       named and enumerated groups no matter what the use of these
>       groups may be, one possible usecase is a group of pins being
>       muxed in or so. The intention is however to also use these
>       groups for other pin control activities.

To me, "activities" above reads as pin configuration, since muxing is
an activity that's covered by this patch, and pin config is an additional
one. If doesn't imply virtual groups, which are data not an activity.

I still feel that virtual groups don't have much purpose, since the
whole reason I asked that the pin mux mapping table allow multiple
entries to be allowed for each (map name, device) pair was to allow
grouping of the lowest-level muxable entity into groups that the
device used. So, defining these virtual groups is a completely
redundant way of achieving the same goal.

For DT bindings, I think we (at least myself, Shawn, and Dong) have
agreed that with my binding proposal, you can get the same effect as
virtual groups without the driver needing to define them (this is
certainly true even if I misrepresent others' understanding). For the
non-DT case, I proposed that the virtual groups could be represented
as #defines/macros that could be used while initializing the board's
mapping table, each containing n lines of entries as appropriate. Then,
non-DT and DT could have equivalent sysfs output for pinctrl.

That all said, I suppose that if the pinctrl driver were to expose some
virtual groups, there's the possibility this will reduce the size of
the device tree or static board mapping files, since they won't need
so many entries or rows.

I'd be happy if we adopted the following policy for when to define
pin groups in a pinctrl driver. This both allows virtual groups if the
SoC's vendor wants them in their pinctrl driver, yet still exposes
the raw capabilities of the SoC, in case the pre-defined virtual groups
don't cover a case that needs to be used:

pinctrl drivers MUST enumerate all pins that are affected by the muxing
or pin configuration capabilities of the pinctrl driver. Where the HW
muxes or configures pins in terms of groups, this list MUST include
ALL pins in the groups that the pinctrl driver defines. Pinctrl drivers
MAY expose a subset of pins present on the SoC, and grow this list over
time as needed, provided the previous conditions are met.

(well, that's already a requirement of the pinctrl subsystem just due
to how it works internally)

If the HW muxes and configures pins on a per-pin basis, the pinctrl
driver MUST enumerate a group for each individual pin included in the
pin enumeration above, and allow muxing and pin configuration operations
to be applied to these groups.

(that's the main point I seek)

If the HW muxes and configures pins on a per-group basis, the pinctrl
driver MUST enumerate all groups that are affected by the muxing
or pin configuration capabilities of the pinctrl driver. Pinctrl drivers
MAY need to enumerate a group for each individual pin included in the
pin enumeration above, e.g. if representing "GPIO" as a mux function.
pinctrl drivers MAY expose a subset of groups present on the SoC, and
grow this list over time as needed, provided the previous conditions
are met.

(again, that's really just how pinctrl already works)

pinctrl drivers MAY expose additional groups. This feature may be used
to represent higher-level groupings of the HW's raw muxable pins or
groups. This may be useful in order to e.g. represent all pins involved
in a single SD interface, so their muxing may be represented in a single
pin mux mapping table entry. Such groups MUST still define a valid list
of the individual pins included in the group. Individual pinctrl drivers
are responsible for any iteration required when muxing/configuration such
"virtual" groups. This feature MAY be used irrespective of whether the
underlying HW muxes or configures pins on a per-pin or per-group basis.

(this explicitly allows "virtual" groups)

Does that seem reasonable?

(is it worth adding this to the documentation of pinctrl?)

-- 
nvpublic

