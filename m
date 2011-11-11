Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158Ab1KKWA1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 17:00:27 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13421 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab1KKWAZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 17:00:25 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 11 Nov 2011 14:00:15 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Fri, 11 Nov 2011 14:00:15 -0800
Subject: RE: [PATCH v4 06/10] arm/tegra: prepare pinmux code for multiple
 tegra variants
Thread-Topic: [PATCH v4 06/10] arm/tegra: prepare pinmux code for multiple
 tegra variants
Thread-Index: AcygZDalb7rCZb0fQnSX81gZVBHzBQAWMU2w
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17408058C6@HQMAIL01.nvidia.com>
References: <1321010541-31337-1-git-send-email-pdeschrijver@nvidia.com>
 <1321010541-31337-7-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1321010541-31337-7-git-send-email-pdeschrijver@nvidia.com>
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

Peter De Schrijver wrote at Friday, November 11, 2011 4:22 AM:
> This patch modifies the pinmux code to be useable for multiple tegra variants.
> Some tegra20 specific constants will be replaced by variables which will be
> initialized to the appropriate value at runtime.

> diff --git a/arch/arm/mach-tegra/pinmux.c b/arch/arm/mach-tegra/pinmux.c

> +#ifdef CONFIG_OF
> +#include <linux/of_platform.h>
> +#endif

No need to ifdef the include.

> +#ifdef CONFIG_OF
> +	match = of_match_device(tegra_pinmux_of_match, &pdev->dev);
> +#endif

There's already a dummy of_match_device that returns NULL if !CONFIG_OF,
so you can avoid this ifdef. (at least in next-20111111).

-- 
nvpublic

