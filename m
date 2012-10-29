Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588Ab2J2KGY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 06:06:24 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:54659 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097Ab2J2KGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 06:06:23 -0400
X-AuditID: cbfee61a-b7fa66d0000004cf-01-508e551e50d5
From: Tomasz Figa <t.figa@samsung.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, jassisinghbrar@gmail.com,
        vinod.koul@intel.com, kgene.kim@samsung.com, rob.herring@calxeda.com,
        dinguyen@altera.com, pawel.moll@arm.com, kyungmin.park@samsung.com
Subject: Re: [PATCH 0/4] DMA: PL330 fixes
Date: Mon, 29 Oct 2012 11:05:13 +0100
Message-id: <2027905.ZSjHgXqYha@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.9.2 (Linux/3.6.2-gentoo; KDE/4.9.2; x86_64; ; )
In-reply-to: <1351504796-24788-1-git-send-email-b.zolnierkie@samsung.com>
References: <1351504796-24788-1-git-send-email-b.zolnierkie@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFLMWRmVeSWpSXmKPExsVy+t9jAV250L4Ag+f7uSwu75rDZjHj/D4m
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDIudZ5jK2gXqDh05CZbA+Nz7i5GTg4JAROJk5Oa2CBs
	MYkL99YD2VwcQgKLGCXajk5ghnBamCT6j75nBqliE1CT+NzwCKxDRMBCYu2KtywgRcwCk5kk
	jly8xAKSEBbQlHjyaTFjFyMHB4uAqsTNDn6QMC9QeNr+4+wgNr+AusS7bU+ZQEpEBZwlVp9I
	BAlzCnhKnJ64CmyVkICHxL9P+9khWgUlfky+BzadWUBeYt/+qawQtpbE+p3HmSYwCs5CUjYL
	SdksJGULGJlXMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgSH6DOpHYwrGywOMQpwMCrx8Da+
	6Q0QYk0sK67MPcQowcGsJMK7lBsoxJuSWFmVWpQfX1Sak1p8iFGag0VJnLfZIyVASCA9sSQ1
	OzW1ILUIJsvEwSnVwHjc5Hr416uh8zPO34q783bGbL3z+q18Zd5Oxy3WbdQoX2nDOXvW1kXL
	2tdbpn94N/u12eRKW0ep+heKsSsbOPNS6nZMjHGs3vHrr+Wusq8nJxTvtw/tPD95/SVRk6lh
	k8MmxysHuigE5Mq/P/DqufGdQxLdRqpsky23rJNdf/Uqw814u46X77cosRRnJBpqMRcVJwIA
	v7AjBU0CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bartlomiej,

On Monday 29 of October 2012 10:59:52 Bartlomiej Zolnierkiewicz wrote:
> Hi,
> 
> The first patch fixes lockup caused by pl330 driver.  It doesn't add
> any dependencies to later patches and can be applied independently.
> 
> The second patch fixes PL330 regression on ARM Exynos 4210 revision 0
> SOC (used by Universal C210 board).
> 
> The third patch adds PL330 MDMA1 controller node to device tree on
> ARM Exynos4 SOCs.
> 
> The fourth patch adds device tree property for PL330 driver to be used
> by controllers that have DMA_MEMCPY capability and updates device tree
> files for ARM platforms using PL330.  Since this patch depends on
> patches #2-3 it would be probably best to also push it through Kukjin's
> tree (with the relevant ACKs added of course).
> 
> 
> Bartlomiej Zolnierkiewicz (4):
>   DMA: PL330: fix locking in pl330_free_chan_resources()
>   ARM: EXYNOS: PL330 MDMA1 fix for revision 0 of Exynos4210 SOC
>   ARM: dts: exynos4: add node for PL330 MDMA1 controller
>   DMA: PL330: add device tree property for DMA_MEMCPY capability
> 
>  Documentation/devicetree/bindings/dma/arm-pl330.txt |  1 +
>  arch/arm/boot/dts/exynos4.dtsi                      |  7 +++++++
>  arch/arm/boot/dts/exynos5250.dtsi                   |  2 ++
>  arch/arm/boot/dts/highbank.dts                      |  1 +
>  arch/arm/boot/dts/socfpga.dtsi                      |  1 +
>  arch/arm/boot/dts/vexpress-v2p-ca15-tc1.dts         |  1 +
>  arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts          |  1 +
>  arch/arm/mach-exynos/dma.c                          |  5 ++++-
>  arch/arm/mach-exynos/include/mach/map.h             |  3 ++-
>  arch/arm/mach-exynos/mach-exynos4-dt.c              |  1 +
>  drivers/dma/pl330.c                                 | 15
> ++++++++++----- 11 files changed, 31 insertions(+), 7 deletions(-)

For all four patches:

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
-- 
Tomasz Figa
Samsung Poland R&D Center
SW Solution Development, Linux Platform

