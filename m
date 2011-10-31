Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326Ab1JaJDL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 05:03:11 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9092 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932221Ab1JaJDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 05:03:10 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 31 Oct 2011 02:02:52 -0700
Date: Mon, 31 Oct 2011 11:02:49 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 2/6] arm/tegra: prepare pinmux code for multiple tegra
 variants
Message-ID: <20111031090249.GL1001@tbergstrom-lnx.Nvidia.com>
References: <1319561644-6160-1-git-send-email-pdeschrijver@nvidia.com>
 <1319561644-6160-3-git-send-email-pdeschrijver@nvidia.com>
 <74CDBE0F657A3D45AFBB94109FB122FF173E1B49AA@HQMAIL01.nvidia.com>
 <20111028081738.GA12383@tbergstrom-lnx.Nvidia.com>
 <74CDBE0F657A3D45AFBB94109FB122FF173EDAB4A4@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF173EDAB4A4@HQMAIL01.nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 06:18:27PM +0200, Stephen Warren wrote:
> Peter De Schrijver wrote at Friday, October 28, 2011 2:18 AM:
> > On Thu, Oct 27, 2011 at 09:59:49PM +0200, Stephen Warren wrote:
> > > Peter De Schrijver wrote at Tuesday, October 25, 2011 10:54 AM:
> > > > This patch modifies the pinmux code to be useable for multiple tegra variants.
> > > > Some tegra20 specific constants will be replaced by variables which will be
> > > > initialized to the appropriate value at runtime.
> ...
> > > > @@ -668,11 +668,24 @@ void tegra_pinmux_config_pullupdown_table(const struct tegra_pingroup_config *co
> > > >  	}
> > > >  }
> > > >
> > > > +static struct of_device_id tegra_pinmux_of_match[] __devinitdata = {
> > > > +	{ .compatible = "nvidia,tegra20-pinmux", tegra20_pinmux_init },
> > > > +	{ },
> > > > +};
> > > > +
> > > >  static int __devinit tegra_pinmux_probe(struct platform_device *pdev)
> > > >  {
> > > >  	struct resource *res;
> > > >  	int i;
> > > >  	int config_bad = 0;
> > > > +	const struct of_device_id *match;
> > > > +
> > > > +#ifdef CONFIG_OF
> > > > +	match = of_match_device(tegra_pinmux_of_match, &pdev->dev);
> > >
> > > What if match==NULL? I suppose that "can't" happen with DT, since the
> > > device wouldn't have been probed unless there was a matching entry...
> > 
> > Exactly. That was my reasoning as well. We can't get here unless there is a
> > match.
> > 
> > > Does this work when booting without DT; IIRC the internal patches I saw
> > > fell back to hard-coding a call to tegra20_pinmux_init() when booting
> > > a static board file (i.e. not booting device-tree)? Perhaps that's in a
> > 

Indeed. Something went wrong here.

> > Unfortunately I don't have a tegra20 board which is supported without
> > devicetree.
> 
> Oh, that's quite unfortunate. Still, you need to write the code so it's
> expected to work for the non-DT case. Once you've fixed this, if you
> push a complete branch somewhere, I can boot-test it on a few non-DT
> boards. Hopefully I can test on Cardhu too.

I know. But alas I have to base myself on assumptions, which is suboptimal of
course. I will see if I can find a tegra20 board which doesn't require
devicetree here in finland or push a complete branch somewhere.

Cheers,

Peter.

