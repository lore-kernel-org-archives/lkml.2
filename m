Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab0JLACI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 20:02:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:50198 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753754Ab0JLACG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 20:02:06 -0400
Date: Tue, 12 Oct 2010 00:01:41 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, sfr@canb.auug.org.au, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, sfr@canb.auug.org.au,
        hpa@linux.intel.com
In-Reply-To: <4CB366B1.40405@kernel.org>
References: <4CB366B1.40405@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/memblock] memblock: Annotate memblock functions with __init_memblock
Message-ID: <tip-cd79481d27b9f90aad80c9b972292c42c25bbf8e@git.kernel.org>
Git-Commit-ID: cd79481d27b9f90aad80c9b972292c42c25bbf8e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 12 Oct 2010 00:01:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cd79481d27b9f90aad80c9b972292c42c25bbf8e
Gitweb:     http://git.kernel.org/tip/cd79481d27b9f90aad80c9b972292c42c25bbf8e
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Mon, 11 Oct 2010 12:34:09 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 11 Oct 2010 16:00:52 -0700

memblock: Annotate memblock functions with __init_memblock

Stephen found

WARNING: mm/built-in.o(.text+0x25ab8): Section mismatch in reference from the function memblock_find_base() to the function .init.text:memblock_find_region()
The function memblock_find_base() references
the function __init memblock_find_region().
This is often because memblock_find_base lacks a __init
annotation or the annotation of memblock_find_region is wrong.

So let memblock_find_region() to use __init_memblock instead of __init
directly.

Also fix one function that did not have __init* to be __init_memblock.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <4CB366B1.40405@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 mm/memblock.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index ae8b06c..400dc62 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -99,7 +99,7 @@ long __init_memblock memblock_overlaps_region(struct memblock_type *type, phys_a
  * are top-down.
  */
 
-static phys_addr_t __init memblock_find_region(phys_addr_t start, phys_addr_t end,
+static phys_addr_t __init_memblock memblock_find_region(phys_addr_t start, phys_addr_t end,
 					  phys_addr_t size, phys_addr_t align)
 {
 	phys_addr_t base, res_base;
@@ -653,7 +653,7 @@ void __init memblock_enforce_memory_limit(phys_addr_t memory_limit)
 	}
 }
 
-static int memblock_search(struct memblock_type *type, phys_addr_t addr)
+static int __init_memblock memblock_search(struct memblock_type *type, phys_addr_t addr)
 {
 	unsigned int left = 0, right = type->cnt;
 
