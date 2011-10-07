Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758420Ab1JGSEv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 14:04:51 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19673 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068Ab1JGSEr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 14:04:47 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 07 Oct 2011 11:04:37 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, Erik Gilling <konkers@android.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Fri, 7 Oct 2011 11:04:34 -0700
Subject: RE: [PATCH v7 3/3] arm/tegra: device tree support for ventana board
Thread-Topic: [PATCH v7 3/3] arm/tegra: device tree support for ventana board
Thread-Index: AcyBzxs3AWF0JBHuSg6ka/Z0+AVxcQDS/ZGA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF173B23B2FA@HQMAIL01.nvidia.com>
References: <1317647918-22694-1-git-send-email-pdeschrijver@nvidia.com>
 <1317647918-22694-4-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1317647918-22694-4-git-send-email-pdeschrijver@nvidia.com>
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

Peter De Schrijver wrote at Monday, October 03, 2011 7:19 AM:

...
> diff --git a/arch/arm/boot/dts/tegra-ventana.dts b/arch/arm/boot/dts/tegra-ventana.dts
...
> +	chosen {
> +		bootargs = "vmalloc=192M video=tegrafb console=ttyS0,115200n8 root=/dev/ram rdinit=/sbin/init";

It might be nice to make this identical to what Harmony and Seaboard have here.

Still, it doesn't matter a lot, since I (and I imagine most people) have
to edit this command-line to point at the correct partition for my disks
anyway; eventually, U-Boot should be providing/re-writing this property
too.

...
> diff --git a/arch/arm/mach-tegra/board-dt.c b/arch/arm/mach-tegra/board-dt.c
...
> -	if (of_machine_is_compatible("nvidia,harmony"))
> -		harmony_pinmux_init();
> -	else if (of_machine_is_compatible("nvidia,seaboard"))
> -		seaboard_pinmux_init();
> +	for (i = 0; i < ARRAY_SIZE(pinmux_configs); i++) {
> +		if (of_machine_is_compatible(pinmux_configs[i].machine)) {
> +			pinmux_configs[i].init();
> +			break;
> +		}
> +	}
> +
> +	if (i == ARRAY_SIZE(pinmux_configs))
> +		printk(KERN_WARNING "Unknown platform! Pinmuxing not initialized\n");

Should that be WARN() instead of printk?

-- 
nvpublic

