Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372Ab0GMKUE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 06:20:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7791 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756279Ab0GMKT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 06:19:59 -0400
Date: Tue, 13 Jul 2010 06:19:06 -0400
From: Xiaotian Feng <dfeng@redhat.com>
To: linux-mm@kvack.org, linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Cc: riel@redhat.com, cl@linux-foundation.org, a.p.zijlstra@chello.nl,
        Xiaotian Feng <dfeng@redhat.com>, linux-kernel@vger.kernel.org,
        lwang@redhat.com, penberg@cs.helsinki.fi, akpm@linux-foundation.org,
        davem@davemloft.net
Message-Id: <20100713101906.2835.83443.sendpatchset@danny.redhat>
In-Reply-To: <20100713101650.2835.15245.sendpatchset@danny.redhat>
References: <20100713101650.2835.15245.sendpatchset@danny.redhat>
Subject: [PATCH -mmotm 12/30] selinux: tag avc cache alloc as non-critical
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 6c3a91091b2910c23908a9f9953efcf3df14e522 Mon Sep 17 00:00:00 2001
From: Xiaotian Feng <dfeng@redhat.com>
Date: Tue, 13 Jul 2010 11:02:41 +0800
Subject: [PATCH 12/30] selinux: tag avc cache alloc as non-critical

Failing to allocate a cache entry will only harm performance not correctness.
Do not consume valuable reserve pages for something like that.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>
Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
---
 security/selinux/avc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/security/selinux/avc.c b/security/selinux/avc.c
index 3662b0f..9029395 100644
--- a/security/selinux/avc.c
+++ b/security/selinux/avc.c
@@ -284,7 +284,7 @@ static struct avc_node *avc_alloc_node(void)
 {
 	struct avc_node *node;
 
-	node = kmem_cache_zalloc(avc_node_cachep, GFP_ATOMIC);
+	node = kmem_cache_zalloc(avc_node_cachep, GFP_ATOMIC|__GFP_NOMEMALLOC);
 	if (!node)
 		goto out;
 
-- 
1.7.1.1

