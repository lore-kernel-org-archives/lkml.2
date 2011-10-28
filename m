Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970Ab1J1O1Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 10:27:25 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65189 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315Ab1J1OXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 10:23:37 -0400
From: Pekka Enberg <penberg@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Tejun Heo <tj@kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        David Rientjes <rientjes@google.com>
Subject: [RFC/PATCH 5/7] x86, mm: Use max_low_pfn for ZONE_NORMAL on 64-bit
Date: Fri, 28 Oct 2011 17:23:19 +0300
Message-Id: <1319811801-1725-5-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1319811801-1725-1-git-send-email-penberg@kernel.org>
References: <1319811801-1725-1-git-send-email-penberg@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

64-bit has no highmem so max_low_pfn is always the same as 'max_pfn'.

Cc: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 arch/x86/mm/init_64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index a9214e6..f6b1f08 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -623,7 +623,7 @@ static void __init zone_sizes_init(void)
 #ifdef CONFIG_ZONE_DMA32
 	max_zone_pfns[ZONE_DMA32] = MAX_DMA32_PFN;
 #endif
-	max_zone_pfns[ZONE_NORMAL] = max_pfn;
+	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
 
 	free_area_init_nodes(max_zone_pfns);
 }
-- 
1.7.6.4

