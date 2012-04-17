Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133Ab2DQPzG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 11:55:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60406 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753946Ab2DQPzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 11:55:04 -0400
Date: Tue, 17 Apr 2012 17:55:02 +0200
From: Michal Hocko <mhocko@suse.cz>
To: yinghai@kernel.org
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Weirdness in __alloc_bootmem_node_high
Message-ID: <20120417155502.GE22687@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I just come across the following condition in __alloc_bootmem_node_high
which I have hard times to understand. I guess it is a bug and we need
something like the following. But, to be honest, I have no idea why we
care about those 128MB above MAX_DMA32_PFN.
---
 mm/bootmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/bootmem.c b/mm/bootmem.c
index 0131170..5adb072 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -737,7 +737,7 @@ void * __init __alloc_bootmem_node_high(pg_data_t *pgdat, unsigned long size,
 	/* update goal according ...MAX_DMA32_PFN */
 	end_pfn = pgdat->node_start_pfn + pgdat->node_spanned_pages;
 
-	if (end_pfn > MAX_DMA32_PFN + (128 >> (20 - PAGE_SHIFT)) &&
+	if (end_pfn > MAX_DMA32_PFN + (128 << (20 - PAGE_SHIFT)) &&
 	    (goal >> PAGE_SHIFT) < MAX_DMA32_PFN) {
 		void *ptr;
 		unsigned long new_goal;
-- 
1.7.9.5

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
