Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab2BFVZT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 16:25:19 -0500
Received: from rs130.luxsci.com ([72.32.115.17]:59370 "EHLO rs130.luxsci.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176Ab2BFVZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 16:25:17 -0500
Message-ID: <4F304504.2050002@firmworks.com>
Date: Mon, 06 Feb 2012 11:24:20 -1000
From: Mitch Bradley <wmb@firmworks.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Stephen Warren <swarren@nvidia.com>, Dong Aisheng <dongas86@gmail.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "Sascha Hauer (s.hauer@pengutronix.de)" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "Simon Glass (sjg@chromium.org)" <sjg@chromium.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        "Grant Likely (grant.likely@secretlab.ca)" 
	<grant.likely@secretlab.ca>,
        "ext Tony Lindgren (tony@atomide.com)" <tony@atomide.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: An extremely simplified pinctrl bindings proposal
References: <74CDBE0F657A3D45AFBB94109FB122FF178E5D3160@HQMAIL01.nvidia.com> <4F302474.1020701@firmworks.com> <CACRpkdYt-L+an5DTdYkS5Hi+18-rszAt7hXwZNUNVK-d0UaCWA@mail.gmail.com>
In-Reply-To: <CACRpkdYt-L+an5DTdYkS5Hi+18-rszAt7hXwZNUNVK-d0UaCWA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Lux-Comment: Message q16LOIc1021040 sent by user #11875
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/6/2012 9:26 AM, Linus Walleij wrote:
> On Mon, Feb 6, 2012 at 8:05 PM, Mitch Bradley<wmb@firmworks.com>  wrote:
>
>> I like the general approach of simplifying the pinctrl thing, as the
>> previous approach did not appear to be converging.
>
> pinctrl as such is upstream, widely ACKed and quite converged I'd say.
>
> But the Device Tree bindings and general path to get data out of the drivers
> and board files are not (yet) converging...
>
>> Both Open Firmware and ACPI have addressed this general problem.  In
>> addition to a numeric identifier for the register, you need to specify the
>> access semantics.  It's difficult to finitely enumerate all possible cases,
>> but you can get to 99.9% with a modest number of access models, and then add
>> new models as needed.
>
> This is interesting. So are you referring to a piece of Open Firmware
> that is not in the Device Tree? Since this is all about device tree that
> comes from OF, we might be reinventing the wheel.

Open Firmware in general is a complete firmware system, with features 
for system initialization, bootloading, diagnostics (for factory, field 
service, and end users), system maintenance functions like OS upgrades, 
and debugging tools for hardware, the firmware itself, and the OS.  It 
exports a set of callbacks that OF-aware OSs (e.g. Solaris) can use to 
perform demand-loading of driver modules, even for core drivers like the 
filesystem root device.  It is fully programmable, including an 
interpreter, incremental compiler, decompiler, assembler, disassembler, 
and both source-level and assembly language debugging.  Modern 
implementations include complete network stacks and support for numerous 
filesystems.

Its device tree serves not only to communicate information to the OS, 
but also as the framework for OF's driver model.  In addition to the 
descriptive properties, device nodes contain executable methods that 
implement the device drivers that support the feature set listed above. 
  The device drivers can either be hard-compiled or demand-loaded from 
"option ROMs" on plug-in cards.  They are encoded using "FCode", a 
processor and platform neutral byte-coded representation of Forth source 
code.

The register access generalization that I was talking about is part of 
that driver model.  Each bus driver implements a set of register access 
methods that apply to its children.  The child drivers invoke those 
methods from the parent, without having to know any platform-specific 
details.

The register access model is based on executable methods rather than on 
descriptive data in properties.  In many cases, those methods use info 
in the properties, including "reg", "ranges" and "#address-cells", but 
the methods can also encode semantic requirements that are difficult to 
describe as pure data.

To fully solve all the problems that eventually arise, you end up 
needing a programming language, which is why Open Firmware was built 
from the ground up around a programming language core.

Of course, it's usually possible to solve a very large subset of 
problems with a sufficiently-elaborate data description.


> Can you give some pointers?

The definitive core document is IEEE 1275-1994, but that document is 18 
years old and is not really the best way to learn about Open Firmware. 
(The status of that document with respect to IEEE is "withdrawn".  What 
that really means is that we (the group that developed it) got fed up 
with the IEEE process and declined to spend the time, money, and effort 
necessary to comply with IEEE's public voting process for 
"reaffirmation" every N years.)

Here are some pointers to information about modern implementations and 
usage:

http://wiki.laptop.org/go/Open_Firmware
http://wiki.laptop.org/go/Forth_Lessons
http://www.openfirmware.info

One Laptop Per Child uses Open Firmware on both x86 and ARM systems.

>
> Indeed it seems related to ACPI or some BIOS stuff on
> non-embedded systems.
>
> Yours,
> Linus Walleij
>
>
