Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534Ab1IXHgb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Sep 2011 03:36:31 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:14384 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab1IXHga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Sep 2011 03:36:30 -0400
X-AuditID: cbfee60d-b7b74ae000004fd5-8f-4e7d887dee77
Date: Sat, 24 Sep 2011 07:36:29 +0000 (GMT)
From: =?euc-kr?B?wbaw5sij?= <pullip.cho@samsung.com>
Subject: [PATCH 4/4] iommu/exynos: Use bus_set_iommu instead of register_iommu
To: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: =?euc-kr?Q?=C1=B6=B0=E6=C8=A3?= <pullip.cho@samsung.com>,
        "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
        =?euc-kr?Q?=C0=CC=BB=F3=C7=F6?= <sanghyun75.lee@samsung.com>,
        =?euc-kr?Q?=B1=E8=B1=B9=C1=F8?= <kgene.kim@samsung.com>,
        =?euc-kr?Q?=B1=E8=BF=B5=B6=F4?= <younglak1004.kim@samsung.com>,
        "ohad@wizery.com" <ohad@wizery.com>
Reply-to: pullip.cho@samsung.com
MIME-version: 1.0
X-MTR: 20110924073558505@pullip.cho
Msgkey: 20110924073558505@pullip.cho
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
X-ParentMTR: 20110924073045781@pullip.cho
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <9156991.50021316849787764.JavaMail.weblogic@epml24>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p8O7agvk008744

This replaces register_iommu() with bus_set_iommu() according to the
suggestion of Joerg Roedel.

Cc: Joerg Roedel 
Signed-off-by: KyongHo Cho 
---
drivers/iommu/exynos_iommu.c |    2 +-
1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/iommu/exynos_iommu.c b/drivers/iommu/exynos_iommu.c
index fe5b5d8..148e238 100644
--- a/drivers/iommu/exynos_iommu.c
+++ b/drivers/iommu/exynos_iommu.c
@@ -852,7 +852,7 @@ static int __init exynos_iommu_init(void)
if (!l2table_cachep)
return -ENOMEM;

- register_iommu(&exynos_iommu_ops);
+ bus_set_iommu(&platform_bus_type, &omap_iommu_ops);

return 0;
}
-- 
1.7.1
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
