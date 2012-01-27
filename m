Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592Ab2A0ISe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 03:18:34 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11910 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab2A0ISc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 03:18:32 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 27 Jan 2012 00:18:13 -0800
Date: Fri, 27 Jan 2012 10:18:02 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@nvidia.com>
CC: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        "Russell King" <linux@arm.linux.org.uk>, Gary King <gking@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 3/8] ARM: tegra: rework Tegra secondary CPU core
 bringup
Message-ID: <20120127081802.GU29914@tbergstrom-lnx.Nvidia.com>
References: <1327597641-7519-1-git-send-email-pdeschrijver@nvidia.com>
 <1327597641-7519-4-git-send-email-pdeschrijver@nvidia.com>
 <74CDBE0F657A3D45AFBB94109FB122FF178CB8246B@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF178CB8246B@HQMAIL01.nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 26, 2012 at 09:25:53PM +0100, Stephen Warren wrote:
> Peter De Schrijver wrote at Thursday, January 26, 2012 10:07 AM:
> > Prepare the Tegra secondary CPU core bringup code for other Tegra variants.
> > The reset handler is also generalized to allow for future introduction of
> > powersaving modes which turn off the CPU cores.
> 
> > diff --git a/arch/arm/mach-tegra/headsmp.S b/arch/arm/mach-tegra/headsmp.S
> 
> >  ENTRY(tegra_secondary_startup)
> ...
> > +	enable_coresight r0
> 
> > +ENTRY(__tegra_cpu_reset_handler)
> > +
> > +#if DEBUG_CPU_RESET_HANDLER
> > +	enable_coresight r0
> > +	b	.
> > +#endif
> 
> I'm not sure why the macro call enable_coresight is ifdef'd in one place
> but not the other... Should just the instruction "b ." be inside the
> ifdef?
> 

This code path will also be used by LP2 and LP1 resume in the future, I'm not
sure we should unconditionally enable Coresight in that case.

> > diff --git a/arch/arm/mach-tegra/reset.c b/arch/arm/mach-tegra/reset.c
> 
> > +static void tegra_cpu_reset_handler_enable(void)
> 
> > +	/*
> > +	 * Prevent further modifications to the physical reset vector.
> > +	 *  NOTE: Has no effect on chips prior to Tegra30.
> > +	 */
> > +	reg = readl(sb_ctrl);
> > +	reg |= 2;
> > +	writel(reg, sb_ctrl);
> > +	wmb();
> 
> Should we skip that on Tegra20 then?
> 

Might make sense. OTOH the bit is just unused on Tegra20 so the write doesn't
cause any harm.

> > +void __init tegra_cpu_reset_handler_init(void)
> > +{
> > +	unsigned long *cpu_reset_data_start, *cpu_reset_data_end;
> 
> Those variables are unused.

Indeed... Leftover from the past...

Cheers,

Peter.
