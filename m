Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab1KNPZk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 10:25:40 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17244 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936Ab1KNPZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 10:25:38 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 14 Nov 2011 07:25:20 -0800
Date: Mon, 14 Nov 2011 17:25:18 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Rob Herring <robherring2@gmail.com>
CC: Stephen Warren <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Colin Cross <ccross@android.com>, "Olof Johansson" <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 01/10] arm/tegra: initial device tree for tegra30
Message-ID: <20111114152518.GJ19069@tbergstrom-lnx.Nvidia.com>
References: <1321010541-31337-1-git-send-email-pdeschrijver@nvidia.com>
 <1321010541-31337-2-git-send-email-pdeschrijver@nvidia.com>
 <4EBDE766.5080505@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4EBDE766.5080505@gmail.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 12, 2011 at 04:26:30AM +0100, Rob Herring wrote:
> On 11/11/2011 05:22 AM, Peter De Schrijver wrote:
> > This patch adds the initial device tree for tegra30
> > 
> > Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> > ---
> >  arch/arm/boot/dts/tegra30.dtsi |  127 ++++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 127 insertions(+), 0 deletions(-)
> >  create mode 100644 arch/arm/boot/dts/tegra30.dtsi
> > 
> > diff --git a/arch/arm/boot/dts/tegra30.dtsi b/arch/arm/boot/dts/tegra30.dtsi
> > new file mode 100644
> > index 0000000..fabe243
> > --- /dev/null
> > +++ b/arch/arm/boot/dts/tegra30.dtsi
> > @@ -0,0 +1,127 @@
> > +/include/ "skeleton.dtsi"
> > +
> > +/ {
> > +	compatible = "nvidia,tegra30";
> 
> Needs documentation.
> 
> > +	interrupt-parent = <&intc>;
> > +
> > +	intc: interrupt-controller@50041000 {
> > +		compatible = "nvidia,tegra30-gic", "nvidia,tegra20-gic";
> > +		interrupt-controller;
> > +		#interrupt-cells = <1>;
> 
> Is the Tegra GIC really different from a standard A9 gic? You need to
> update to use the gic binding. The cells should be 3 for example.

It has an extra 'legacy' interrupt controller like tegra20 has. This is used
when waking up the CPU from power off mode.

Cheers,

Peter.
