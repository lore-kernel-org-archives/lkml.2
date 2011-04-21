Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab1DUWA2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 18:00:28 -0400
Received: from smtp-out.google.com ([74.125.121.67]:32589 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275Ab1DUWA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 18:00:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=mpnxjTRtGafdEI1BLnSsSD834mL9dYyOOKHG0dJcuAoepavsHpWN9eVfsl0TQCURU0
         3Z3RaY14OeggRfKR5aNA==
Date: Thu, 21 Apr 2011 15:00:19 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matt Turner <mattst88@gmail.com>
cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch] alpha, mm: set all online nodes in N_NORMAL_MEMORY
In-Reply-To: <alpine.DEB.2.00.1104211411540.20201@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1104211458580.20201@chino.kir.corp.google.com>
References: <1303317178.2587.30.camel@mulgrave.site> <alpine.DEB.2.00.1104201410350.31768@chino.kir.corp.google.com> <20110421220351.9180.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1104211237250.5829@chino.kir.corp.google.com> <alpine.DEB.2.00.1104211500170.5741@router.home>
 <alpine.DEB.2.00.1104211411540.20201@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For alpha, N_NORMAL_MEMORY represents all nodes that have present memory 
since it does not support HIGHMEM.  This patch sets the bit at the time 
the node is initialized.

If N_NORMAL_MEMORY is not accurate, slub may encounter errors since it 
uses this nodemask to setup per-cache kmem_cache_node data structures.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/alpha/mm/numa.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/alpha/mm/numa.c b/arch/alpha/mm/numa.c
--- a/arch/alpha/mm/numa.c
+++ b/arch/alpha/mm/numa.c
@@ -313,6 +313,7 @@ void __init paging_init(void)
 			zones_size[ZONE_DMA] = dma_local_pfn;
 			zones_size[ZONE_NORMAL] = (end_pfn - start_pfn) - dma_local_pfn;
 		}
+		node_set_state(nid, N_NORMAL_MEMORY);
 		free_area_init_node(nid, zones_size, start_pfn, NULL);
 	}
 
