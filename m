Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414Ab2IAA4G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 20:56:06 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:20105 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353Ab2IAA4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 20:56:05 -0400
Message-ID: <1346460959.3393.3.camel@lorien2>
Subject: [PATCH] swiotlb: add kernel error message to track iobtlb overflow
 buffer usage
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org,
        paul.gortmaker@windriver.com, bhelgaas@google.com, amwang@redhat.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Date: Fri, 31 Aug 2012 18:55:59 -0600
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add kernel error message to track iotlb overflow buffer triggers to understand
how often the overflow buffer gets used.

Signed-off-by: Shuah Khan <shuah.khan@hp.com>
---
 lib/swiotlb.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 45bc1f8..597d7b9 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -682,6 +682,7 @@ dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
 	if (!map) {
 		swiotlb_full(dev, size, dir, 1);
 		map = io_tlb_overflow_buffer;
+		dev_err(dev, "SWIOTLB is full. Mapping overflow buffer.\n");
 	}
 
 	dev_addr = swiotlb_virt_to_bus(dev, map);
-- 
1.7.9.5



