Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab1I1Rdt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 13:33:49 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2183 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479Ab1I1Rdr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 13:33:47 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 28 Sep 2011 10:33:33 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>
CC: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Wed, 28 Sep 2011 10:33:32 -0700
Subject: RE: [PATCH v4 3/3] arm/tegra: device tree support for ventana board
Thread-Topic: [PATCH v4 3/3] arm/tegra: device tree support for ventana board
Thread-Index: Acx+AcZrCcLNj8qPR66/p6+rG3lEMQAApaYA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1739555801@HQMAIL01.nvidia.com>
References: <1317171902-14736-1-git-send-email-pdeschrijver@nvidia.com>
 <1317171902-14736-4-git-send-email-pdeschrijver@nvidia.com>
 <201109281516.42513.arnd@arndb.de>
 <20110928171151.GN21166@tbergstrom-lnx.Nvidia.com>
In-Reply-To: <20110928171151.GN21166@tbergstrom-lnx.Nvidia.com>
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

Peter De Schrijver wrote at Wednesday, September 28, 2011 11:12 AM:
> On Wed, Sep 28, 2011 at 03:16:42PM +0200, Arnd Bergmann wrote:
> > On Wednesday 28 September 2011, Peter De Schrijver wrote:
> > > --- a/arch/arm/mach-tegra/board-dt.c
...
> > > @@ -95,6 +95,8 @@ static void __init tegra_dt_init(void)
> > >                 harmony_pinmux_init();
> > >         else if (of_machine_is_compatible("nvidia,seaboard"))
> > >                 seaboard_pinmux_init();
> > > +       else if (of_machine_is_compatible("nvidia,ventana"))
> > > +               ventana_pinmux_init();
> >
> > Are you (Peter, Colin, Olof) confident that this is not getting out
> > of hand before it's getting better?
> >
> 
> We don't planning to add more derived boards besides ventana until we have the
> devicetree bindings for the new pinmux API in at which point this code
> will become obsolete.

Well, I think there will be one more; we're hoping to start uptreaming Tegra30
support soon, and the reference board for that will be Cardhu. That'll likely
happen before we have the initialize-pinmux-from-device-tree patches complete,
since I'm holding those off until we all think about whether the new pinmux API
core should be driving the initialization rather than individual pinmux drivers.

But, I hope Ventana and Cardhu will be the last before that's in place.

If not, we can certainly switch these if's to a table.

-- 
nvpublic

