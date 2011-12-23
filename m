Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889Ab1LWMam (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 07:30:42 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:32027 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756842Ab1LWM2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 07:28:08 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 23 Dec 2011 13:27:33 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 14/14] common: DMA-mapping: add NON-CONSISTENT attribute
In-reply-to: <1324643253-3024-1-git-send-email-m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Stephen Rothwell <sfr@canb.auug.org.au>,
        microblaze-uclinux@itee.uq.edu.au, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-sh@vger.kernel.org, linux-alpha@vger.kernel.org,
        sparclinux@vger.kernel.org, linux-ia64@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-mips@linux-mips.org,
        discuss@x86-64.org, linux-arm-kernel@lists.infradead.org,
        linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
        Jonathan Corbet <corbet@lwn.net>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Message-id: <1324643253-3024-15-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.7.3
References: <1324643253-3024-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DMA_ATTR_NON_CONSISTENT lets the platform to choose to return either
consistent or non-consistent memory as it sees fit.  By using this API,
you are guaranteeing to the platform that you have all the correct and
necessary sync points for this memory in the driver should it choose to
return non-consistent memory.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/DMA-attributes.txt |    9 +++++++++
 include/linux/dma-attrs.h        |    1 +
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/Documentation/DMA-attributes.txt b/Documentation/DMA-attributes.txt
index 811a5d4..9120de2 100644
--- a/Documentation/DMA-attributes.txt
+++ b/Documentation/DMA-attributes.txt
@@ -41,3 +41,12 @@ buffered to improve performance.
 Since it is optional for platforms to implement DMA_ATTR_WRITE_COMBINE,
 those that do not will simply ignore the attribute and exhibit default
 behavior.
+
+DMA_ATTR_NON_CONSISTENT
+-----------------------
+
+DMA_ATTR_NON_CONSISTENT lets the platform to choose to return either
+consistent or non-consistent memory as it sees fit.  By using this API,
+you are guaranteeing to the platform that you have all the correct and
+necessary sync points for this memory in the driver should it choose to
+return non-consistent memory.
diff --git a/include/linux/dma-attrs.h b/include/linux/dma-attrs.h
index ada61e1..547ab56 100644
--- a/include/linux/dma-attrs.h
+++ b/include/linux/dma-attrs.h
@@ -14,6 +14,7 @@ enum dma_attr {
 	DMA_ATTR_WRITE_BARRIER,
 	DMA_ATTR_WEAK_ORDERING,
 	DMA_ATTR_WRITE_COMBINE,
+	DMA_ATTR_NON_CONSISTENT,
 	DMA_ATTR_MAX,
 };
 
-- 
1.7.1.569.g6f426

