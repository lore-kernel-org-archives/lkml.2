Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264Ab1HOQKD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 12:10:03 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17057 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018Ab1HOQKA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 12:10:00 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 15 Aug 2011 09:09:43 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Jamie Iles <jamie@jamieiles.com>
CC: Grant Likely <grant.likely@secretlab.ca>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Mon, 15 Aug 2011 09:09:40 -0700
Subject: RE: [RFC PATCH 10/12] arm/tegra: Add device tree support to pinmux
 driver
Thread-Topic: [RFC PATCH 10/12] arm/tegra: Add device tree support to pinmux
 driver
Thread-Index: AcxZppyhURPNo9rsRpG8ue1i4rLcmQBvvckA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF04AEA25055@HQMAIL01.nvidia.com>
References: <1313189697-21287-1-git-send-email-swarren@nvidia.com>
 <1313189697-21287-11-git-send-email-swarren@nvidia.com>
 <20110813104323.GC2643@pulham.picochip.com>
 <20110813104850.GD2643@pulham.picochip.com>
In-Reply-To: <20110813104850.GD2643@pulham.picochip.com>
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

Jamie Iles wrote at Saturday, August 13, 2011 4:49 AM:
> On Sat, Aug 13, 2011 at 11:43:23AM +0100, Jamie Iles wrote:
> > Hi Stephen,
> >
> > On Fri, Aug 12, 2011 at 04:54:55PM -0600, Stephen Warren wrote:
...
> > > diff --git a/arch/arm/mach-tegra/pinmux.c b/arch/arm/mach-tegra/pinmux.c
...
> > > +#ifdef CONFIG_OF
> > > +static void __init tegra_pinmux_probe_dt(struct platform_device *pdev)
> > > +{
> > > +	int pg;
> > > +
> > > +	for (pg = 0; pg < TEGRA_MAX_PINGROUP; pg++) {
> > > +		const char *pg_name = pingroup_name(pg);
> > > +		struct tegra_pingroup_config config;
> > > +		struct device_node *pg_node;
> > > +		int ret;
> > > +		const char *s;
> > > +
> > > +		pg_node = of_find_child_node_by_name(pdev->dev.of_node,
> > > +						     pg_name);
> > > +		if (pg_node == NULL)
> > > +			continue;
> >
> > Rather than iterating over all of the mux names in the pinmux driver and
> > searching for a matching DT node, could you not do it the other way
> > round?  So do an for_each_child_of_node() on the pinmux node then find
> > the matching pingroup keyed by the node name?  This would eliminate
> > of_find_child_node_by_name().  You could also catch invalid
> > configurations for non-existent pins this way.
> 
> I just re-read your introduction email and saw you've already discussed
> this!  Would this require an explicit pin name property though or could
> you just key off of the pg_node->name?

No, I think pg_node->name will work out fine; it's what of_find_child_node_by_name
is using anyway.

-- 
nvpublic

