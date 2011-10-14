Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933092Ab1JNOpa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 10:45:30 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11533 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010Ab1JNOp0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 10:45:26 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 14 Oct 2011 07:45:16 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Olof Johansson <olof@lixom.net>
CC: Peter De Schrijver <pdeschrijver@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "Colin Cross (ccross@android.com)" <ccross@android.com>,
        Erik Gilling <konkers@android.com>,
        "Arnd Bergmann (arnd@arndb.de)" <arnd@arndb.de>
Date: Fri, 14 Oct 2011 07:45:15 -0700
Subject: RE: [PATCH] arm/tegra: select AUTO_ZRELADDR by default
Thread-Topic: [PATCH] arm/tegra: select AUTO_ZRELADDR by default
Thread-Index: AcyKQQXWgvFmJMOuSX+lSWwPx05m4wAPmQ+w
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF173BE1A260@HQMAIL01.nvidia.com>
References: <1317172068-14872-1-git-send-email-pdeschrijver@nvidia.com>
 <74CDBE0F657A3D45AFBB94109FB122FF173955580F@HQMAIL01.nvidia.com>
 <CAOesGMiuzF47kdmaaFny9Fg1ieox6a75tMFfLRAptvDxz_QPMg@mail.gmail.com>
 <20111014071500.GP21648@n2100.arm.linux.org.uk>
In-Reply-To: <20111014071500.GP21648@n2100.arm.linux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King wrote at Friday, October 14, 2011 1:15 AM:
> On Thu, Oct 13, 2011 at 04:38:46PM -0700, Olof Johansson wrote:
> > Hi,
> >
> > On Wed, Sep 28, 2011 at 10:50 AM, Stephen Warren <swarren@nvidia.com> wrote:
> > > Peter De Schrijver wrote at Tuesday, September 27, 2011 7:08 PM:
> > >> This patch causes the kernel uncompressor to determine the physical address
> > >> of the SDRAM at runtime. This allows the kernel to boot on both tegra20 and
> > >> tegra30 even though SDRAM is at different physical addresses on both SoCs.
> > >>
> > >> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> > >
> > > An alternative would be to simply add that config option to the relevant
> > > defconfig/.config file. I see both cases in use in the kernel. Still, the
> > > code change this enables looks fine to just turn on all the time, and will
> > > be needed for Tegra30 support, so I'm fine just selecting it as you have.
> > >
> > > Acked-by: Stephen Warren <swarren@nvidia.com>
> > >
> > >> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> > >> index 472a7f8..474737b 100644
> > >> --- a/arch/arm/Kconfig
> > >> +++ b/arch/arm/Kconfig
> > >> @@ -596,6 +596,7 @@ config ARCH_TEGRA
> > >>       select HAVE_CLK
> > >>       select HAVE_SCHED_CLOCK
> > >>       select ARCH_HAS_CPUFREQ
> > >> +     select AUTO_ZRELADDR
> > >>       help
> > >>         This enables support for NVIDIA Tegra based systems (Tegra APX,
> > >>         Tegra 6xx and Tegra 2 series).
> > >
> > > P.S. Since this patch relates to Tegra, you should CC the Tegra maintainers
> > > and list; I've done so on this message. I also added Arnd; he might take
> > > this through the arm-soc tree.
> >
> > While it does touch a file outside of arch/arm/mach-tegra, it's for
> > the tegra options and is not likely to cause conflicts upstream. I'll
> > apply it with the rest of tegra patches for 3.2 here.
> >
> > So: Applied, thanks.
> 
> I'll point out that this makes Tegra incompatible with ZBOOT_ROM, which
> can still be enabled.  ZBOOT_ROM=y AUTO_ZRELADDR=y is an invalid
> configuration at runtime.

I see that at least one machine solves that by doing:

config ARCH_EP93XX
...
        select AUTO_ZRELADDR if !ZBOOT_ROM

That said, given the way Tegra works, ZBOOT_ROM isn't useful; typically,
systems don't use NOR flash for storage of the kernel, so I don't think
ZBOOT_ROM is likely to be used. Perhaps we should just depend on !ZBOOT_ROM?

-- 
nvpublic

