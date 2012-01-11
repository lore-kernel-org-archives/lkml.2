Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933904Ab2AKTUD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 14:20:03 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6183 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933339Ab2AKTT6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 14:19:58 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 11 Jan 2012 11:19:39 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Simon Glass <sjg@chromium.org>, Shawn Guo <shawn.guo@linaro.org>
CC: Richard Zhao <richard.zhao@linaro.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Dong Aisheng <dongas86@gmail.com>
Date: Wed, 11 Jan 2012 11:19:38 -0800
Subject: RE: [RFC PATCH v3 2/5] pinctrl: add dt binding support for pinmux
 mappings
Thread-Topic: [RFC PATCH v3 2/5] pinctrl: add dt binding support for pinmux
 mappings
Thread-Index: AczOlnUXoj6cV7qLQ+O0hiMkHF4cHQB+qbOQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF177EE3A736@HQMAIL01.nvidia.com>
References: <1324402840-32451-3-git-send-email-b29396@freescale.com>
	<74CDBE0F657A3D45AFBB94109FB122FF176BE92F00@HQMAIL01.nvidia.com>
	<7FE21149F4667147B645348EC6057885075542@039-SN2MPN1-013.039d.mgd.msft.net>
	<74CDBE0F657A3D45AFBB94109FB122FF176CC743EF@HQMAIL01.nvidia.com>
	<CAA+hA=RBqpSmntS2h+6xMQuRvSRHenmDgrYSSzMXHtOCpU+HCQ@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF17761F18F8@HQMAIL01.nvidia.com>
	<7FE21149F4667147B645348EC605788507F698@039-SN2MPN1-013.039d.mgd.msft.net>
	<74CDBE0F657A3D45AFBB94109FB122FF177EE39E6B@HQMAIL01.nvidia.com>
	<20120107135445.GI4790@S2101-09.ap.freescale.net>
	<20120108125156.GB2203@richard-laptop>
	<20120109015625.GE1835@S2101-09.ap.freescale.net>
 <CAPnjgZ1LL7g_s1e+Pe-XN27yTNL4SCZvm6swJ_zX=ZULQirOxQ@mail.gmail.com>
In-Reply-To: <CAPnjgZ1LL7g_s1e+Pe-XN27yTNL4SCZvm6swJ_zX=ZULQirOxQ@mail.gmail.com>
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

Simon Glass wrote at Sunday, January 08, 2012 11:18 PM:
...
> 2. Stephen also said:
> 
> > We also need to consider compatibility and extensibility. A DT binding
> > is an ABI between the kernel and whatever is providing it, and so we
> > need to be able to maintain and extend it in a compatible fashion, just
> > like the user-space syscall ABI. Now it's true that the .dts files are
> > currently part of the kernel source tree and can be rev'd in sync with
> > kernel changes, but that may not always be the case moving forward.
> >
> > In other words, taking a board with an old device tree embedded into
> > Flash and running a new kernel using that device tree should work just
> > like running the original kernel did.
> 
> While this is true we should remember that SOCs will change and
> evolve, and we don't actually need a device tree for a Tegra 2 (say)
> to be able to boot a Tegra 3 kernel. So each time we create a new SOC
> in a family, we have the opportunity to update the fdt, potentially in
> an incompatible way, since we know that the old boot loader and new
> kernel are incompatible anyway.

Depending on the context, I both agree and disagree.

Take some random HW module in the SoC. If the HW changes enough to
warrant a new binding between SoC v1 and SoC v2, we can certainly revise
the binding in a non-compatible way, and hence not be shackled by
compatibility issues forever.

However, where SoC v2's HW is the same as or very similar to SoC v1's
hardware, we don't want to arbitrarily introduce a new binding if we
can instead keep it identical, or extend it in a compatible fashion.
The more we keep binding definitions stable, the easier it'll be for
people to create .dts files for the new SoC version. They can simply
copy/rename the existing SoC .dtsi file, not need to learn too much
new stuff, etc.

