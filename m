Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210Ab1KAN76 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 09:59:58 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44940 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847Ab1KAN6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 09:58:53 -0400
From: Pekka Enberg <penberg@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, David Rientjes <rientjes@google.com>,
        Arun Sharma <asharma@fb.com>, Pekka Enberg <penberg@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH v2 4/7] x86, mm: Wrap ZONE_DMA32 with CONFIG_ZONE_DMA32
Date: Tue,  1 Nov 2011 15:58:19 +0200
Message-Id: <1320155902-10424-4-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1320155902-10424-1-git-send-email-penberg@kernel.org>
References: <1320155902-10424-1-git-send-email-penberg@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for unifying 32-bit and 64-bit zone_sizes_init() make sure
ZONE_DMA32 is wrapped in CONFIG_ZONE_DMA32.

Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Yinghai Lu <yinghai@kernel.org>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Arun Sharma <asharma@fb.com>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 arch/x86/mm/init_64.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 3ddda59..a9214e6 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -620,7 +620,9 @@ static void __init zone_sizes_init(void)
 #ifdef CONFIG_ZONE_DMA
 	max_zone_pfns[ZONE_DMA] = MAX_DMA_PFN;
 #endif
+#ifdef CONFIG_ZONE_DMA32
 	max_zone_pfns[ZONE_DMA32] = MAX_DMA32_PFN;
+#endif
 	max_zone_pfns[ZONE_NORMAL] = max_pfn;
 
 	free_area_init_nodes(max_zone_pfns);
-- 
1.7.6.4

