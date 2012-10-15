Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630Ab2JOOEN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 10:04:13 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:14590 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073Ab2JOOEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 10:04:12 -0400
X-AuditID: cbfee61a-b7f976d000001eb9-70-507c17daaebf
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linaro-mm-sig@lists.linaro.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Inki Dae <inki.dae@samsung.com>, Rob Clark <rob@ti.com>
Subject: [RFC 0/2] DMA-mapping & IOMMU - physically contiguous allocations
Date: Mon, 15 Oct 2012 16:03:50 +0200
Message-id: <1350309832-18461-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBJMWRmVeSWpSXmKPExsVy+t9jAd3b4jUBBp8es1hc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MD6e2sBVcZa+Y8fUMUwNjB1sXIyeHhICJxLyNvSwQtpjEhXvr
	geJcHEICixglbl/eyArhrGCSOLHzC1gHm4ChRNfbLiCbg0NEoEZi3gxGkBpmgdeMErN2bgar
	ERbwktj7ZxkjSA2LgKrEtdkGIGFeAQ+JpUfnMYGEJQQUJOZMspnAyL2AkWEVo2hqQXJBcVJ6
	rqFecWJucWleul5yfu4mRrD/nkntYFzZYHGIUYCDUYmH96dXdYAQa2JZcWXuIUYJDmYlEd5n
	j4BCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeZs9UgKEBNITS1KzU1MLUotgskwcnFINjBs/lRza
	2fpPnfNidd3viB3Wf74mFx+6rNZ1rPEw+17RKWppQU5THk9m8LKQeD99seTX8gxn439uijmh
	3292PpV6fvAa37p32hsZrk/v3ynNVmnQl332xS+rWq6bejHr+hbpCOgf6tw+Kb5R3jE0papt
	dvfe2OJdt1Tcg7cIh/HEvO5rsZp6UImlOCPRUIu5qDgRALc19hnbAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Some devices, which have IOMMU, for some use cases might require to
allocate a buffers for DMA which is contiguous in physical memory. Such
use cases appears for example in DRM subsystem when one wants to improve
performance or use secure buffer protection.

I would like to ask if adding a new attribute, as proposed in this RFC
is a good idea? I feel that it might be an attribute just for a single
driver, but I would like to know your opinion. Should we look for other
solution?

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


Marek Szyprowski (2):
  common: DMA-mapping: add DMA_ATTR_FORCE_CONTIGUOUS attribute
  ARM: dma-mapping: add support for DMA_ATTR_FORCE_CONTIGUOUS attribute

 Documentation/DMA-attributes.txt |    9 +++++++++
 arch/arm/mm/dma-mapping.c        |   41 ++++++++++++++++++++++++++++++--------
 include/linux/dma-attrs.h        |    1 +
 3 files changed, 43 insertions(+), 8 deletions(-)

-- 
1.7.9.5

