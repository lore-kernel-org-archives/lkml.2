Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758567Ab1CCREL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 12:04:11 -0500
Received: from kroah.org ([198.145.64.141]:56197 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758503Ab1CCREK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 12:04:10 -0500
Date: Thu, 3 Mar 2011 09:04:01 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.32.31
Message-ID: <20110303170401.GB3995@kroah.com>
References: <20110303170339.GA3995@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110303170339.GA3995@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 1e5c60f..e734450 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 32
-EXTRAVERSION = .30
+EXTRAVERSION = .31
 NAME = Man-Eating Seals of Antiquity
 
 # *DOCUMENTATION*
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 7740ee8..ac25cd2 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -631,10 +631,8 @@ dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
 	/*
 	 * Ensure that the address returned is DMA'ble
 	 */
-	if (!dma_capable(dev, dev_addr, size)) {
-		swiotlb_tbl_unmap_single(dev, map, size, dir);
-		dev_addr = swiotlb_virt_to_bus(dev, io_tlb_overflow_buffer);
-	}
+	if (!dma_capable(dev, dev_addr, size))
+		panic("map_single: bounce buffer is not DMA'ble");
 
 	return dev_addr;
 }
