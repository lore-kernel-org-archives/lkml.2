Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758751Ab1BPIvH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 03:51:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:53774 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757400Ab1BPIvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 03:51:03 -0500
Date: Wed, 16 Feb 2011 08:50:48 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <4D1933C8.7060105@kernel.org>
References: <4D1933C8.7060105@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86-64, numa: Allocate memnodemap under max_pfn_mapped
Message-ID: <tip-dbef7b56d2fc5115f26f72a0b080283bbf972cab@git.kernel.org>
Git-Commit-ID: dbef7b56d2fc5115f26f72a0b080283bbf972cab
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 16 Feb 2011 08:50:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dbef7b56d2fc5115f26f72a0b080283bbf972cab
Gitweb:     http://git.kernel.org/tip/dbef7b56d2fc5115f26f72a0b080283bbf972cab
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Mon, 27 Dec 2010 16:48:08 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 29 Dec 2010 15:48:08 -0800

x86-64, numa: Allocate memnodemap under max_pfn_mapped

We need to access it right way, so make sure that it is mapped already.

Prepare to put page table on local node, and nodemap is used before that.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <4D1933C8.7060105@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/numa_64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 7762a51..02d36ff 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -87,7 +87,7 @@ static int __init allocate_cachealigned_memnodemap(void)
 
 	addr = 0x8000;
 	nodemap_size = roundup(sizeof(s16) * memnodemapsize, L1_CACHE_BYTES);
-	nodemap_addr = memblock_find_in_range(addr, max_pfn<<PAGE_SHIFT,
+	nodemap_addr = memblock_find_in_range(addr, get_max_mapped(),
 				      nodemap_size, L1_CACHE_BYTES);
 	if (nodemap_addr == MEMBLOCK_ERROR) {
 		printk(KERN_ERR
