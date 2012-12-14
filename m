Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327Ab2LNFvU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 00:51:20 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:15850 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822Ab2LNFvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 00:51:16 -0500
X-AuditID: cbfee61b-b7f616d00000319b-a9-50cabe5250f3
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: w.sang@pengutronix.de, khali@linux-fr.org, ben-linux@fluff.org,
        grant.likely@secretlab.ca, devicetree-discuss@lists.ozlabs.org,
        sjg@chromium.org, grundler@chromium.org, naveen@chromium.org,
        broonie@opensource.wolfsonmicro.com
Subject: [PATCH 0/2] i2c: Implement generic gpio based bus arbitration
Date: Fri, 14 Dec 2012 11:20:52 +0530
Message-id: <1355464254-12768-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsWyRsSkTjdo36kAg5//jS06/n5htLi8aw6b
	xYzz+5gcmD0+b5ILYIzisklJzcksSy3St0vgyjhy8CxLwQr2ipfXVzM2ME5l7WLk5JAQMJHY
	da6dHcIWk7hwbz1bFyMXh5DAUkaJ3vYmRpiiY3MWM0EkFjFKXLlwjh3C6WGSeHbtPFgVm4CZ
	xMFFq8FGiQgkSHROOsUEYjMLvGaUWLgXbJ2wgJvEzNkXwepZBFQl9r94DlbDK+AqMffVDaBe
	DqBtChJzJtlAlAhIfJt8iAUiLCux6QAzyFoJgSNsEsf/TYP6QFLi4IobLBMYBRcwMqxiFE0t
	SC4oTkrPNdIrTswtLs1L10vOz93ECAyz0/+eSe9gXNVgcYhRgINRiYf3g9CpACHWxLLiytxD
	jBIczEoivNt2AYV4UxIrq1KL8uOLSnNSiw8x+gBdMpFZSjQ5HxgDeSXxhsYm5qbGppZGRmam
	pjiElcR5mz1SAoQE0hNLUrNTUwtSi2DGMXFwSjUwmi2znuftH/xrZXO665bHBconS79NKNt/
	xJTv8KrJp57Vel3UO7rr2JPAJUn/tZZeyi294rVSPj+7+4L2s+t5iz7tuvXe1HNLfrFTYfjN
	g9MmK0V7fOhYlyzjdzyW6dfl5r9Lt2wK1NV+aN0+77bOrbifb/2nqPwyXn2HLVn+xG/lGZkX
	f/xkO6bEUpyRaKjFXFScCAArp1QTYAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRmVeSWpSXmKPExsVy+t9jAd2gfacCDB53a1l0/P3CaHF51xw2
	ixnn9zE5MHt83iQXwBjVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
	aqvk4hOg65aZAzRfSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5hx5OBZ
	loIV7BUvr69mbGCcytrFyMkhIWAicWzOYiYIW0ziwr31bF2MXBxCAosYJa5cOMcO4fQwSTy7
	dp4RpIpNwEzi4KLV7CC2iECCROekU2DdzAKvGSUW7gWbKizgJjFz9kWwehYBVYn9L56D1fAK
	uErMfXUDqJcDaJuCxJxJNhMYuRcwMqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECA7iZ9I7
	GFc1WBxiFOBgVOLh/SB0KkCINbGsuDL3EKMEB7OSCO+2XUAh3pTEyqrUovz4otKc1OJDjD5A
	yycyS4km5wMjLK8k3tDYxNzU2NTSxMLEzBKHsJI4b7NHSoCQQHpiSWp2ampBahHMOCYOTqkG
	RnfLpuRrlzJK+Jg1bHZdmbtc6XCcjY9MypOAkuJFDg1r6sX2GbFI+B25+CfLnnPddeZ1Hvar
	/5ZMK81XuCZectvSuEB9Gtvyy4z8Ox413zXZuEv0KIP/s8U33664z757QfARdeb5/rdNklL5
	178XcjwpatAyZ6b/yZjTmxMiY37ymvgn6J//qsRSnJFoqMVcVJwIAEKYsd2PAgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds
1. Support for generic gpio based i2c bus arbitration between 2 i2c Masters
	Ex: between AP(exynos), device(EC).
2. Documentation and sample implmentation in i2c-s3c2410 driver.

Naveen Krishna Chatradhi (2):
  i2c-core: Add gpio based bus arbitration implementation
  i2c-s3c2410: Add GPIO based bus arbitration functionality

 .../devicetree/bindings/i2c/arbitrator-i2c.txt     |   56 ++++++++++++++
 drivers/i2c/busses/i2c-s3c2410.c                   |   79 ++++++++++++--------
 drivers/i2c/i2c-core.c                             |   67 +++++++++++++++++
 drivers/of/of_i2c.c                                |   27 +++++++
 include/linux/i2c.h                                |   17 +++++
 include/linux/of_i2c.h                             |    2 +
 6 files changed, 216 insertions(+), 32 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/i2c/arbitrator-i2c.txt

-- 
1.7.9.5

