Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932452Ab1GNViM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 17:38:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:59949 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932232Ab1GNViK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 17:38:10 -0400
Date: Thu, 14 Jul 2011 21:38:02 GMT
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-a150439c4a97db379f0ed6faa46fbbb6e7bf3cb2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tj@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tj@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <4E1F4D2C.3000507@zytor.com>
References: <4E1F4D2C.3000507@zytor.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/memblock] memblock: Cast phys_addr_t to unsigned long long for printf use
Git-Commit-ID: a150439c4a97db379f0ed6faa46fbbb6e7bf3cb2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 14 Jul 2011 21:38:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a150439c4a97db379f0ed6faa46fbbb6e7bf3cb2
Gitweb:     http://git.kernel.org/tip/a150439c4a97db379f0ed6faa46fbbb6e7bf3cb2
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Thu, 14 Jul 2011 11:57:10 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 14 Jul 2011 11:57:10 -0700

memblock: Cast phys_addr_t to unsigned long long for printf use

phys_addr_t is not necessarily the same thing as unsigned long long.
It is, however, easier to cast it to unsigned long long for printf
purposes than it is to deal with differnent printf formats.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/r/4E1F4D2C.3000507@zytor.com
---
 mm/memblock.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 0cb4da6..a75723d 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -450,7 +450,9 @@ long __init_memblock memblock_remove(phys_addr_t base, phys_addr_t size)
 long __init_memblock memblock_free(phys_addr_t base, phys_addr_t size)
 {
 	memblock_dbg("   memblock_free: [%#016llx-%#016llx] %pF\n",
-		     base, base + size, (void *)_RET_IP_);
+		     (unsigned long long)base,
+		     (unsigned long long)base + size,
+		     (void *)_RET_IP_);
 
 	return __memblock_remove(&memblock.reserved, base, size);
 }
@@ -460,7 +462,9 @@ long __init_memblock memblock_reserve(phys_addr_t base, phys_addr_t size)
 	struct memblock_type *_rgn = &memblock.reserved;
 
 	memblock_dbg("memblock_reserve: [%#016llx-%#016llx] %pF\n",
-		     base, base + size, (void *)_RET_IP_);
+		     (unsigned long long)base,
+		     (unsigned long long)base + size,
+		     (void *)_RET_IP_);
 	BUG_ON(0 == size);
 
 	return memblock_add_region(_rgn, base, size);
