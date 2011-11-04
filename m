Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680Ab1KDUfZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 16:35:25 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7199 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab1KDUfY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 16:35:24 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 04 Nov 2011 13:35:08 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Fri, 4 Nov 2011 13:35:07 -0700
Subject: RE: [PATCH v2 4/8] arm/tegra: prepare pinmux code for multiple
 tegra variants
Thread-Topic: [PATCH v2 4/8] arm/tegra: prepare pinmux code for multiple
 tegra variants
Thread-Index: AcyZaQOjQwu/0unPQI6QHoWw5NFvgwBx7aeQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF173F9A4E46@HQMAIL01.nvidia.com>
References: <1320242948-21061-1-git-send-email-pdeschrijver@nvidia.com>
 <1320242948-21061-5-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1320242948-21061-5-git-send-email-pdeschrijver@nvidia.com>
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

Peter De Schrijver wrote at Wednesday, November 02, 2011 8:09 AM:
> This patch modifies the pinmux code to be useable for multiple tegra variants.
> Some tegra20 specific constants will be replaced by variables which will be
> initialized to the appropriate value at runtime.
...
> diff --git a/arch/arm/mach-tegra/include/mach/pinmux.h b/arch/arm/mach-tegra/include/mach/pinmux.h
...
> @@ -219,13 +213,20 @@ struct tegra_pingroup_desc {
>  	s8 pupd_bit;	/* offset into the PULL_UPDOWN_REG_* register bit */
>  };
> 
> -extern const struct tegra_pingroup_desc tegra_soc_pingroups[];
> -extern const struct tegra_drive_pingroup_desc tegra_soc_drive_pingroups[];
> +struct tegra_pinmux_pm {
> +	void (*suspend)(void);
> +	void (*resume)(void);
> +};

You still don't need that struct type.

-- 
nvpublic

