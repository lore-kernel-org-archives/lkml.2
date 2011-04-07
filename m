Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902Ab1DGCEM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 22:04:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:42429 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555Ab1DGCEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 22:04:11 -0400
Date: Thu, 7 Apr 2011 02:03:57 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, tj@kernel.org, tglx@linutronix.de,
        rientjes@google.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tj@kernel.org, tglx@linutronix.de,
        rientjes@google.com
In-Reply-To: <1301955840-7246-2-git-send-email-tj@kernel.org>
References: <1301955840-7246-2-git-send-email-tj@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/numa] x86-32, numa: Fix failure condition check in alloc_remap()
Message-ID: <tip-3fe14ab541cd9b0d1f243afb7556046f12c8743c@git.kernel.org>
Git-Commit-ID: 3fe14ab541cd9b0d1f243afb7556046f12c8743c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 07 Apr 2011 02:03:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3fe14ab541cd9b0d1f243afb7556046f12c8743c
Gitweb:     http://git.kernel.org/tip/3fe14ab541cd9b0d1f243afb7556046f12c8743c
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Tue, 5 Apr 2011 00:23:47 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 6 Apr 2011 17:56:46 -0700

x86-32, numa: Fix failure condition check in alloc_remap()

node_remap_{start|end}_vaddr[] describe [start, end) ranges; however,
alloc_remap() incorrectly failed when the current allocation + size
equaled the end but it should fail only when it goes over.  Fix it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/r/1301955840-7246-2-git-send-email-tj@kernel.org
Acked-by: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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
