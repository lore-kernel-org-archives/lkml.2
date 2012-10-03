Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205Ab2JCKkb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 06:40:31 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:44248 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713Ab2JCKka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 06:40:30 -0400
X-AuditID: cbfee61a-b7f726d000000ec7-1c-506c161c2087
From: Tomasz Figa <t.figa@samsung.com>
To: chander.kashyap@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        kgene.kim@samsung.com, mturquette@linaro.org, mturquette@ti.com,
        linux-kernel@vger.kernel.org,
        Thomas Abraham <thomas.abraham@linaro.org>
Subject: Re: [PATCH 2/2] ARM: Exynos4: Register clocks via common clock
 framework
Date: Wed, 03 Oct 2012 12:40:10 +0200
Message-id: <2552746.GKROWAIKW8@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.9.1 (Linux/3.5.3-gentoo; KDE/4.9.1; x86_64; ; )
In-reply-to: <1349093361-18820-3-git-send-email-thomas.abraham@linaro.org>
References: <1349093361-18820-1-git-send-email-thomas.abraham@linaro.org>
 <1349093361-18820-3-git-send-email-thomas.abraham@linaro.org>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFLMWRmVeSWpSXmKPExsVy+t9jQV0ZsZwAg0PXjS0u75rDZjHj/D4m
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDKWvJrMVHBEsOLmqT1sDYzH+LoYOTgkBEwkPsys6WLk
	BDLFJC7cW88GYgsJTGeU+NIh0cXIBWS3MEmcnzSfCSTBJqAm8bnhEViRiICcxPK9u5hBipgF
	bjFKrD13nxUkISwQLDH1xXFGEJtFQFWioWceI8gyXgFNiYe3wML8AuoS77Y9BZspKuAscaVx
	EVicU8BL4u6hz4wQizsZJRaceg+2jFdAUOLH5HssIDazgLzEvv1TWSFsLYn1O48zTWAUnIWk
	bBaSsllIyhYwMq9iFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECA7RZ1I7GFc2WBxiFOBgVOLh
	vcCVHSDEmlhWXJl7iFGCg1lJhFdVOCdAiDclsbIqtSg/vqg0J7X4EKM0B4uSOG+zR0qAkEB6
	YklqdmpqQWoRTJaJg1OqgXFDVEvjWwHN7DcvVVi7Svbq+CXYn5ord9SYx2nn4j1Wz5vq7vkL
	On54/Vv+yiKH/6LPjRYfzL9znuNc4CTdkxLexXEn+TzmVVZxbd8Zs//6/RvPLM+zJ+wMnmH6
	gvEY8/zogN+2nbEWt9k5facp332xyzr8/vvb7hKNzpvtROvM73+OP338Ro0SS3FGoqEWc1Fx
	IgANuYuNTQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chander, Thomas,

I can see one more problem here.

Based on the fact that sdhci-s3c driver receives only the endpoint gate 
clock (hsmmc), doesn't the following setup make the driver unable to change 
the frequency of this clock?

On Monday 01 of October 2012 17:39:21 chander.kashyap@linaro.org wrote:
> +static struct samsung_mux_clock exynos4_mux_clks[] = {
[snip]
> +	MUXCLK("exynos4-sdhci.0", "mout_mmc0", group1_parents, 0,
> +			EXYNOS4_CLKSRC_FSYS, 0, 4, 0),
> +	MUXCLK("exynos4-sdhci.1", "mout_mmc1", group1_parents, 0,
> +			EXYNOS4_CLKSRC_FSYS, 4, 4, 0),
> +	MUXCLK("exynos4-sdhci.1", "mout_mmc2", group1_parents, 0,
> +			EXYNOS4_CLKSRC_FSYS, 8, 4, 0),
> +	MUXCLK("exynos4-sdhci.1", "mout_mmc3", group1_parents, 0,
> +			EXYNOS4_CLKSRC_FSYS, 12, 4, 0),
[snip]
> +};
> +
> +static struct samsung_div_clock exynos4_div_clks[] = {
[snip]
> +	DIVCLK("exynos4-sdhci.0", "div_mmc0", "mout_mmc0", 0,
> +			EXYNOS4_CLKDIV_FSYS1, 0, 4, 0),
> +	DIVCLK("exynos4-sdhci.0", "div_mmc0_pre", "div_mmc0", 0,
> +			EXYNOS4_CLKDIV_FSYS1, 8, 8, 0),
> +	DIVCLK("exynos4-sdhci.1", "div_mmc1", "mout_mmc1", 0,
> +			EXYNOS4_CLKDIV_FSYS1, 16, 4, 0),
> +	DIVCLK("exynos4-sdhci.1", "div_mmc1_pre", "div_mmc1", 0,
> +			EXYNOS4_CLKDIV_FSYS1, 24, 8, 0),
> +	DIVCLK("exynos4-sdhci.2", "div_mmc2", "mout_mmc2", 0,
> +			EXYNOS4_CLKDIV_FSYS2, 0, 4, 0),
> +	DIVCLK("exynos4-sdhci.2", "div_mmc2_pre", "div_mmc2", 0,
> +			EXYNOS4_CLKDIV_FSYS2, 8, 8, 0),
> +	DIVCLK("exynos4-sdhci.3", "div_mmc3", "mout_mmc3", 0,
> +			EXYNOS4_CLKDIV_FSYS2, 16, 4, 0),
> +	DIVCLK("exynos4-sdhci.3", "div_mmc3_pre", "div_mmc3", 0,
> +			EXYNOS4_CLKDIV_FSYS2, 24, 8, 0),
[snip]
> +};
> +
> +struct samsung_gate_clock exynos4_gate_clks[] = {
[snip]
> +	GATECLK("exynos4-sdhci.0", "hsmmc0", "aclk_133", 0,
> +			EXYNOS4_CLKGATE_IP_FSYS, 5, "hsmmc"),
> +	GATECLK("exynos4-sdhci.1", "hsmmc1", "aclk_133", 0,
> +			EXYNOS4_CLKGATE_IP_FSYS, 6, "hsmmc"),
> +	GATECLK("exynos4-sdhci.2", "hsmmc2", "aclk_133", 0,
> +			EXYNOS4_CLKGATE_IP_FSYS, 7, "hsmmc"),
> +	GATECLK("exynos4-sdhci.3", "hsmmc3", "aclk_133", 0,
> +			EXYNOS4_CLKGATE_IP_FSYS, 8, "hsmmc"),
[snip]
> +};

Best regards,
-- 
Tomasz Figa
Samsung Poland R&D Center

