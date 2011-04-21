Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab1DUWBd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 18:01:33 -0400
Received: from smtp-out.google.com ([74.125.121.67]:33334 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab1DUWBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 18:01:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=VBHsB/VP3FbMECqJwoY7UwmZQmzvdSICY7amdifFifwfrPTydR/Lm9+rMZnD8VzU7k
         m5x7uYX05uGo/VMECD+A==
Date: Thu, 21 Apr 2011 15:01:23 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>,
        Hirokazu Takata <takata@linux-m32r.org>
cc: linux-m32r@ml.linux-m32r.org, linux-kernel@vger.kernel.org
Subject: [patch] m32r, mm: set all online nodes in N_NORMAL_MEMORY
In-Reply-To: <alpine.DEB.2.00.1104211411540.20201@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1104211500250.20201@chino.kir.corp.google.com>
References: <1303317178.2587.30.camel@mulgrave.site> <alpine.DEB.2.00.1104201410350.31768@chino.kir.corp.google.com> <20110421220351.9180.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1104211237250.5829@chino.kir.corp.google.com> <alpine.DEB.2.00.1104211500170.5741@router.home>
 <alpine.DEB.2.00.1104211411540.20201@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For m32r, N_NORMAL_MEMORY represents all nodes that have present memory 
since it does not support HIGHMEM.  This patch sets the bit at the time 
the node is initialized.

If N_NORMAL_MEMORY is not accurate, slub may encounter errors since it 
uses this nodemask to setup per-cache kmem_cache_node data structures.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/m32r/mm/discontig.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/m32r/mm/discontig.c b/arch/m32r/mm/discontig.c
--- a/arch/m32r/mm/discontig.c
+++ b/arch/m32r/mm/discontig.c
@@ -149,6 +149,7 @@ unsigned long __init zone_sizes_init(void)
 		zholes_size[ZONE_DMA] = mp->holes;
 		holes += zholes_size[ZONE_DMA];
 
+		node_set_state(nid, N_NORMAL_MEMORY);
 		free_area_init_node(nid, zones_size, start_pfn, zholes_size);
 	}
 
