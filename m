Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689Ab2JHGeW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 02:34:22 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:54616 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab2JHGeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 02:34:20 -0400
MIME-Version: 1.0
In-Reply-To: <2552746.GKROWAIKW8@amdc1227>
References: <1349093361-18820-1-git-send-email-thomas.abraham@linaro.org>
	<1349093361-18820-3-git-send-email-thomas.abraham@linaro.org>
	<2552746.GKROWAIKW8@amdc1227>
Date: Mon, 8 Oct 2012 12:04:18 +0530
Message-ID: <CAJuYYwQCPOFMnQrA-n42hQFtK3TXQtJSjkQZmVgh_4pqnMi8iw@mail.gmail.com>
Subject: Re: [PATCH 2/2] ARM: Exynos4: Register clocks via common clock framework
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Tomasz Figa <t.figa@samsung.com>
Cc: chander.kashyap@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        mturquette@linaro.org, mturquette@ti.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On 3 October 2012 19:40, Tomasz Figa <t.figa@samsung.com> wrote:
> Hi Chander, Thomas,
>
> I can see one more problem here.
>
> Based on the fact that sdhci-s3c driver receives only the endpoint gate
> clock (hsmmc), doesn't the following setup make the driver unable to change
> the frequency of this clock?

The driver never changes the clock frequency of the core system clocks
nor of the endpoint. There are internal dividers inside the sdhci
controller which are divide to acheive required clock speed.

Thanks,
Thomas.

>
> On Monday 01 of October 2012 17:39:21 chander.kashyap@linaro.org wrote:
>> +static struct samsung_mux_clock exynos4_mux_clks[] = {
> [snip]
>> +     MUXCLK("exynos4-sdhci.0", "mout_mmc0", group1_parents, 0,
>> +                     EXYNOS4_CLKSRC_FSYS, 0, 4, 0),
>> +     MUXCLK("exynos4-sdhci.1", "mout_mmc1", group1_parents, 0,
>> +                     EXYNOS4_CLKSRC_FSYS, 4, 4, 0),
>> +     MUXCLK("exynos4-sdhci.1", "mout_mmc2", group1_parents, 0,
>> +                     EXYNOS4_CLKSRC_FSYS, 8, 4, 0),
>> +     MUXCLK("exynos4-sdhci.1", "mout_mmc3", group1_parents, 0,
>> +                     EXYNOS4_CLKSRC_FSYS, 12, 4, 0),
> [snip]
>> +};
>> +
>> +static struct samsung_div_clock exynos4_div_clks[] = {
> [snip]
>> +     DIVCLK("exynos4-sdhci.0", "div_mmc0", "mout_mmc0", 0,
>> +                     EXYNOS4_CLKDIV_FSYS1, 0, 4, 0),
>> +     DIVCLK("exynos4-sdhci.0", "div_mmc0_pre", "div_mmc0", 0,
>> +                     EXYNOS4_CLKDIV_FSYS1, 8, 8, 0),
>> +     DIVCLK("exynos4-sdhci.1", "div_mmc1", "mout_mmc1", 0,
>> +                     EXYNOS4_CLKDIV_FSYS1, 16, 4, 0),
>> +     DIVCLK("exynos4-sdhci.1", "div_mmc1_pre", "div_mmc1", 0,
>> +                     EXYNOS4_CLKDIV_FSYS1, 24, 8, 0),
>> +     DIVCLK("exynos4-sdhci.2", "div_mmc2", "mout_mmc2", 0,
>> +                     EXYNOS4_CLKDIV_FSYS2, 0, 4, 0),
>> +     DIVCLK("exynos4-sdhci.2", "div_mmc2_pre", "div_mmc2", 0,
>> +                     EXYNOS4_CLKDIV_FSYS2, 8, 8, 0),
>> +     DIVCLK("exynos4-sdhci.3", "div_mmc3", "mout_mmc3", 0,
>> +                     EXYNOS4_CLKDIV_FSYS2, 16, 4, 0),
>> +     DIVCLK("exynos4-sdhci.3", "div_mmc3_pre", "div_mmc3", 0,
>> +                     EXYNOS4_CLKDIV_FSYS2, 24, 8, 0),
> [snip]
>> +};
>> +
>> +struct samsung_gate_clock exynos4_gate_clks[] = {
> [snip]
>> +     GATECLK("exynos4-sdhci.0", "hsmmc0", "aclk_133", 0,
>> +                     EXYNOS4_CLKGATE_IP_FSYS, 5, "hsmmc"),
>> +     GATECLK("exynos4-sdhci.1", "hsmmc1", "aclk_133", 0,
>> +                     EXYNOS4_CLKGATE_IP_FSYS, 6, "hsmmc"),
>> +     GATECLK("exynos4-sdhci.2", "hsmmc2", "aclk_133", 0,
>> +                     EXYNOS4_CLKGATE_IP_FSYS, 7, "hsmmc"),
>> +     GATECLK("exynos4-sdhci.3", "hsmmc3", "aclk_133", 0,
>> +                     EXYNOS4_CLKGATE_IP_FSYS, 8, "hsmmc"),
> [snip]
>> +};
>
> Best regards,
> --
> Tomasz Figa
> Samsung Poland R&D Center
>
