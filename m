Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363Ab1KRXXL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 18:23:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53155 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064Ab1KRXXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 18:23:09 -0500
Date: Fri, 18 Nov 2011 15:22:49 -0800
From: tip-bot for Pekka Enberg <penberg@kernel.org>
Message-ID: <tip-ff14c1d01576fb839a925a42596582f6c68a1a1a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, penberg@kernel.org, tj@kernel.org,
        tglx@linutronix.de, rientjes@google.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, penberg@kernel.org, tj@kernel.org,
        tglx@linutronix.de, rientjes@google.com, mingo@elte.hu
In-Reply-To: <1320155902-10424-1-git-send-email-penberg@kernel.org>
References: <1320155902-10424-1-git-send-email-penberg@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, mm: Use MAX_DMA_PFN for ZONE_DMA on 32-bit
Git-Commit-ID: ff14c1d01576fb839a925a42596582f6c68a1a1a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 Nov 2011 15:22:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ff14c1d01576fb839a925a42596582f6c68a1a1a
Gitweb:     http://git.kernel.org/tip/ff14c1d01576fb839a925a42596582f6c68a1a1a
Author:     Pekka Enberg <penberg@kernel.org>
AuthorDate: Tue, 1 Nov 2011 15:58:16 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 11 Nov 2011 10:22:41 +0100

x86, mm: Use MAX_DMA_PFN for ZONE_DMA on 32-bit

Use MAX_DMA_PFN which represents the 16 MB ISA DMA limit on
32-bit x86 just like we do on 64-bit.

Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
Link: http://lkml.kernel.org/r/1320155902-10424-1-git-send-email-penberg@kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/init_32.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 29f7c6d..434c97d 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -679,8 +679,7 @@ static void __init zone_sizes_init(void)
 	unsigned long max_zone_pfns[MAX_NR_ZONES];
 	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
 #ifdef CONFIG_ZONE_DMA
-	max_zone_pfns[ZONE_DMA] =
-		virt_to_phys((char *)MAX_DMA_ADDRESS) >> PAGE_SHIFT;
+	max_zone_pfns[ZONE_DMA] = MAX_DMA_PFN;
 #endif
 	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
 #ifdef CONFIG_HIGHMEM
