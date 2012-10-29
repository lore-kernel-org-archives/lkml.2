Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250Ab2J2RYR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 13:24:17 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37743 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab2J2RYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 13:24:14 -0400
Message-ID: <508EBBB6.2090006@samsung.com>
Date: Mon, 29 Oct 2012 18:24:06 +0100
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, jassisinghbrar@gmail.com,
        vinod.koul@intel.com, kgene.kim@samsung.com, rob.herring@calxeda.com,
        dinguyen@altera.com, pawel.moll@arm.com, t.figa@samsung.com,
        kyungmin.park@samsung.com
Subject: Re: [PATCH 2/4] ARM: EXYNOS: PL330 MDMA1 fix for revision 0 of Exynos4210
 SOC
References: <1351504796-24788-1-git-send-email-b.zolnierkie@samsung.com> <1351504796-24788-3-git-send-email-b.zolnierkie@samsung.com>
In-Reply-To: <1351504796-24788-3-git-send-email-b.zolnierkie@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/12 10:59, Bartlomiej Zolnierkiewicz wrote:
> Commit 8214513 ("ARM: EXYNOS: fix address for EXYNOS4 MDMA1")
> changed EXYNOS specific setup of PL330 DMA engine to use 'non-secure'
> mdma1 address instead of 'secure' one (from 0x12840000 to 0x12850000)
> to fix issue with some Exynos4212 SOCs.  Unfortunately it brakes
> PL330 setup for revision 0 of Exynos4210 SOC (mdma1 device cannot
> be found at 'non-secure' address):
>
> [    0.566245] dma-pl330 dma-pl330.2: PERIPH_ID 0x0, PCELL_ID 0x0 !
> [    0.566278] dma-pl330: probe of dma-pl330.2 failed with error -22
>
> Fix it by using 'secure' mdma1 address on Exynos4210 revision 0 SOC.
>
> Cc: Tomasz Figa<t.figa@samsung.com>
> Cc: Kukjin Kim<kgene.kim@samsung.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz<b.zolnierkie@samsung.com>
> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
> ---
>   arch/arm/mach-exynos/dma.c              | 5 ++++-
>   arch/arm/mach-exynos/include/mach/map.h | 3 ++-
>   2 files changed, 6 insertions(+), 2 deletions(-)

[...]

> +		if (samsung_rev() == EXYNOS4210_REV_0)
> +			exynos_mdma1_device.res.start = EXYNOS4_PA_S_MDMA1;

Hi Bart,

Hmm...above change and adding definition of EXYNOS_PA_S_MDMA1 address 
can fix the problem you commented on EXYNOS4210 Rev0 without others?...

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.
