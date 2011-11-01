Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab1KAN6y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 09:58:54 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44940 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582Ab1KAN6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 09:58:51 -0400
From: Pekka Enberg <penberg@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, David Rientjes <rientjes@google.com>,
        Arun Sharma <asharma@fb.com>, Pekka Enberg <penberg@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH v2 3/7] x86, mm: Use max_pfn instead of highend_pfn
Date: Tue,  1 Nov 2011 15:58:18 +0200
Message-Id: <1320155902-10424-3-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1320155902-10424-1-git-send-email-penberg@kernel.org>
References: <1320155902-10424-1-git-send-email-penberg@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'highend_pfn' variable is always set to 'max_pfn' so just use the latter
directly.

Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Yinghai Lu <yinghai@kernel.org>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 arch/x86/mm/init_32.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 434c97d..5ac0118 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -683,7 +683,7 @@ static void __init zone_sizes_init(void)
 #endif
 	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
 #ifdef CONFIG_HIGHMEM
-	max_zone_pfns[ZONE_HIGHMEM] = highend_pfn;
+	max_zone_pfns[ZONE_HIGHMEM] = max_pfn;
 #endif
 
 	free_area_init_nodes(max_zone_pfns);
-- 
1.7.6.4

