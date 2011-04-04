Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab1DDWYO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 18:24:14 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47295 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755578Ab1DDWYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 18:24:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=teRtaV1LrNh451gcvoPOyP7iltvVgXARe9igkXEVvYZAM3tiwzXKTgKOF+TOkGy6Rf
         lTEVmQXzUu6KiCw499e1IyyB+NTe+8ucbrJzx1mBS3WtJP2jR/OEoW4rUtXTS8m9s8sz
         6ZscyjIyc3ymU2hlHsTgJSDF2623n5xStNV18=
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de, rientjes@google.com,
        yinghai@kernel.org, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/14] x86-32, NUMA: Fix failure condition check in alloc_remap()
Date: Tue,  5 Apr 2011 00:23:47 +0200
Message-Id: <1301955840-7246-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1301955840-7246-1-git-send-email-tj@kernel.org>
References: <1301955840-7246-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

node_remap_{start|end}_vaddr[] describe [start, end) ranges; however,
alloc_remap() incorrectly failed when the current allocation + size
equaled the end but it should fail only when it goes over.  Fix it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/mm/numa_32.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
index bde3906..84aac47 100644
--- a/arch/x86/mm/numa_32.c
+++ b/arch/x86/mm/numa_32.c
@@ -200,7 +200,7 @@ void *alloc_remap(int nid, unsigned long size)
 
 	size = ALIGN(size, L1_CACHE_BYTES);
 
-	if (!allocation || (allocation + size) >= node_remap_end_vaddr[nid])
+	if (!allocation || (allocation + size) > node_remap_end_vaddr[nid])
 		return NULL;
 
 	node_remap_alloc_vaddr[nid] += size;
-- 
1.7.1

