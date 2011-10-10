Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab1JJIBc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 04:01:32 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11317 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587Ab1JJIB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 04:01:29 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 10 Oct 2011 01:01:11 -0700
Date: Mon, 10 Oct 2011 11:01:09 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, Erik Gilling <konkers@android.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 3/3] arm/tegra: device tree support for ventana board
Message-ID: <20111010080109.GQ9003@tbergstrom-lnx.Nvidia.com>
References: <1317647918-22694-1-git-send-email-pdeschrijver@nvidia.com>
 <1317647918-22694-4-git-send-email-pdeschrijver@nvidia.com>
 <74CDBE0F657A3D45AFBB94109FB122FF173B23B2FA@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF173B23B2FA@HQMAIL01.nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 07, 2011 at 08:04:34PM +0200, Stephen Warren wrote:
> Peter De Schrijver wrote at Monday, October 03, 2011 7:19 AM:
> 
> ...
> > diff --git a/arch/arm/boot/dts/tegra-ventana.dts b/arch/arm/boot/dts/tegra-ventana.dts
> ...
> > +	chosen {
> > +		bootargs = "vmalloc=192M video=tegrafb console=ttyS0,115200n8 root=/dev/ram rdinit=/sbin/init";
> 
> It might be nice to make this identical to what Harmony and Seaboard have here.
> 
> Still, it doesn't matter a lot, since I (and I imagine most people) have
> to edit this command-line to point at the correct partition for my disks
> anyway; eventually, U-Boot should be providing/re-writing this property
> too.
> 
> ...
> > diff --git a/arch/arm/mach-tegra/board-dt.c b/arch/arm/mach-tegra/board-dt.c
> ...
> > -	if (of_machine_is_compatible("nvidia,harmony"))
> > -		harmony_pinmux_init();
> > -	else if (of_machine_is_compatible("nvidia,seaboard"))
> > -		seaboard_pinmux_init();
> > +	for (i = 0; i < ARRAY_SIZE(pinmux_configs); i++) {
> > +		if (of_machine_is_compatible(pinmux_configs[i].machine)) {
> > +			pinmux_configs[i].init();
> > +			break;
> > +		}
> > +	}
> > +
> > +	if (i == ARRAY_SIZE(pinmux_configs))
> > +		printk(KERN_WARNING "Unknown platform! Pinmuxing not initialized\n");
> 
> Should that be WARN() instead of printk?

pr_warning() might be better. Or do we want a backtrace and a tainted kernel
in this case? 

Cheers,

Peter.
