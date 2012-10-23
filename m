Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933251Ab2JWTlt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 15:41:49 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:40049 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756852Ab2JWTls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 15:41:48 -0400
X-Authenticated: #9962044
X-Provags-ID: V01U2FsdGVkX1/0O9k0NxH0U7OQvOSQa1xXzK3SMsTjNM3j+SAoeU
	yhngCYvhDJ17j4
From: Marc Dietrich <marvin24@gmx.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Pavan Kunapuli <pkunapuli@nvidia.com>, linux@arm.linux.org.uk,
        cjb@laptop.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: dt: tegra: Add sdhci regulators
Date: Tue, 23 Oct 2012 21:41:03 +0200
Message-ID: <2541818.PkGB9YPA25@ax5200p>
User-Agent: KMail/4.8.5 (Linux/3.5.0-17-generic; KDE/4.8.5; x86_64; ; )
In-Reply-To: <5086E503.8090604@wwwdotorg.org>
References: <1350976740-19284-1-git-send-email-pkunapuli@nvidia.com> <4346406.Jy2o1pWcOR@ax5200p> <5086E503.8090604@wwwdotorg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 October 2012 12:42:11 Stephen Warren wrote:
> On 10/23/2012 12:07 PM, Marc Dietrich wrote:
> > Pavan,
> > 
> > On Tuesday 23 October 2012 12:48:59 Pavan Kunapuli wrote:
> >> Adding vmmc and vmmcq supplies for sdhci nodes
> >> in tegra dt files.
> > 
> > <...>
> > 
> >> diff --git a/arch/arm/boot/dts/tegra20-paz00.dts
> >> b/arch/arm/boot/dts/tegra20-paz00.dts index 6a93d14..e161b65 100644
> >> --- a/arch/arm/boot/dts/tegra20-paz00.dts
> >> +++ b/arch/arm/boot/dts/tegra20-paz00.dts
> >> @@ -422,13 +422,17 @@
> >> 
> >>  		status = "okay";
> >>  		cd-gpios = <&gpio 173 0>; /* gpio PV5 */
> >>  		wp-gpios = <&gpio 57 0>;  /* gpio PH1 */
> >> 
> >> -		power-gpios = <&gpio 169 0>; /* gpio PV1 */
> >> 
> >>  		bus-width = <4>;
> >> 
> >> +		vmmc-supply = <&vddio_sd_reg>;
> >> +		vqmmc-supply = <&vddio_sd_reg>;
> >> 
> >>  	};
> >>  	
> >>  	sdhci@c8000600 {
> >>  	
> >>  		status = "okay";
> >>  		bus-width = <8>;
> >> 
> >> +		vmmc-supply = <&vddio_sdmmc_reg>;
> >> +		vqmmc-supply = <&vddio_sdmmc_reg>;
> > 
> > to make it better, this should be:
> > 
> > vmmc-supply = <&vcore_mmc_reg>; and
> > vqmmc-supply = <&vddio_nand_reg>;
> > 
> > with vcore_mmc_reg is ldo5 and vddio_nand_reg is the fixed regulator
> > below.
> 
> I think for the eMMC (not SD card), the core supply is actually +3vs_s3,
> and hence fixed; it looks like LDO5 used to be used, but they changed
> it. See the note for the VCC connections on the eMMC chip.

yes, you are right. The schematic had a comment that this was changed.

> > By doing so, I get "sdhci-tegra sdhci-tegra.3: could not set regulator OCR
> > (-1)". MMC subsys wants to set ldo5 to 3.3V but it is fixed. I guess
> > that's
> > harmless for now.
> 
> What I mention above might end up fixing that?

yes, it does.

So the original patch is just fine. Sorry for the noise.

Marc

