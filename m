Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119Ab1HQGJC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 02:09:02 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:24297
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750813Ab1HQGI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 02:08:59 -0400
X-SpamScore: -15
X-BigFish: VS-15(z37d5kz9371K179dN1432N98dKzz1202hzz8275bhz2dh2a8h668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Wed, 17 Aug 2011 14:17:04 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Stephen Warren <swarren@nvidia.com>
CC: Arnd Bergmann <arnd@arndb.de>, Linus Walleij <linus.walleij@linaro.org>,
        Jamie Iles <jamie@jamieiles.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Colin Cross <ccross@android.com>, Erik Gilling <konkers@android.com>,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Belisko Marek <marek.belisko@gmail.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>
Subject: Re: [RFC PATCH v2 06/13] docs/dt: Document nvidia,tegra20-pinmux
 binding
Message-ID: <20110817061703.GB10037@S2100-06.ap.freescale.net>
References: <1313440100-17131-1-git-send-email-swarren@nvidia.com>
 <1313440100-17131-7-git-send-email-swarren@nvidia.com>
 <201108161551.31389.arnd@arndb.de>
 <74CDBE0F657A3D45AFBB94109FB122FF04AEA2537D@HQMAIL01.nvidia.com>
 <20110817060242.GA10037@S2100-06.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110817060242.GA10037@S2100-06.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 17, 2011 at 02:02:43PM +0800, Shawn Guo wrote:
> On Tue, Aug 16, 2011 at 10:32:05AM -0700, Stephen Warren wrote:
> > Arnd Bergmann wrote at Tuesday, August 16, 2011 7:52 AM:
> > > On Monday 15 August 2011, Stephen Warren wrote:
> > > > Signed-off-by: Stephen Warren <swarren@nvidia.com>
> > > > ---
> > > >  .../devicetree/bindings/pinmux/pinmux_nvidia.txt   |  294 ++++++++++++++++++++
> > > >  1 files changed, 294 insertions(+), 0 deletions(-)
> > > >  create mode 100644 Documentation/devicetree/bindings/pinmux/pinmux_nvidia.txt
> > > >
> > > > diff --git a/Documentation/devicetree/bindings/pinmux/pinmux_nvidia.txt b/Documentation/devicetree/bindings/pinmux/pinmux_nvidia.txt
> > > > new file mode 100644
> > > > index 0000000..744e1b7
> > > > --- /dev/null
> > > > +++ b/Documentation/devicetree/bindings/pinmux/pinmux_nvidia.txt
> > > > @@ -0,0 +1,294 @@
> > > > +NVIDIA Tegra 2 pinmux controller
> > > > +
> > > > +Required properties:
> > > > +- compatible : "nvidia,tegra20-pinmux"
> > > 
> > > Hmm, I think it would be much better in general if we could define
> > > pinmux bindings in a way that is less specific to just one soc.
> > 
> > > The contents of this file seem to be specific to even just one
> > > version of the tegra chip, and might be completely different for
> > > tegra30 and later, right?
> > 
> > The general concepts are the same between tegra20 and tegra30.
> > 
> > Tegra30 has a different set of mux and drive pingroups.
> > 
> > Tegra30 has more functions that can be assigned to pins.
> > 
> > Tegra30 has three more options per mux pingroup, although I haven't
> > Investigated whether any of those would need to be represented in DT;
> > I suspect at least one will, possibly all.
> > 
> > > Maybe Linus W can comment on this and say whether he thinks it can
> > > be generalized enough to apply to other pinmux drivers.
> > > 
> > > > +Optional sub-nodes:
> > > > +- nvidia,mux-groups : Mux group settings; see below.
> > > > +- nvidia,drive-groups : Drive group settings; see below.
> > > > +
> > > > +nvidia,mux-groups sub-node:
> > > 
> > > These concepts seem general enough to me that they can apply to
> > > other chips, and I would consequently drop the nvidia, prefix.
> > 
> > Two things to note about Tegra that might not apply to all SoCs:
> > 
> > * There are separate groups of pins for Muxing (plus some config) vs.
> > drive-strength (and related config). Some SoCs might use the same set
> > of groups for both. Perhaps some SoC might even have three or more types
> > of groups! I expect this to have some impact on the binding; I created
> > explicit mux-groups and drive-groups sub-nodes to represent this.
> > 
> > * Tegra's pinmux apply settings to groups of pins instead of individual
> > pins. Some SoCs might allow each setting to be configurable per-pin.
> > I don't expect this to have any impact as far as the bindings go though;
> > it'll simply impact the names of the available pin "groups"; some SoCs
> > will name groups, others pins.
> > 
> +1
> 
> imx's pinmux applies settings to individual pins.
> 
> > > > +Each mux pin group is represented as a sub-node of the nvidia,mux-groups node.
> > > > +The name of the sub-node should be the name of the mux pingroup. The following
> > > > +names are valid:
> > > > +
> > > > +	ata
> > > > +	atb
> > > > +	atc
> > > > +	atd
> > > > +	ate
> > > > +	cdev1
> > > > +	cdev2
> > > > ...
> > > 
> > > I noticed that each board you define has a complete list of these. Would
> > > it be possible to move a generic list into a tegra20-pinmux.dtsi file and
> > > just override the pins in the per-board .dts file that require some special
> > > setup?
> > 
> 
> It sounds sane for imx though.  I'm going to take this suggestion to
> have imx53-pinmux.dtsi holding register offset for each pin, which is
> common across all i.mx53 boards.
> 
> > I'm not sure how much commonality there will really be.
> > 
> > Certainly, many boards are based off our reference designs and so will
> > have many similarities that could be shared.
> > 
> > That said, comparing even tegra-harmony.dts and tegra-seaboard.dts shows
> > a lot of differences. It seems a lot less error-prone to just completely
> > describe the entire pinmux state in each board's .dts file, rather than
> > trying to represent half the information as default in the SoC .dtsi file,
> > and just the diff in the board .dts file. I suppose perhaps if we put the
> > hardware's own default settings in tegra20.dtsi, that'd make sense, since
> > people are presumably reasonably aware of the delta relative to that.
> > 
> > We'd need to add new properties to override defaults, like:
> > 
> > nvidia,tristate --> nvidia,drive
> > nvidia,pull-*   --> nvidia,no-pull
> > 
> > > > +
> > > > +optional subnode-properties:
> > > > +- nvidia,pull-up : Boolean, apply Tegra's internal pull-up to the pin.
> > > > +- nvidia,pull-down : Boolean, apply Tegra's internal pull-down to the pin.
> > > > +- nvidia,tristate : Boolean, tristate the pin. Otherwise, drive it.
> > > > +
> > > > +If both nvidia,pull-up and nvidia,pull-down are specified, nvidia,pull-up
> > > > +takes precedence.
> > > 
> > > These again seem generic enough to go into a general pinmux binding, without
> > > the nvidia, prefix.
> > 
> > Yes, I believe Jamie Iles was going to try cooking up a generic core binding
> > that could be shared across different SoCs, and extended with custom stuff.
> > 
> I would image that whatever common binding for pin/pad configuration
> comes can hardly work for imx out of box.  For each pin/pad, imx have
> 4 configurations for pull:
> 
>   00: 100KOhm Pull Down
>   01: 47KOhm Pull Up
>   10: 100KOhm Pull Up
>   11: 22KOhm Pull Up
> 
> 4 configurations for drive:
> 
>   00: 100KOhm Pull Down
>   01: 47KOhm Pull Up
>   10: 100KOhm Pull Up
>   11: 22KOhm Pull Up
> 
Correction:

  00 Low Drive Strength
  01 Medium Drive Strength
  10 High Drive Strength
  11 Max Drive Strength

> some other 1 bit configuration fields:
> 
>   low/high output voltage Field
>   Hyst. Enable Field
>   Pull / Keep Enable Field
>   Pull / Keep Select Field
>   Slew Rate Field
> 
> All these are all in one register <pad_name>_PAD_CTL (mux configuration
> is in another register <pad_name>_PAD_MUX).  The best binding for
> PAD_CTL I can think of so far is to encode the register value in DT
> directly.
> 

-- 
Regards,
Shawn

