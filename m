Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176Ab1DGCEg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 22:04:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:42443 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757107Ab1DGCEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 22:04:34 -0400
Date: Thu, 7 Apr 2011 02:04:24 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, tj@kernel.org, tglx@linutronix.de,
        rientjes@google.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tj@kernel.org, tglx@linutronix.de,
        rientjes@google.com
In-Reply-To: <1301955840-7246-3-git-send-email-tj@kernel.org>
References: <1301955840-7246-3-git-send-email-tj@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/numa] x86-32, numa: Align pgdat size while initializing alloc_remap
Message-ID: <tip-a6c24f7a705d939ddd2fcaa443fa3d8e852b933d@git.kernel.org>
Git-Commit-ID: a6c24f7a705d939ddd2fcaa443fa3d8e852b933d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 07 Apr 2011 02:04:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a6c24f7a705d939ddd2fcaa443fa3d8e852b933d
Gitweb:     http://git.kernel.org/tip/a6c24f7a705d939ddd2fcaa443fa3d8e852b933d
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Tue, 5 Apr 2011 00:23:48 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 6 Apr 2011 17:56:52 -0700

x86-32, numa: Align pgdat size while initializing alloc_remap

When pgdat is reserved in init_remap_allocator(), PAGE_SIZE aligned
size will be used.  Match the size alignment in initialization to
avoid allocation failure down the road.

Signed-off-by: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/r/1301955840-7246-3-git-send-email-tj@kernel.org
Acked-by: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/mm/numa_32.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
index 84aac47..50e8250 100644
--- a/arch/x86/mm/numa_32.c
+++ b/arch/x86/mm/numa_32.c
@@ -287,7 +287,8 @@ static __init unsigned long calculate_numa_remap_pages(void)
 			node_end_pfn[nid] = max_pfn;
 
 		/* ensure the remap includes space for the pgdat. */
-		size = node_remap_size[nid] + sizeof(pg_data_t);
+		size = node_remap_size[nid];
+		size += ALIGN(sizeof(pg_data_t), PAGE_SIZE);
 
 		/* convert size to large (pmd size) pages, rounding up */
 		size = (size + LARGE_PAGE_BYTES - 1) / LARGE_PAGE_BYTES;
