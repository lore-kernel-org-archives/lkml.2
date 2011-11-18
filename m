Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943Ab1KRX0O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 18:26:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53213 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756209Ab1KRX0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 18:26:12 -0500
Date: Fri, 18 Nov 2011 15:25:53 -0800
From: tip-bot for Pekka Enberg <penberg@kernel.org>
Message-ID: <tip-ece838b6257412647197c072fe59dfc6615df144@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, penberg@kernel.org, tj@kernel.org,
        tglx@linutronix.de, rientjes@google.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, penberg@kernel.org, tj@kernel.org,
        tglx@linutronix.de, rientjes@google.com, mingo@elte.hu
In-Reply-To: <1320155902-10424-5-git-send-email-penberg@kernel.org>
References: <1320155902-10424-5-git-send-email-penberg@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, mm: Use max_low_pfn for ZONE_NORMAL on 64-bit
Git-Commit-ID: ece838b6257412647197c072fe59dfc6615df144
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 Nov 2011 15:25:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ece838b6257412647197c072fe59dfc6615df144
Gitweb:     http://git.kernel.org/tip/ece838b6257412647197c072fe59dfc6615df144
Author:     Pekka Enberg <penberg@kernel.org>
AuthorDate: Tue, 1 Nov 2011 15:58:20 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 11 Nov 2011 10:22:50 +0100

x86, mm: Use max_low_pfn for ZONE_NORMAL on 64-bit

64-bit has no highmem so max_low_pfn is always the same as
'max_pfn'.

Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
Link: http://lkml.kernel.org/r/1320155902-10424-5-git-send-email-penberg@kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
