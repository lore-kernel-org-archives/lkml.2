Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277Ab1HQLhg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 07:37:36 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60225 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898Ab1HQLhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 07:37:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Warren <swarren@nvidia.com>
Subject: Re: [RFC PATCH v2 06/13] docs/dt: Document nvidia,tegra20-pinmux binding
Date: Wed, 17 Aug 2011 13:37:25 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Linus Walleij <linus.walleij@linaro.org>, Jamie Iles <jamie@jamieiles.com>,
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
        Shawn Guo <shawn.guo@freescale.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>
References: <1313440100-17131-1-git-send-email-swarren@nvidia.com> <201108161551.31389.arnd@arndb.de> <74CDBE0F657A3D45AFBB94109FB122FF04AEA2537D@HQMAIL01.nvidia.com>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF04AEA2537D@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108171337.26166.arnd@arndb.de>
X-Provags-ID: V02:K0:VEV+CjS1UGDTkjCCLeTcXtj20/G0CcVGOsS47Ds2Reu
 BSAPhusA1rPrXkwea6BrPJ5gOmm4xCRJVD4CWHWfFOFJW+UyLH
 wlXdqBJbqEvlI5KIv/vAOSwBuVx7QRNPHw6KS5NpBoNfp8BwhL
 bODzvxeGnlpmYpvUAVNgIcOUfurbd47aArCIqoplWHxJAzSGbr
 kZvUWFdFplA5Nevq+fj/A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 August 2011, Stephen Warren wrote:
> Arnd Bergmann wrote at Tuesday, August 16, 2011 7:52 AM:
> > On Monday 15 August 2011, Stephen Warren wrote:
> 
> > The contents of this file seem to be specific to even just one
> > version of the tegra chip, and might be completely different for
> > tegra30 and later, right?
> 
> The general concepts are the same between tegra20 and tegra30.
> 
> Tegra30 has a different set of mux and drive pingroups.
> 
> Tegra30 has more functions that can be assigned to pins.
> 
> Tegra30 has three more options per mux pingroup, although I haven't
> Investigated whether any of those would need to be represented in DT;
> I suspect at least one will, possibly all.

Thanks for the info!
 
> Two things to note about Tegra that might not apply to all SoCs:
> 
> * There are separate groups of pins for Muxing (plus some config) vs.
> drive-strength (and related config). Some SoCs might use the same set
> of groups for both. Perhaps some SoC might even have three or more types
> of groups! I expect this to have some impact on the binding; I created
> explicit mux-groups and drive-groups sub-nodes to represent this.
>
> * Tegra's pinmux apply settings to groups of pins instead of individual
> pins. Some SoCs might allow each setting to be configurable per-pin.
> I don't expect this to have any impact as far as the bindings go though;
> it'll simply impact the names of the available pin "groups"; some SoCs
> will name groups, others pins.

ok, makes sense. So if we want to have a general binding that applies
to all, we really need to cover a lot of different ways to set these up.

> > > +Each mux pin group is represented as a sub-node of the nvidia,mux-groups node.
> > > +The name of the sub-node should be the name of the mux pingroup. The following
> > > +names are valid:
> > > +
> > > +	ata
> > > +	atb
> > > +	atc
> > > +	atd
> > > +	ate
> > > +	cdev1
> > > +	cdev2
> > > ...
> > 
> > I noticed that each board you define has a complete list of these. Would
> > it be possible to move a generic list into a tegra20-pinmux.dtsi file and
> > just override the pins in the per-board .dts file that require some special
> > setup?
> 
> I'm not sure how much commonality there will really be.
> 
> Certainly, many boards are based off our reference designs and so will
> have many similarities that could be shared.
> 
> That said, comparing even tegra-harmony.dts and tegra-seaboard.dts shows
> a lot of differences. It seems a lot less error-prone to just completely
> describe the entire pinmux state in each board's .dts file, rather than
> trying to represent half the information as default in the SoC .dtsi file,
> and just the diff in the board .dts file. I suppose perhaps if we put the
> hardware's own default settings in tegra20.dtsi, that'd make sense, since
> people are presumably reasonably aware of the delta relative to that.
> 
> We'd need to add new properties to override defaults, like:
> 
> nvidia,tristate --> nvidia,drive
> nvidia,pull-*   --> nvidia,no-pull

The split I had in mind is more to the effect that the .dtsi file
describes the set of pins that is there with their names and addresses,
while the board specific file describes how they are set up. Does that
make sense? I think I'm still missing some essential aspect of what the
pinmux code actually does ;-)

I now saw that you have the full description in the
arch/arm/mach-tegra/pinmux-t2-tables.c and arch/arm/mach-tegra/pinmux.c
files, with all the names again, and apparently your patch set leaves
these around. Do you think it's possible to actually move the static
tables from there into the device tree and do the entire setup based
on that?

	Arnd