Finally, in the context of pinmux, we're talking about at least some
kind of common infra-structure for pinmux bindings, just like there's
a common infra-structure for registers, interrupts, GPIOs, etc. Such a
binding will hopefully apply across all SoCs, all boards, etc. Hence,
we have to be much more careful about future extensibility, and having
the binding be general enough for future scenarios.

...
> Also IMO updating the kernel without the device tree doesn't make a
> huge amount of sense. Why not just update both? Really to me the
> device tree is almost like static data for the kernel. It is a worthy
> goal to keep it as static as possible, but if it changes I don' t
> think it is the end of civilisation.

One of the goals of device tree is to have the kernel and DT file be
independent. I know this has been discussed a bit before, but can't
find it right now; previous discussions probably explain things better
than I will!

I think the main use-case here is:
* Vendor ships a system the boots with DT
* User wants to update to a newer kernel, so they build it and install
  it.
* The kernel doesn't contain the .dts file for this random board the
  mainline community hasn't even heard of, or the vendor placed the
  DT onto the device somewhere that's difficult to update. So, the user
  needs to use the old DT with the new kernel.

> 4. Who bears the pain?
> 
> There is a lot of complexity in pinmux - if we continue to split the
> device tree into an SOC file and a board file then we should think
> about which one bears the brunt of the complexity. IMO it should be
> the SOC file. The SOC file is written by very clever engineers working
> for the SOC vendor. They are motivated to get their SOC working
> properly and for it to be easy for customers to access the glorious
> ground-breaking feature therein. On the other hand, the board file (to
> the extent it is not just copied from the vendor's example) is put
> together by people with little knowledge of the SOC, limited time to
> do the work and minimal interest in the wonders of the device tree
> structure.

Yes, the board file should be as simple as is reasonable.

> With this in mind I think the pinmux complexity should mostly be in
> the SOC file. This includes the selection of valid pinmux options.

Well, either the pinctrl driver /or/ the SoC .dtsi file can enumerate
the legal set of mux options. So, I think the SoC .dtsi file could end
up without having any pinmux data if the driver contains the static
tables.

> After all, despite the many possible ways that functions could be
> brought out of the chip, only a certain few ways typically make sense.
> For example, an SDMMC peripheral needs clock and command pins - unless
> these are connected then nothing with work. Similarly there is no
> sense in having two data[0] pins brought out for the same SDMMC port.
> 
> In fact the SOC vendor generally has a good idea about the different
> options and mostly there are a small number of useful ones. So why
> don't we just enumerate these in the SOC file and let the board select
> what it wants in a single setting?

Yes, but the set of legal *combinations* of which function is selected
for each pin/group is much much larger than the individual lists of just
pins/groups and functions. Representing the entire list of combinations
often isn't practical. Instead, see my earlier response where I propose:

* All board-specific configuration go into the board .dts file.
* Where we observe there is commonality between boards, we create another
  .dtsi file just for that common part. That allows sharing between board
  files, solving the duplication problem, yet doesn't require the SoC.dtsi
  file to define a large number of combinations, most of which won't be
  useful for an individual board. The SoC vendor could supply the set of
  these pinmux .dtsi files if they want.

That said, this seems to add more complexity to me; you have to think a
little about code-sharing, search through all the definitions of the
available options to find the correct pinmux .dtsi file to use etc. I
suspect a large number of FAEs are going to find it a lot easier to just
explicitly enumerate their required pinmux settings in their one board
file and ignore any other board files. But, we can certainly do better
for boards that go upstream, and share as much as we can in the pinmux
.dtsi files.

> 5. Start at the top: function mux
> 
> I propose adding a new level at the top, a function mux. This
> basically routes functions to one of 2-3 predefined options. So UART1

As I mentioned above, the set of "predefined options" is large, and not
something we want to enumerate. Requiring enumeration of that set as a
base part of the binding is a non-starter in my opinion (and others have
mentioned this in earlier emails in this thread, and previous discussions
of the pinctrl subsystem).

> can come out on 3 different sets of pins, SDMMC2 on two sets, etc.
> These are recommended from the vendor and in common use (e.g. on
> reference designs), so should be easy to use.
> 
> Below the function mux is the group mux. Here we specify a list of pin
> groups and which function each group is assigned to. Together these
> 2-3 groups join to give us the pins that the function mux needs.

That model seems very different to how the HW works. I think the device
tree should represent the HW as closely as possible. Defining which pins
exist, and which mux option to select on a per-pin basis (or per-group
basis where the HW works that way) seems simplest and most direct, and
most familiar to board engineers and readers of the SoC documentation,
which doesn't enumerate all these "possible combinations", but instead
typically talks about which pins/groups exist, and which functions are
legal on those pins/groups.

> Below the pin groups are the pins. Some SOCs will have only one pin
> per group, some will have a group mux that really just moves entire
> functions around.
> 
> IMO the top level belongs with the board file. If the board designer
> wants to depart from common options they can suffer the pain of
> dropping down to the group level.
> 
> So at the board level it would be nice to do something like this:
> 
> sdhci@c8000400 {
> 	funcmux = <&sdmmc3-funcmux 0 0>;  /* funcmux phandle, config option, flags */
> };
> 
> which means that we want this SDMMC port to use configuration 0 (out
> of perhaps 2-3 recommended options the SOC provides for bringing out
> this SDMMC function) and that there are no special flags required. Or:
> 
> emmc: sdhci@c8000600 {
> 	funcmux = <&sdmmc4-funcmux 1 OPT_SDMMC_8BIT>;
> }
> 
> which means for this port we want to use configuration 1 with 8-bit wide data.

As I mentioned in my response to the U-Boot funcmux discussions to add
this "option" flag, it doesn't really make sense w.r.t to how the HW is
works.

If the HW has an 8-bit bus, you set up the pinmux for that 8-bit bus.

If the HW has a 4-bit bus, you set up the pinmux for that 4-bit bus.

There isn't a case where you select an "8 bit SD bus" option, for a board
where you want to use it in 4-bit mode; you'd just select a 4-bit config
instead.

Note that run-time bus width switching is orthogonal to this and subject
to negotiation between the controller and the SD card; the pinmux should
be setting up the HW for the actual bus width that's present on the board
in all cases.

> Something like this is easy for the board files to deal with. It fits
> with the way reference designs are done (selecting from a few
> options). It allows flags to specify different options like 4-bit or
> 8-bit wide SDMMC which can affect what pinmux groups are affected.

I disagree about reference designs or ease of use here. AFAIK, none of
the Tegra documentation at least talks about any set of supported sets
of pin mux usage for a given controller, but simply documents the set
of pins, groups, and legal functions for each pin/group. The documentation
I've seen for other chips is the same way. And as I mention above, I
believe FAEs and OEMs will find it easier to simply enumerate their
complete pinmux layout at a per-pin/group level, to match the docs.

> Some boot loaders might even implement things only at the funcmux
> level, with hard-coded configuration of the actual pin groups in
> static data in their code, without reference to the device tree. This
> might allow them to operate with a vastly truncated device tree. They
> might be very motivated to do this if the full device tree consists of
> 20KB of strings :-)

Uggh.

We shouldn't burden the device tree binding due to internal implementation
details of any particular software.

That said, yes, we really should avoid strings for pin/group/function/...
names in the DT if at all possible.

If U-Boot isn't going to use the device tree for some random subset of
its configuration, I'm unsure why it'd use DT at all; why not do everything
through board files?

> ...

I didn't respond to individual points in the rest of your email, since
I've basically already answered them in this and immediately previous
emails.

-- 
nvpublic

