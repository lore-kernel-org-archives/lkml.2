Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab1KGTKp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 14:10:45 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2679 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab1KGTKo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 14:10:44 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 07 Nov 2011 11:10:31 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Mon, 7 Nov 2011 11:10:29 -0800
Subject: RE: [PATCH v3 0/8] Add support for tegra30 and cardhu
Thread-Topic: [PATCH v3 0/8] Add support for tegra30 and cardhu
Thread-Index: AcydWGNKXFXijC73Tn6w/d5NU1b3XgAJ8SzQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF173F9A50F3@HQMAIL01.nvidia.com>
References: <1320675617-20751-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1320675617-20751-1-git-send-email-pdeschrijver@nvidia.com>
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

Peter De Schrijver wrote at Monday, November 07, 2011 7:20 AM:
> This patchset adds support for the tegra30 SoC and the cardhu development
> board.
> 
> Pathset is on top of Will Deacon's ARM reset work.

A few minor issues:

1) If I enable just ARCH_TEGRA_3x_SOC, but not ARCH_TEGRA_2x_SOC, the
kernel fails to build because arch/arm/mach-tegra/include/mach/irqs.h
only defines NR_IRQS if ARCH_TEGRA_2x_SOC is defined.

2) All the Tegra20 boards don't depend on ARCH_TEGRA_2x_SOC, so they can
be enabled even if only Tegra30 support is enabled.

3) I notice that in "arm/tegra: pinmux tables and definitions for tegra30",
you ifdef'd the two entries in tegra_pinmux_of_match[] based on which SoCs
were enabled, but in "arm/tegra: implement support for tegra30", you didn't
do the same for the two entries in early_init[] (board-dt.c). I'm not sure
how far we want to take only-Tegra20 or only-Tegra30 support, but perhaps
we should be consistent here?

I've tested this series on Harmony both booting with a board file and booting
using device-tree and don't see any issues. I'll try to test it on Cardhu
later today.

-- 
nvpublic

