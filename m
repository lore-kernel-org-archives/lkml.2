Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932954Ab2BBRca (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 12:32:30 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16027 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932586Ab2BBRcZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 12:32:25 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 02 Feb 2012 09:32:13 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>, Gary King <gking@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 2 Feb 2012 09:32:12 -0800
Subject: RE: [PATCH v1 3/8] ARM: tegra: rework Tegra secondary CPU core
 bringup
Thread-Topic: [PATCH v1 3/8] ARM: tegra: rework Tegra secondary CPU core
 bringup
Thread-Index: AczczDbIaESii6t4S1qd9+3rsKA/kQFBDXXQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF178E124A8B@HQMAIL01.nvidia.com>
References: <1327597641-7519-1-git-send-email-pdeschrijver@nvidia.com>
 <1327597641-7519-4-git-send-email-pdeschrijver@nvidia.com>
 <74CDBE0F657A3D45AFBB94109FB122FF178CB8246B@HQMAIL01.nvidia.com>
 <20120127081802.GU29914@tbergstrom-lnx.Nvidia.com>
In-Reply-To: <20120127081802.GU29914@tbergstrom-lnx.Nvidia.com>
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

Peter De Schrijver wrote at Friday, January 27, 2012 1:18 AM:
> On Thu, Jan 26, 2012 at 09:25:53PM +0100, Stephen Warren wrote:
> > Peter De Schrijver wrote at Thursday, January 26, 2012 10:07 AM:
> > > Prepare the Tegra secondary CPU core bringup code for other Tegra variants.
> > > The reset handler is also generalized to allow for future introduction of
> > > powersaving modes which turn off the CPU cores.
> >
> > > diff --git a/arch/arm/mach-tegra/headsmp.S b/arch/arm/mach-tegra/headsmp.S
> >
> > >  ENTRY(tegra_secondary_startup)
> > ...
> > > +	enable_coresight r0
> >
> > > +ENTRY(__tegra_cpu_reset_handler)
> > > +
> > > +#if DEBUG_CPU_RESET_HANDLER
> > > +	enable_coresight r0
> > > +	b	.
> > > +#endif
> >
> > I'm not sure why the macro call enable_coresight is ifdef'd in one place
> > but not the other... Should just the instruction "b ." be inside the
> > ifdef?
> 
> This code path will also be used by LP2 and LP1 resume in the future, I'm not
> sure we should unconditionally enable Coresight in that case.

What I'm unclear on is why it's a good idea to unconditionally enable
coresight in tegra_secondary_startup if it's not a good idea to
unconditionally enable it in __tegra_cpu_reset_handler.

-- 
nvpublic

