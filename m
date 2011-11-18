Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906Ab1KRX1D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 18:27:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53226 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961Ab1KRX1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 18:27:01 -0500
Date: Fri, 18 Nov 2011 15:26:39 -0800
From: tip-bot for Pekka Enberg <penberg@kernel.org>
Message-ID: <tip-248b52b97da7a712d2263a51d8d84c959f38ef75@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, penberg@kernel.org, tj@kernel.org,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, penberg@kernel.org, tj@kernel.org,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1320155902-10424-6-git-send-email-penberg@kernel.org>
References: <1320155902-10424-6-git-send-email-penberg@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, mm: Prepare zone_sizes_init() for unification
Git-Commit-ID: 248b52b97da7a712d2263a51d8d84c959f38ef75
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 Nov 2011 15:26:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  248b52b97da7a712d2263a51d8d84c959f38ef75
Gitweb:     http://git.kernel.org/tip/248b52b97da7a712d2263a51d8d84c959f38ef75
Author:     Pekka Enberg <penberg@kernel.org>
AuthorDate: Tue, 1 Nov 2011 15:58:21 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 11 Nov 2011 10:22:53 +0100

x86, mm: Prepare zone_sizes_init() for unification

Make 32-bit and 64-bit zone_sizes_init() identical in
preparation for unification.

Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
Link: http://lkml.kernel.org/r/1320155902-10424-6-git-send-email-penberg@kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/init_32.c |    4 ++++
 arch/x86/mm/init_64.c |    3 +++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 5ac0118..27455b9 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -677,10 +677,14 @@ void __init initmem_init(void)
 static void __init zone_sizes_init(void)
 {
 	unsigned long max_zone_pfns[MAX_NR_ZONES];
+
 	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
 #ifdef CONFIG_ZONE_DMA
 	max_zone_pfns[ZONE_DMA] = MAX_DMA_PFN;
 #endif
+#ifdef CONFIG_ZONE_DMA32
+        max_zone_pfns[ZONE_DMA32] = MAX_DMA32_PFN;
+#endif
 	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
 #ifdef CONFIG_HIGHMEM
 	max_zone_pfns[ZONE_HIGHMEM] = max_pfn;
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index f6b1f08..06c4360 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -624,6 +624,9 @@ static void __init zone_sizes_init(void)
 	max_zone_pfns[ZONE_DMA32] = MAX_DMA32_PFN;
 #endif
 	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
+#ifdef CONFIG_HIGHMEM
+	max_zone_pfns[ZONE_HIGHMEM] = max_pfn;
+#endif
 
 	free_area_init_nodes(max_zone_pfns);
 }
