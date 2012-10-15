Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab2JOOGb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 10:06:31 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:24827 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561Ab2JOOGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 10:06:30 -0400
X-AuditID: cbfee61b-b7fd46d0000046e0-ee-507c17ec82d7
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linaro-mm-sig@lists.linaro.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Inki Dae <inki.dae@samsung.com>, Rob Clark <rob@ti.com>
Subject: [RFC 1/2] common: DMA-mapping: add DMA_ATTR_FORCE_CONTIGUOUS attribute
Date: Mon, 15 Oct 2012 16:03:51 +0200
Message-id: <1350309832-18461-2-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1350309832-18461-1-git-send-email-m.szyprowski@samsung.com>
References: <1350309832-18461-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAJMWRmVeSWpSXmKPExsVy+t9jAd034jUBBptnc1pc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M7tfTmQvu81ZMuvqavYHxOHcXIyeHhICJRPO1FUwQtpjEhXvr
	2boYuTiEBBYxSkyeN4kFwlnBJHHm6GNGkCo2AUOJrrddQFUcHCICNRLzZjCC1DALvGaUmLVz
	MxtIjbCAv8SP1lcsIDaLgKrE6jP/WEHqeQU8JPrnK4CYEgIKEnMm2YBUcAp4Sjx9OBdsuhBQ
	xbzG3cwTGHkXMDKsYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAj29zPpHYyrGiwOMQpwMCrx
	8P70qg4QYk0sK67MPcQowcGsJML77BFQiDclsbIqtSg/vqg0J7X4EKM0B4uSOG+zR0qAkEB6
	YklqdmpqQWoRTJaJg1OqgbFvcnpQ6Lo43zge52lzLQJNT9et+lFwv+7rhQ08ZQzepzm5P//e
	tPOMzbO8DweX5TxPz95Xe6RXoPbg4+izauncq36/XtMTwCbWnpZp1vU9coumr0/BKmGFGWzR
	n5pzqs4sPrPS/VWeuiQ7y7VjIS2z68LZM2+VpzJ4VW0tEXhnbHbd5KyNiRJLcUaioRZzUXEi
	ACPRF8XzAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds DMA_ATTR_FORCE_CONTIGUOUS attribute to the DMA-mapping
subsystem.

By default DMA-mapping subsystem is allowed to assemble the buffer
allocated by dma_alloc_attrs() function from individual pages if it can
be mapped as contiguous chunk into device dma address space. By
specifing this attribute the allocated buffer is forced to be contiguous
also in physical memory.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 Documentation/DMA-attributes.txt |    9 +++++++++
 include/linux/dma-attrs.h        |    1 +
 2 files changed, 10 insertions(+)

diff --git a/Documentation/DMA-attributes.txt b/Documentation/DMA-attributes.txt
index f503090..e59480d 100644
--- a/Documentation/DMA-attributes.txt
+++ b/Documentation/DMA-attributes.txt
@@ -91,3 +91,12 @@ transferred to 'device' domain. This attribute can be also used for
 dma_unmap_{single,page,sg} functions family to force buffer to stay in
 device domain after releasing a mapping for it. Use this attribute with
 care!
+
+DMA_ATTR_FORCE_CONTIGUOUS
+-------------------------
+
+By default DMA-mapping subsystem is allowed to assemble the buffer
+allocated by dma_alloc_attrs() function from individual pages if it can
+be mapped as contiguous chunk into device dma address space. By
+specifing this attribute the allocated buffer is forced to be contiguous
+also in physical memory.
diff --git a/include/linux/dma-attrs.h b/include/linux/dma-attrs.h
index f83f793..c8e1831 100644
--- a/include/linux/dma-attrs.h
+++ b/include/linux/dma-attrs.h
@@ -17,6 +17,7 @@ enum dma_attr {
 	DMA_ATTR_NON_CONSISTENT,
 	DMA_ATTR_NO_KERNEL_MAPPING,
 	DMA_ATTR_SKIP_CPU_SYNC,
+	DMA_ATTR_FORCE_CONTIGUOUS,
 	DMA_ATTR_MAX,
 };
 
-- 
1.7.9.5

