Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202Ab2LCQor (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 11:44:47 -0500
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:54723 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754568Ab2LCQoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 11:44:46 -0500
Message-ID: <50BCD6DB.2030200@st.com>
Date: Mon, 3 Dec 2012 17:44:11 +0100
From: Armando Visconti <armando.visconti@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
Cc: "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        "nico@linaro.org" <nico@linaro.org>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        spear-devel <spear-devel@list.st.com>
Subject: Re: [PATCH] nommu: Enable the strict alignment (CR_A) bit only if
 ARCH < v6
References: <1354187042-28568-1-git-send-email-armando.visconti@st.com>
In-Reply-To: <1354187042-28568-1-git-send-email-armando.visconti@st.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2012 12:04 PM, Armando VISCONTI wrote:
> This patch keeps disabled the strict alignment CP15 bit for
> all armv6 and armv7 processor without the mmu. This behaviour
> is now same as in the mmu case.
>
> Signed-off-by: Armando Visconti<armando.visconti@st.com>
> ---
>   arch/arm/kernel/head-nommu.S |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/arm/kernel/head-nommu.S b/arch/arm/kernel/head-nommu.S
> index 278cfc1..2c228a0 100644
> --- a/arch/arm/kernel/head-nommu.S
> +++ b/arch/arm/kernel/head-nommu.S
> @@ -68,7 +68,7 @@ __after_proc_init:
>   	 * CP15 system control register value returned in r0 from
>   	 * the CPU init function.
>   	 */
> -#ifdef CONFIG_ALIGNMENT_TRAP
> +#if defined(CONFIG_ALIGNMENT_TRAP)&&  __LINUX_ARM_ARCH__<  6
>   	orr	r0, r0, #CR_A
>   #else
>   	bic	r0, r0, #CR_A

Any feedback on this simple patch?

Thx,
Armando


