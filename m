Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab1KGTDg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 14:03:36 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2711 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977Ab1KGTDe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 14:03:34 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 07 Nov 2011 11:03:18 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Mon, 7 Nov 2011 11:03:15 -0800
Subject: RE: [PATCH v3 2/8] arm/tegra: prepare early init for multiple tegra
 variants
Thread-Topic: [PATCH v3 2/8] arm/tegra: prepare early init for multiple
 tegra variants
Thread-Index: AcydWGSyMpynYJMdSrGBetOhaeG2TQAJzeTA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF173F9A50E8@HQMAIL01.nvidia.com>
References: <1320675617-20751-1-git-send-email-pdeschrijver@nvidia.com>
 <1320675617-20751-3-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1320675617-20751-3-git-send-email-pdeschrijver@nvidia.com>
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
> This patch splits the early init code in a common and a tegra20 specific part.
> L2 cache initialization is generalized and discovers the cache associativity
> at runtime. Also use arm_pm_restart instead of arm_arch_reset and reset the
> the system using the PMC reset feature rather then the CAR system reset.

> -static void __init tegra_init_cache(void)
...
> +	aux_ctrl = readl(p + L2X0_CACHE_TYPE);
> +	aux_ctrl = (aux_ctrl & 0x700) << (17-8);
> +	aux_ctrl |= 0x6C000001;

It might be slightly clearer here to write:

> +	aux_ctrl = 0x6C000001;
> +	cache_type = readl(p + L2X0_CACHE_TYPE);
> +	aux_ctrl |= (cache_type & 0x700) << (17-8);

So that the contents of the cache type register isn't assigned to something
named after an unrelated register.

-- 
nvpublic

