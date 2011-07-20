Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab1GTSkh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 14:40:37 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13333 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096Ab1GTSkg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 14:40:36 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 20 Jul 2011 11:40:29 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Erik Gilling <konkers@android.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>
Date: Wed, 20 Jul 2011 11:40:28 -0700
Subject: RE: [PATCH] arm/dt: tegra devicetree support
Thread-Topic: [PATCH] arm/dt: tegra devicetree support
Thread-Index: AcxHC0FL8yktUj+ITnG+KyOGjI8bjAAAIgag
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF049EBDEF01@HQMAIL01.nvidia.com>
References: <20110719234158.2779.15394.stgit@ponder>
 <74CDBE0F657A3D45AFBB94109FB122FF049EBDEE27@HQMAIL01.nvidia.com>
 <20110720160355.GB2406@sirena.org.uk>
 <20110720183133.GE4642@ponder.secretlab.ca>
In-Reply-To: <20110720183133.GE4642@ponder.secretlab.ca>
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

Grant Likely wrote at Wednesday, July 20, 2011 12:32 PM:
> On Wed, Jul 20, 2011 at 05:03:55PM +0100, Mark Brown wrote:
> > On Wed, Jul 20, 2011 at 08:37:19AM -0700, Stephen Warren wrote:
> > > Grant Likely wrote at Tuesday, July 19, 2011 5:43 PM:
> >
> > > > +	sound {
> > > > +		compatible = "nvidia,harmony-sound", "nvidia,tegra-wm8903";
> >
> > > I thought the sound bindings were still somewhat experimental and not
> > > completely agreed upon. One issue I see is that Device Tree is
> > > supposed to represent pure HW, rather than driver-required abstractions,
> > > and at least the compatible name here is pretty Linux-driver-specific.
> >
> > The current decision is that the schematic for embedded audio hardware
> > is sufficiently interesting to be considered hardware in its own right
> > separately to the chips contained within it.
> 
> Correct.  For complex composite devices like audio, it is completely
> appropriate to have a root node that represents the entire complex and
> how it is wired together.

Sure, that makes sense.

> The compatible property here definitely represents the hardware
> because it reflects the sound infrastructure on the harmony board.

I can see that argument for "nvidia,harmony-sound".

But "nvidia,tegra-wm8903" is pretty generic; I can certainly see there
being Tegra 20 systems that use a WM8903 but are so different from either
Harmony or anything supported by sound/soc/tegra/tegra_wm8903.c that the
existing driver isn't applicable. And hence, there may be a different
ASoC driver for such board(s), and hence choosing such a generic name as
"tegra-wm8903" for Harmony/Seaboard's audio layout seems like it might
cause problems in the future.

I'm fine with such a generic name for the platform driver, since that name
can fairly easily be modified just by editing the driver and the board file.
But since *.dts files are at least logically separate from the kernel, such
naming future-proofing is a little more important.

-- 
nvpublic

