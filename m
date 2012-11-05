Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135Ab2KEKBh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 05:01:37 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:46835 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932112Ab2KEKBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 05:01:34 -0500
X-AuditID: cbfee61b-b7f616d00000319b-06-50978e7da596
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: djbw@fb.com, dwmw2@infradead.org, hskinnemoen@gmail.com,
        iws@ovro.caltech.edu, vinod.koul@intel.com, vipin.kumar@st.com,
        t.figa@samsung.com, kyungmin.park@samsung.com,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 10/20] async_tx: add missing DMA unmap to async_memset()
Date: Mon, 05 Nov 2012 11:00:21 +0100
Message-id: <1352109631-3385-11-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1352109631-3385-1-git-send-email-b.zolnierkie@samsung.com>
References: <1352109631-3385-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEJMWRmVeSWpSXmKPExsVy+t9jAd3avukBBvt7ZC0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGpYenmQsOs1X0PrvM0sC4gbWLkZNDQsBE4t7Z3ewQtpjEhXvr
	2boYuTiEBBYxSlx9OosdwlnNJNF07iwjSBWbgJXExPZVYLaIgILE5t5nrCBFzALPGCVm3O5m
	7mLk4BAW8JA49z0BpIZFQFXi6q81YPW8QOGuuT1MENvkJZ7e72MDsTmB4o0NU8AuEhJwl7jc
	eZx5AiPvAkaGVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjBPn8mvYNxVYPFIUYBDkYlHt5P
	EtMDhFgTy4orcw8xSnAwK4nwcjAAhXhTEiurUovy44tKc1KLDzFKc7AoifM2e6QECAmkJ5ak
	ZqemFqQWwWSZODilGhhV3pmwb2XrS3C7pPounM9vlsaUTc1rZOIeSHxisBJef3XvOY3M+2mW
	7XfD9n9+8qlS7oN8bcHHOcuePHPS97hiVa5x3rBf7vKsuzdczILY5XpUX/5kkd//f/ndiqfN
	IXk7bmc4vNb651378ZLRk6WLzMP8hKweXM2IXzJjWnBf852tdZ6fug4qsRRnJBpqMRcVJwIA
	e+pnAfUBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do DMA unmap on ->device_prep_dma_memset failure.

Cc: Dan Williams <djbw@fb.com>
Cc: Tomasz Figa <t.figa@samsung.com>
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

