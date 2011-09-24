Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751664Ab1IXH0n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Sep 2011 03:26:43 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:12515 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab1IXH0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Sep 2011 03:26:42 -0400
X-AuditID: cbfee60b-b7c8cae000005644-17-4e7d86301de4
Date: Sat, 24 Sep 2011 07:26:40 +0000 (GMT)
From: =?euc-kr?B?wbaw5sij?= <pullip.cho@samsung.com>
Subject: [PATCH 0/4] iommu/exynos: Add IOMMU and Enhance System MMU driver for
 Exynos4
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: pullip.cho@samsung.com, joerg.roedel@amd.com, sanghyun75.lee@samsung.com,
        kgene.kim@samsung.com, younglak1004.kim@samsung.com, ohad@wizery.com
Reply-to: pullip.cho@samsung.com
MIME-version: 1.0
X-MTR: 20110924072254035@pullip.cho
Msgkey: 20110924072254035@pullip.cho
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20110924072254035@pullip.cho
X-ParentMTR: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <19883641.49771316849198516.JavaMail.weblogic@epml24>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p8O7R3OI008704

Hi.

First 2 patches enhance System MMU platform device definition:                        
 - Removed System MMU for MDMA0 in LCD block because it is not used.                  
   Use MDMA2 in TOP block.                                                            
 - Removed System MMU ID. Instead a System MMU is bound to a device that              
   the System MMU is dedicated during machin initialization. If a device              
   driver wants to handle System MMU, it must bind its device with System             
   MMU with sysmmu_set_owner().
 - clkdev
 - System MMU device driver is removed from arch/arm/plat-s5p to move it
   to driver/iommu directory.
Last 2 patches implements IOMMU API:
 - Implements IOMMU API and System MMU driver that is moved from
   arch/arm/plat-s5p.
 - Implements fault handling that is suggested by Ohad.
 - Used bus_set_iommu instead of register_iommu that is suggested by Joerg.

Regards,
Cho KyongHo.

Diffstats:
arch/arm/mach-exynos4/Kconfig               |    2 -
arch/arm/mach-exynos4/clock.c               |   43 +-
arch/arm/mach-exynos4/dev-sysmmu.c          |  281 +++-------
arch/arm/mach-exynos4/include/mach/irqs.h   |    1 -
arch/arm/mach-exynos4/include/mach/map.h    |    1 -
arch/arm/mach-exynos4/include/mach/sysmmu.h |   96 ++--
arch/arm/mach-exynos4/mach-armlex4210.c     |   24 +-
arch/arm/mach-exynos4/mach-smdkv310.c       |   28 +-
arch/arm/plat-s5p/Kconfig                   |    8 -
arch/arm/plat-s5p/Makefile                  |    1 -
arch/arm/plat-s5p/include/plat/sysmmu.h     |   95 ---
arch/arm/plat-s5p/sysmmu.c                  |  312 ----------
drivers/iommu/Kconfig                       |   14 +
drivers/iommu/Makefile                      |    1 +
drivers/iommu/exynos_iommu.c                |  859 +++++++++++++++++++++++++++
15 files changed, 1084 insertions(+), 682 deletions(-)ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
