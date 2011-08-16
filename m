Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817Ab1HPRdc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 13:33:32 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10701 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233Ab1HPRda convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 13:33:30 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 16 Aug 2011 10:33:10 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Arnd Bergmann <arnd@arndb.de>, Linus Walleij <linus.walleij@linaro.org>,
        Jamie Iles <jamie@jamieiles.com>
CC: Grant Likely <grant.likely@secretlab.ca>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Belisko Marek <marek.belisko@gmail.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>
Date: Tue, 16 Aug 2011 10:32:05 -0700
Subject: RE: [RFC PATCH v2 06/13] docs/dt: Document nvidia,tegra20-pinmux
 binding
Thread-Topic: [RFC PATCH v2 06/13] docs/dt: Document nvidia,tegra20-pinmux
 binding
Thread-Index: AcxcG6Aul1hxfZluSDmH8D4c7hXfegAHJaIQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF04AEA2537D@HQMAIL01.nvidia.com>
References: <1313440100-17131-1-git-send-email-swarren@nvidia.com>
 <1313440100-17131-7-git-send-email-swarren@nvidia.com>
 <201108161551.31389.arnd@arndb.de>
In-Reply-To: <201108161551.31389.arnd@arndb.de>
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

Arnd Bergmann wrote at Tuesday, August 16, 2011 7:52 AM:
> On Monday 15 August 2011, Stephen Warren wrote:
> > Signed-off-by: Stephen Warren <swarren@nvidia.com>
> > ---
> >  .../devicetree/bindings/pinmux/pinmux_nvidia.txt   |  294 ++++++++++++++++++++
> >  1 files changed, 294 insertions(+), 0 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/pinmux/pinmux_nvidia.txt
> >
> > diff --git a/Documentation/devicetree/bindings/pinmux/pinmux_nvidia.txt b/Documentation/devicetree/bindings/pinmux/pinmux_nvidia.txt
> > new file mode 100644
> > index 0000000..744e1b7
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/pinmux/pinmux_nvidia.txt
> > @@ -0,0 +1,294 @@
> > +NVIDIA Tegra 2 pinmux controller
> > +
> > +Required properties:
> > +- compatible : "nvidia,tegra20-pinmux"
> 
> Hmm, I think it would be much better in general if we could define
> pinmux bindings in a way that is less specific to just one soc.

> The contents of this file seem to be specific to even just one
> version of the tegra chip, and might be completely different for
> tegra30 and later, right?

The general concepts are the same between tegra20 and tegra30.

Tegra30 has a different set of mux and drive pingroups.

Tegra30 has more functions that can be assigned to pins.

Tegra30 has three more options per mux pingroup, although I haven't
Investigated whether any of those would need to be represented in DT;
I suspect at least one will, possibly all.

> Maybe Linus W can comment on this and say whether he thinks it can
> be generalized enough to apply to other pinmux drivers.
> 
> > +Optional sub-nodes:
> > +- nvidia,mux-groups : Mux group settings; see below.
> > +- nvidia,drive-groups : Drive group settings; see below.
> > +
> > +nvidia,mux-groups sub-node:
> 
> These concepts seem general enough to me that they can apply to
> other chips, and I would consequently drop the nvidia, prefix.

Two things to note about Tegra that might not apply to all SoCs:

* There are separate groups of pins for Muxing (plus some config) vs.
drive-strength (and related config). Some SoCs might use the same set
of groups for both. Perhaps some SoC might even have three or more types
of groups! I expect this to have some impact on the binding; I created
explicit mux-groups and drive-groups sub-nodes to represent this.

* Tegra's pinmux apply settings to groups of pins instead of individual
pins. Some SoCs might allow each setting to be configurable per-pin.
I don't expect this to have any impact as far as the bindings go though;
it'll simply impact the names of the available pin "groups"; some SoCs
will name groups, others pins.

> > +Each mux pin group is represented as a sub-node of the nvidia,mux-groups node.
> > +The name of the sub-node should be the name of the mux pingroup. The following
> > +names are valid:
> > +
> > +	ata
> > +	atb
> > +	atc
> > +	atd
> > +	ate
> > +	cdev1
> > +	cdev2
> > ...
> 
> I noticed that each board you define has a complete list of these. Would
> it be possible to move a generic list into a tegra20-pinmux.dtsi file and
> just override the pins in the per-board .dts file that require some special
> setup?

I'm not sure how much commonality there will really be.

Certainly, many boards are based off our reference designs and so will
have many similarities that could be shared.

That said, comparing even tegra-harmony.dts and tegra-seaboard.dts shows
a lot of differences. It seems a lot less error-prone to just completely
describe the entire pinmux state in each board's .dts file, rather than
trying to represent half the information as default in the SoC .dtsi file,
and just the diff in the board .dts file. I suppose perhaps if we put the
hardware's own default settings in tegra20.dtsi, that'd make sense, since
people are presumably reasonably aware of the delta relative to that.

We'd need to add new properties to override defaults, like:

nvidia,tristate --> nvidia,drive
nvidia,pull-*   --> nvidia,no-pull

> > +
> > +optional subnode-properties:
> > +- nvidia,pull-up : Boolean, apply Tegra's internal pull-up to the pin.
> > +- nvidia,pull-down : Boolean, apply Tegra's internal pull-down to the pin.
> > +- nvidia,tristate : Boolean, tristate the pin. Otherwise, drive it.
> > +
> > +If both nvidia,pull-up and nvidia,pull-down are specified, nvidia,pull-up
> > +takes precedence.
> 
> These again seem generic enough to go into a general pinmux binding, without
> the nvidia, prefix.

Yes, I believe Jamie Iles was going to try cooking up a generic core binding
that could be shared across different SoCs, and extended with custom stuff.

-- 
nvpublic

