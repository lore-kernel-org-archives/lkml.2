Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933590Ab1I1Wuz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:50:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55086 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933576Ab1I1Wuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:50:52 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:48 2011
Message-Id: <20110928220148.661214564@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:03:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [221/244] ARM: dma-mapping: free allocated page if unable to map
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit d8e89b47e00ee80e920761145144640aac4cf71a upstream.

If the attempt to map a page for DMA fails (eg, because we're out of
mapping space) then we must not hold on to the page we allocated for
DMA - doing so will result in a memory leak.

Reported-by: Bryan Phillippe <bp@darkforest.org>
Tested-by: Bryan Phillippe <bp@darkforest.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/mm/dma-mapping.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -322,6 +322,8 @@ __dma_alloc(struct device *dev, size_t s
 
 	if (addr)
 		*handle = pfn_to_dma(dev, page_to_pfn(page));
+	else
+		__dma_free_buffer(page, size);
 
 	return addr;
 }


