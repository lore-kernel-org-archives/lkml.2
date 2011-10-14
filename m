Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872Ab1JNHPW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 03:15:22 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34715 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317Ab1JNHPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 03:15:20 -0400
Date: Fri, 14 Oct 2011 08:15:00 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Olof Johansson <olof@lixom.net>
Cc: Stephen Warren <swarren@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "Colin Cross (ccross@android.com)" <ccross@android.com>,
        Erik Gilling <konkers@android.com>,
        "Arnd Bergmann (arnd@arndb.de)" <arnd@arndb.de>
Subject: Re: [PATCH] arm/tegra: select AUTO_ZRELADDR by default
Message-ID: <20111014071500.GP21648@n2100.arm.linux.org.uk>
References: <1317172068-14872-1-git-send-email-pdeschrijver@nvidia.com> <74CDBE0F657A3D45AFBB94109FB122FF173955580F@HQMAIL01.nvidia.com> <CAOesGMiuzF47kdmaaFny9Fg1ieox6a75tMFfLRAptvDxz_QPMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOesGMiuzF47kdmaaFny9Fg1ieox6a75tMFfLRAptvDxz_QPMg@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 04:38:46PM -0700, Olof Johansson wrote:
> Hi,
> 
> On Wed, Sep 28, 2011 at 10:50 AM, Stephen Warren <swarren@nvidia.com> wrote:
> > Peter De Schrijver wrote at Tuesday, September 27, 2011 7:08 PM:
> >> This patch causes the kernel uncompressor to determine the physical address
> >> of the SDRAM at runtime. This allows the kernel to boot on both tegra20 and
> >> tegra30 even though SDRAM is at different physical addresses on both SoCs.
> >>
> >> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> >
> > An alternative would be to simply add that config option to the relevant
> > defconfig/.config file. I see both cases in use in the kernel. Still, the
> > code change this enables looks fine to just turn on all the time, and will
> > be needed for Tegra30 support, so I'm fine just selecting it as you have.
> >
> > Acked-by: Stephen Warren <swarren@nvidia.com>
> >
> >> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> >> index 472a7f8..474737b 100644
> >> --- a/arch/arm/Kconfig
> >> +++ b/arch/arm/Kconfig
> >> @@ -596,6 +596,7 @@ config ARCH_TEGRA
> >>       select HAVE_CLK
> >>       select HAVE_SCHED_CLOCK
> >>       select ARCH_HAS_CPUFREQ
> >> +     select AUTO_ZRELADDR
> >>       help
> >>         This enables support for NVIDIA Tegra based systems (Tegra APX,
> >>         Tegra 6xx and Tegra 2 series).
> >
> > P.S. Since this patch relates to Tegra, you should CC the Tegra maintainers
> > and list; I've done so on this message. I also added Arnd; he might take
> > this through the arm-soc tree.
> 
> While it does touch a file outside of arch/arm/mach-tegra, it's for
> the tegra options and is not likely to cause conflicts upstream. I'll
> apply it with the rest of tegra patches for 3.2 here.
> 
> So: Applied, thanks.

I'll point out that this makes Tegra incompatible with ZBOOT_ROM, which
can still be enabled.  ZBOOT_ROM=y AUTO_ZRELADDR=y is an invalid
configuration at runtime.
