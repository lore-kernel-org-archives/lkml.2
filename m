Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab1LLA0X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 19:26:23 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55830 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614Ab1LLA0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 19:26:20 -0500
Date: Sun, 11 Dec 2011 16:26:16 -0800
From: Olof Johansson <olof@lixom.net>
To: Rob Herring <robherring2@gmail.com>
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Russell King <linux@arm.linux.org.uk>,
        Colin Cross <ccross@android.com>, Stephen Warren <swarren@nvidia.com>,
        Gary King <gking@nvidia.com>, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH v6 10/10] arm/tegra: add support for tegra30 based board
 cardhu
Message-ID: <20111212002616.GB26598@quad.lixom.net>
References: <1323348254-29072-1-git-send-email-pdeschrijver@nvidia.com>
 <1323348254-29072-11-git-send-email-pdeschrijver@nvidia.com>
 <4EE21B67.5040006@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EE21B67.5040006@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 09, 2011 at 08:29:59AM -0600, Rob Herring wrote:
> On 12/08/2011 06:43 AM, Peter De Schrijver wrote:
> > Add support for the tegra30 based cardhu development board. Cardhu is a tablet
> > formfactor reference design for tegra30. The patch provides a device tree for
> > the board, updates Makefile.boot to build the dtb, includes the platform in
> > Kconfig and updates board-dt.c.
> > 
> > Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> > ---
> >  arch/arm/boot/dts/tegra-cardhu.dts |   36 ++++++++++++++++++++++++++++++++++++
> >  arch/arm/mach-tegra/Kconfig        |    7 +++++++
> >  arch/arm/mach-tegra/Makefile.boot  |    1 +
> >  arch/arm/mach-tegra/board-dt.c     |    1 +
> >  4 files changed, 45 insertions(+), 0 deletions(-)
> >  create mode 100644 arch/arm/boot/dts/tegra-cardhu.dts
> > 
> > diff --git a/arch/arm/boot/dts/tegra-cardhu.dts b/arch/arm/boot/dts/tegra-cardhu.dts
> > new file mode 100644
> > index 0000000..70c41fc
> > --- /dev/null
> > +++ b/arch/arm/boot/dts/tegra-cardhu.dts
> > @@ -0,0 +1,36 @@
> > +/dts-v1/;
> > +
> > +/include/ "tegra30.dtsi"
> > +
> > +/ {
> > +	model = "NVIDIA Tegra30 Cardhu evaluation board";
> > +	compatible = "nvidia,cardhu", "nvidia,tegra30";
> > +
> > +	memory {
> 
> memory@80000000

If there is only one memory node, then there is no need to specify the unit
address after the name, it's just noise.

> > diff --git a/arch/arm/mach-tegra/Kconfig b/arch/arm/mach-tegra/Kconfig
> > index aad54ca..6bae1bb 100644
> > --- a/arch/arm/mach-tegra/Kconfig
> > +++ b/arch/arm/mach-tegra/Kconfig
> > @@ -91,6 +91,13 @@ config MACH_VENTANA
> >         help
> >           Support for the nVidia Ventana development platform
> >  
> > +config MACH_CARDHU
> > +       bool "Cardhu board"
> > +       depends on ARCH_TEGRA_3x_SOC
> > +       select MACH_TEGRA_DT
> > +       help
> > +         Support for the NVIDIA Cardhu development platform
> > +
> 
> You should not be adding kconfig entries for boards. They should
> eventually go away with DT.

Agreed. On Tegra2 we still want board configs since it allows us to leave out
some of the kernel code that is still per-board (i.e. pinmux tables, etc). Once
that has been moved to device tree we can remove all board kconfig options
there. We might as well not start adding them on T30.

> >  choice
> >          prompt "Low-level debug console UART"
> >          default TEGRA_DEBUG_UART_NONE
> > diff --git a/arch/arm/mach-tegra/Makefile.boot b/arch/arm/mach-tegra/Makefile.boot
> > index cf51a00..7c1110f 100644
> > --- a/arch/arm/mach-tegra/Makefile.boot
> > +++ b/arch/arm/mach-tegra/Makefile.boot
> > @@ -7,3 +7,4 @@ dtb-$(CONFIG_MACH_PAZ00) += tegra-paz00.dtb
> >  dtb-$(CONFIG_MACH_SEABOARD) += tegra-seaboard.dtb
> >  dtb-$(CONFIG_MACH_TRIMSLICE) += tegra-trimslice.dtb
> >  dtb-$(CONFIG_MACH_VENTANA) += tegra-ventana.dtb
> > +dtb-$(CONFIG_MACH_CARDHU) += tegra-cardhu.dtb
> 
> Likewise, this should be more like:
> dtb-$(CONFIG_MACH_TEGRA_DT) += tegra-seaboard.dtb tegra-trimslice.dtb
> tegra-ventana.dtb ...

Actually, the cardhu dts CONFIG_ARCH_TEGRA_3x_SOC, since there will only be DT
boards for that platform.

Moving the others to TEGRA_DT is a later change (see above comments about some
C code still needed).


-Olof

