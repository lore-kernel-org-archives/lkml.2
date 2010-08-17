Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232Ab0HQEwE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 00:52:04 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:44688 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799Ab0HQEwC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 00:52:02 -0400
From: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
To: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Kanigeri, Hari" <h-kanigeri2@ti.com>,
        "Hiroshi.DOYU@nokia.com" <Hiroshi.DOYU@nokia.com>
Date: Mon, 16 Aug 2010 23:48:14 -0500
Subject: RE: [PATCH] iommu: fix end address of vm area comparation in
 alloc_iovm_area
Thread-Topic: [PATCH] iommu: fix end address of vm area comparation in
 alloc_iovm_area
Thread-Index: AQHLPb89dO8xxwhi9kWHPF9veuQYs5LlE0+g
Message-ID: <496565EC904933469F292DDA3F1663E602CA4D894C@dlee06.ent.ti.com>
References: <496565EC904933469F292DDA3F1663E602CA4D8949@dlee06.ent.ti.com>
In-Reply-To: <496565EC904933469F292DDA3F1663E602CA4D8949@dlee06.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There was a mistake with Hiroshi email. Looping in Hiroshi

Sorry for the noise.

Regards,
Fernando.
________________________________________
From: linux-omap-owner@vger.kernel.org [linux-omap-owner@vger.kernel.org] On Behalf Of Guzman Lugo, Fernando [fernando.lugo@ti.com]
Sent: Monday, August 16, 2010 10:51 PM
To: linux-omap@vger.kernel.org; linux-kernel@vger.kernel.org
Cc: Hiroshi.DOYO@nokia.com; Kanigeri, Hari
Subject: [PATCH] iommu: fix end address of vm area comparation in alloc_iovm_area

>From cc48c0adaee97c8385a356aefa5b64a51818b4fd Mon Sep 17 00:00:00 2001
From: Fernando Guzman Lugo <x0095840@ti.com>
Date: Mon, 16 Aug 2010 22:28:24 -0500
Subject: [PATCH] iommu: fix end address of vm area comparation in alloc_iovm_area

End address of the vm area is “start + bytes -1”,
not “start + byte”. This patch fixes that issue by doing
an inclusive comparison with tmp->da_start. This issue
was preventing allocate an area of size exactly the same
than the free area. I did no change the value of da_end
of each vm area because it is used to get area size in
several places.

Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
---
 arch/arm/plat-omap/iovmm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/plat-omap/iovmm.c b/arch/arm/plat-omap/iovmm.c
index b8bcad5..8745d4e 100644
--- a/arch/arm/plat-omap/iovmm.c
+++ b/arch/arm/plat-omap/iovmm.c
@@ -295,7 +295,7 @@ static struct iovm_struct *alloc_iovm_area(struct iommu *obj, u32 da,
        prev_end = 0;
        list_for_each_entry(tmp, &obj->mmap, list) {

-               if ((prev_end <= start) && (start + bytes < tmp->da_start))
+               if ((prev_end <= start) && (start + bytes <= tmp->da_start))
                        goto found;

                if (flags & IOVMF_DA_ANON)
--
1.7.0.4
--
To unsubscribe from this list: send the line "unsubscribe linux-omap" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
