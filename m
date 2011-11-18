Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757736Ab1KRXX4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 18:23:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53166 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754618Ab1KRXXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 18:23:55 -0500
Date: Fri, 18 Nov 2011 15:23:35 -0800
From: tip-bot for Pekka Enberg <penberg@kernel.org>
Message-ID: <tip-4c0b2e5f8940fec7cbeafcf641fecd5e746329c5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, penberg@kernel.org, tj@kernel.org,
        tglx@linutronix.de, rientjes@google.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, penberg@kernel.org, tj@kernel.org,
        tglx@linutronix.de, rientjes@google.com, mingo@elte.hu
In-Reply-To: <1320155902-10424-2-git-send-email-penberg@kernel.org>
References: <1320155902-10424-2-git-send-email-penberg@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, mm: Move zone init from paging_init() on 64-bit
Git-Commit-ID: 4c0b2e5f8940fec7cbeafcf641fecd5e746329c5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 Nov 2011 15:23:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4c0b2e5f8940fec7cbeafcf641fecd5e746329c5
Gitweb:     http://git.kernel.org/tip/4c0b2e5f8940fec7cbeafcf641fecd5e746329c5
Author:     Pekka Enberg <penberg@kernel.org>
AuthorDate: Tue, 1 Nov 2011 15:58:17 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 11 Nov 2011 10:22:43 +0100

x86, mm: Move zone init from paging_init() on 64-bit

This patch introduces a zone_sizes_init() helper function on
64-bit to make it more similar to 32-bit init.

Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
Link: http://lkml.kernel.org/r/1320155902-10424-2-git-send-email-penberg@kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/init_64.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index bbaaa00..3ddda59 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -612,7 +612,7 @@ void __init initmem_init(void)
 }
 #endif
 
-void __init paging_init(void)
+static void __init zone_sizes_init(void)
 {
 	unsigned long max_zone_pfns[MAX_NR_ZONES];
 
@@ -623,6 +623,11 @@ void __init paging_init(void)
 	max_zone_pfns[ZONE_DMA32] = MAX_DMA32_PFN;
 	max_zone_pfns[ZONE_NORMAL] = max_pfn;
 
+	free_area_init_nodes(max_zone_pfns);
+}
+
+void __init paging_init(void)
+{
 	sparse_memory_present_with_active_regions(MAX_NUMNODES);
 	sparse_init();
 
@@ -634,7 +639,7 @@ void __init paging_init(void)
 	 */
 	node_clear_state(0, N_NORMAL_MEMORY);
 
-	free_area_init_nodes(max_zone_pfns);
+	zone_sizes_init();
 }
 
 /*
