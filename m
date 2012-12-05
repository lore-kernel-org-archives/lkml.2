Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab2LELMF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 06:12:05 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:60633 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804Ab2LELLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 06:11:47 -0500
X-AuditID: cbfee61b-b7f616d00000319b-cc-50bf2bf221af
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: vinod.koul@intel.com
Cc: linux-kernel@vger.kernel.org, djbw@fb.com, dwmw2@infradead.org,
        hskinnemoen@gmail.com, iws@ovro.caltech.edu, vipin.kumar@st.com,
        t.figa@samsung.com, kyungmin.park@samsung.com,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH resend 7/7] async_tx: add missing DMA unmap to async_memset()
Date: Wed, 05 Dec 2012 12:10:45 +0100
Message-id: <1354705845-29439-8-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1354705845-29439-1-git-send-email-b.zolnierkie@samsung.com>
References: <1354705845-29439-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIJMWRmVeSWpSXmKPExsVy+t9jAd1P2vsDDLomqVtc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MNf1TmQousVXsbVzE1MC4n7WLkZNDQsBE4siPO0wQtpjEhXvr
	2boYuTiEBBYxSqy//IAVwlnNJHHmxisWkCo2ASuJie2rGEFsEQEJie3P+thBipgF3jFKNK37
	CzZKWMBXYvX7U2BFLAKqEpff3waaxMHBK+AhsWNrGcQ2eYmn9/vYQGxOAU+JB1NnsoCUCAGV
	zDoQMoGRdwEjwypG0dSC5ILipPRcI73ixNzi0rx0veT83E2MYI8/k97BuKrB4hCjAAejEg+v
	hPG+ACHWxLLiytxDjBIczEoivPNk9gcI8aYkVlalFuXHF5XmpBYfYpTmYFES5232SAkQEkhP
	LEnNTk0tSC2CyTJxcEo1MBZv2sS3aMMWIcUJD8W/PRKK2HwxVceJI239BO/eUxPCwp7E+3Zt
	EfOfbNng7nHrNvNe1SfbHG9EJ3AISaz9N/WaY0Unj0Qv+4J1rJ+kJsTkvH1RrXVo7wKW1Jn5
	NSfmC8yfst90d47+zqhnNdM7BZJ5DaT2zPrffE3u4J7uTyt2GbgukPvplKHEUpyRaKjFXFSc
	CADC1Pmw9AEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do DMA unmap on ->device_prep_dma_memset failure.

Acked-by: Dan Williams <djbw@fb.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 crypto/async_tx/async_memset.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/crypto/async_tx/async_memset.c b/crypto/async_tx/async_memset.c
index 05a4d1e..a6a667b 100644
--- a/crypto/async_tx/async_memset.c
+++ b/crypto/async_tx/async_memset.c
@@ -61,6 +61,9 @@ async_memset(struct page *dest, int val, unsigned int offset, size_t len,
 
 		tx = device->device_prep_dma_memset(chan, dma_dest, val, len,
 						    dma_prep_flags);
+		if (!tx)
+			dma_unmap_page(device->dev, dma_dest, len,
+				       DMA_FROM_DEVICE);
 	}
 
 	if (tx) {
-- 
1.8.0

