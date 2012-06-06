Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab2FFNS4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 09:18:56 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:45209 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057Ab2FFNSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 09:18:53 -0400
X-AuditID: cbfee61b-b7f8f6d000005ca4-1b-4fcf58bc1c66
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linaro-mm-sig@lists.linaro.org,
        linux-mm@kvack.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Chunsang Jeong <chunsang.jeong@linaro.org>,
        Krishna Reddy <vdumpa@nvidia.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        Subash Patel <subash.ramaswamy@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Abhinav Kochhar <abhinav.k@samsung.com>,
        Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH/RFC 0/2] ARM: DMA-mapping: new extensions for buffer sharing
 (part 2)
Date: Wed, 06 Jun 2012 15:17:35 +0200
Message-id: <1338988657-20770-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.10
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPJMWRmVeSWpSXmKPExsVy+t9jAd09Eef9DXpncFh07PrKYnF51xw2
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDI63jxhLljBV7FlSR9jA+Nj7i5GTg4JAROJf72nmSFs
	MYkL99azdTFycQgJLGKU+Ld0IpTTxSSx5OxeVpAqNgFDia63XWwgtojADEaJXX1pIEXMAvtY
	JDo3n2DsYuTgEBYIl3jXrAtSwyKgKvFo3jx2EJtXwEPi6YftrBDb5CWe3u9jm8DIvYCRYRWj
	aGpBckFxUnqukV5xYm5xaV66XnJ+7iZGsDefSe9gXNVgcYhRgINRiYf3bdh5fyHWxLLiytxD
	jBIczEoivHHOQCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8fcfO+QsJpCeWpGanphakFsFkmTg4
	pRoYy46yscv/OHdgafMco2Nr0n+5pBQ7P51xW357B+9k3lczeIMY/jM/fv6V+bFRpRE3B2/w
	kgn139xaX5+etlHB9a3cCW63R3YPhRfc+1t1c5+AW7Pzsc+M/zJy01YVSz0/7y0eLjZfP2bv
	/8jFaj0P+qcoXeoWVFtw8OMudd78FDFx7zTd+utmSizFGYmGWsxFxYkAijWPquIBAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is a continuation of the dma-mapping extensions posted in the
following thread:
http://thread.gmane.org/gmane.linux.kernel.mm/78644

We noticed that some advanced buffer sharing use cases usually require
creating a dma mapping for the same memory buffer for more than one
device. Usually also such buffer is never touched with CPU, so the data
are processed by the devices.

>From the DMA-mapping perspective this requires to call one of the
dma_map_{page,single,sg} function for the given memory buffer a few
times, for each of the devices. Each dma_map_* call performs CPU cache
synchronization, what might be a time consuming operation, especially
when the buffers are large. We would like to avoid any useless and time
consuming operations, so that was the main reason for introducing
another attribute for DMA-mapping subsystem: DMA_ATTR_SKIP_CPU_SYNC,
which lets dma-mapping core to skip CPU cache synchronization in certain
cases.

The proposed patches have been generated on top of the ARM DMA-mapping
redesign patch series on Linux v3.4-rc7. They are also available on the
following GIT branch:

git://git.linaro.org/people/mszyprowski/linux-dma-mapping.git 3.4-rc7-arm-dma-v10-ext

with all require patches on top of vanilla v3.4-rc7 kernel. I will
resend them rebased onto v3.5-rc1 soon.

Best regards
Marek Szyprowski
Samsung Poland R&D Center


Patch summary:

Marek Szyprowski (2):
  common: DMA-mapping: add DMA_ATTR_SKIP_CPU_SYNC attribute
  ARM: dma-mapping: add support for DMA_ATTR_SKIP_CPU_SYNC attribute

 Documentation/DMA-attributes.txt |   24 ++++++++++++++++++++++++
 arch/arm/mm/dma-mapping.c        |   20 +++++++++++---------
 include/linux/dma-attrs.h        |    1 +
 3 files changed, 36 insertions(+), 9 deletions(-)

-- 
1.7.1.569.g6f426

