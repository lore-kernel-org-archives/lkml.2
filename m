Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933375Ab1KBQja (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 12:39:30 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10584 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932601Ab1KBQj2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 12:39:28 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 02 Nov 2011 09:39:22 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>, Gary King <gking@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 2 Nov 2011 09:39:21 -0700
Subject: RE: [PATCH] arm/tegra: add support for tegra30 interrupts
Thread-Topic: [PATCH] arm/tegra: add support for tegra30 interrupts
Thread-Index: AcyZdXMGsR6VOsqoTM2c7VVpVQL9hAAB+o6w
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF173F9A46E5@HQMAIL01.nvidia.com>
References: <1320248292-22736-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1320248292-22736-1-git-send-email-pdeschrijver@nvidia.com>
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

Peter De Schrijver wrote by Wednesday, November 02, 2011 9:38 AM:
> Tegra30 has 1 extra legacy interrupt controller. Use the GIC ITLinesNumber
> field to determine how many interrupt controllers we have and initialize
> appropriately. Also make room for the extra tegra30 interrupts by moving
> the GPIO IRQ base. This shouldn't affect existing code as it determines the
> correct IRQ number for GPIOs using TEGRA_GPIO_TO_IRQ()
> 
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>

After fixing one small issue I comment on below,
Acked-by: Stephen Warren <swarren@nvidia.com>

I was previously concerned that renumbering the interrupt IDs would cause
some kind of backwards compatibility problems, but thinking more, I don't
think there's an issue; for a DT-based system, all the IRQ and GPIO numbers
are specified relative to the controller, and the relative numbering isn't
changing here. For a non-DT-based system, any IRQ numbers for any GPIO
should indeed be generated using TEGRA_GPIO_TO_IRQ (or the run-time
equivalent) and hence should also work OK after this patch.

> diff --git a/arch/arm/mach-tegra/include/mach/irqs.h b/arch/arm/mach-tegra/include/mach/irqs.h
...
>  #define NR_BOARD_IRQS			32
> -
> -#define NR_IRQS				(INT_BOARD_BASE + NR_BOARD_IRQS)
> -#endif
> +#define NR_IRQS                         (INT_BOARD_BASE + NR_BOARD_IRQS)

The indentation change to NR_IRQS seems like a mistake; the existing code
looks OK.

-- 
nvpublic

