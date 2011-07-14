Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749Ab1GNDin (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 23:38:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:58725 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753509Ab1GNDim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 23:38:42 -0400
Date: Thu, 14 Jul 2011 03:38:34 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Message-ID: <tip-15fb09722df32b7685be1cbcac198bb556ddaffe@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        benh@kernel.crashing.org, yinghai@kernel.org, tj@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, benh@kernel.crashing.org, tj@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1310457490-3356-4-git-send-email-tj@kernel.org>
References: <1310457490-3356-4-git-send-email-tj@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/memblock] memblock: Use MEMBLOCK_ALLOC_ACCESSIBLE instead of ANYWHERE in memblock_alloc_try_nid()
Git-Commit-ID: 15fb09722df32b7685be1cbcac198bb556ddaffe
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 14 Jul 2011 03:38:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  15fb09722df32b7685be1cbcac198bb556ddaffe
Gitweb:     http://git.kernel.org/tip/15fb09722df32b7685be1cbcac198bb556ddaffe
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Tue, 12 Jul 2011 09:58:07 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 13 Jul 2011 16:35:58 -0700

memblock: Use MEMBLOCK_ALLOC_ACCESSIBLE instead of ANYWHERE in memblock_alloc_try_nid()

After node affine allocation fails, memblock_alloc_try_nid() calls
memblock_alloc_base() with @max_addr set to MEMBLOCK_ALLOC_ANYWHERE.
This is inconsistent with memblock_alloc() and what the function's
sole user - sparc/mm/init_64 - expects, although it doesn't make any
difference as sparc64 doesn't have highmem and ACCESSIBLE equals
ANYWHERE.

This patch makes memblock_alloc_try_nid() use ACCESSIBLE instead of
ANYWHERE.  This isn't complete as node affine allocation doesn't
consider memblock.current_limit.  It will be handled with future
changes.

This patch doesn't introduce any behavior difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/r/1310457490-3356-4-git-send-email-tj@kernel.org
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 mm/memblock.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index a0562d1..87e512d 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -612,7 +612,7 @@ phys_addr_t __init memblock_alloc_try_nid(phys_addr_t size, phys_addr_t align, i
 
 	if (res)
 		return res;
-	return memblock_alloc_base(size, align, MEMBLOCK_ALLOC_ANYWHERE);
+	return memblock_alloc_base(size, align, MEMBLOCK_ALLOC_ACCESSIBLE);
 }
 
 
