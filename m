Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178Ab1KURY7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 12:24:59 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:7726 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756059Ab1KURY4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 12:24:56 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 21 Nov 2011 09:24:39 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Olof Johansson <olof@lixom.net>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Russell King <linux@arm.linux.org.uk>,
        Colin Cross <ccross@android.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Mon, 21 Nov 2011 09:24:38 -0800
Subject: RE: [PATCH 06/10] arm/tegra: prepare pinmux code for multiple tegra
 variants
Thread-Topic: [PATCH 06/10] arm/tegra: prepare pinmux code for multiple
 tegra variants
Thread-Index: AcyoWfY3+QLxxEupTgCBaouOdhq51wAGCrkg
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF174F08C0EC@HQMAIL01.nvidia.com>
References: <1321546766-26770-1-git-send-email-pdeschrijver@nvidia.com>
 <1321546766-26770-7-git-send-email-pdeschrijver@nvidia.com>
 <20111118214116.GC31678@quad.lixom.net>
 <20111121142919.GN19069@tbergstrom-lnx.Nvidia.com>
In-Reply-To: <20111121142919.GN19069@tbergstrom-lnx.Nvidia.com>
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

Peter De Schrijver wrote at Monday, November 21, 2011 7:29 AM:
> On Fri, Nov 18, 2011 at 10:41:16PM +0100, Olof Johansson wrote:
> > On Thu, Nov 17, 2011 at 06:19:20PM +0200, Peter De Schrijver wrote:
> > > This patch modifies the pinmux code to be useable for multiple tegra variants.
> > > Some tegra20 specific constants will be replaced by variables which will be
> > > initialized to the appropriate value at runtime.
...
> > > diff --git a/arch/arm/mach-tegra/board-harmony-pcie.c b/arch/arm/mach-tegra/board-harmony-pcie.c
...
> > > +#include <mach/pinmux-tegra20.h>
> >
> > Boards shouldn't have to include this. The idea is that you should only
> > have to do board code against the pinmux.h interface, which internally
> > abstracts it for tegra 20 vs tegra 30.
> 
> The pinmux naming is still SoC specific. Unless we move this to devicetree
> (which should be part of a different patchset), I don't see how we can solve
> this, except by renaming all the pingroups. That would cause a lot more
> changes though.

I believe that Peter's explanation makes sense.

BTW, re: the new pinmux API: I have a driver for both Tegra20 and Tegra30
now which should work for muxing. All the data is present for all the pin
configs too (tri-state, pull, ...) but we need to define the core pinctrl
API for this before I can expose that. Similarly, we need DT bindings for
all of this before we can make use of it; something I hope to start work
on in the near future.

-- 
nvpublic

