Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab1DDW0v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 18:26:51 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46324 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755711Ab1DDWYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 18:24:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=Dx2em7d6Lv0OeCyWOukyuDpBVd9LlfKrYI2bq6v8o1NY0CpWtsVcyX6dAnHPbZeTGd
         p3XsyJpVgXPcSi3tzuAtOIwcNwHdbCbclyn+HYqJut+WsX0rHFprbStS/yAstHffx+Xy
         8URqVl48mg3+dmdsJI7xgXvpNYEEPA3VLVh/A=
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de, rientjes@google.com,
        yinghai@kernel.org, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/14] x86-32, NUMA: Align pgdat size while initializing alloc_remap
Date: Tue,  5 Apr 2011 00:23:48 +0200
Message-Id: <1301955840-7246-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1301955840-7246-1-git-send-email-tj@kernel.org>
References: <1301955840-7246-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When pgdat is reserved in init_remap_allocator(), PAGE_SIZE aligned
size will be used.  Match the size alignment in initialization to
avoid allocation failure down the road.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
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
-- 
1.7.1

