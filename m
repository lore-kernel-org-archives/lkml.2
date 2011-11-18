Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757988Ab1KRXZm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 18:25:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53202 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757718Ab1KRXZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 18:25:39 -0500
Date: Fri, 18 Nov 2011 15:25:07 -0800
From: tip-bot for Pekka Enberg <penberg@kernel.org>
Message-ID: <tip-80b3cac97bc14fdf839d967602e599cbf82ea336@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, penberg@kernel.org, tj@kernel.org,
        tglx@linutronix.de, rientjes@google.com, mingo@elte.hu, asharma@fb.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, penberg@kernel.org, tj@kernel.org,
        tglx@linutronix.de, rientjes@google.com, mingo@elte.hu, asharma@fb.com
In-Reply-To: <1320155902-10424-4-git-send-email-penberg@kernel.org>
References: <1320155902-10424-4-git-send-email-penberg@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, mm: Wrap ZONE_DMA32 with CONFIG_ZONE_DMA32
Git-Commit-ID: 80b3cac97bc14fdf839d967602e599cbf82ea336
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 Nov 2011 15:25:17 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  80b3cac97bc14fdf839d967602e599cbf82ea336
Gitweb:     http://git.kernel.org/tip/80b3cac97bc14fdf839d967602e599cbf82ea336
Author:     Pekka Enberg <penberg@kernel.org>
AuthorDate: Tue, 1 Nov 2011 15:58:19 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 11 Nov 2011 10:22:48 +0100

x86, mm: Wrap ZONE_DMA32 with CONFIG_ZONE_DMA32

In preparation for unifying 32-bit and 64-bit zone_sizes_init()
make sure ZONE_DMA32 is wrapped in CONFIG_ZONE_DMA32.

Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Arun Sharma <asharma@fb.com>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
Link: http://lkml.kernel.org/r/1320155902-10424-4-git-send-email-penberg@kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
