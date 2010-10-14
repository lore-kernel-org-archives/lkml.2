Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab0JNVQN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 17:16:13 -0400
Received: from king.tilera.com ([72.1.168.226]:52851 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755567Ab0JNVQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 17:16:11 -0400
Message-Id: <bbacff94d0c38163ef01361de006797c92e69e58.1287090286.git.cmetcalf@tilera.com>
In-Reply-To: <cover.1287090280.git.cmetcalf@tilera.com>
References: <cover.1287090280.git.cmetcalf@tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 14 Oct 2010 15:09:02 -0400
Subject: [PATCH 02/14] arch/tile: provide a definition of MAP_STACK
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
X-OriginalArrivalTime: 14 Oct 2010 21:16:10.0606 (UTC) FILETIME=[0635C0E0:01CB6BE5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's convenient for userspace (in particular, glibc) to find a
definition of MAP_STACK.  We use MAP_GROWSDOWN as an alias since
that's appropriate for the main stack, and since our current
allocation of mmap flags bits is running a bit short otherwise.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/mman.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/tile/include/asm/mman.h b/arch/tile/include/asm/mman.h
index 4c6811e..81b8fc3 100644
--- a/arch/tile/include/asm/mman.h
+++ b/arch/tile/include/asm/mman.h
@@ -23,6 +23,7 @@
 #define MAP_POPULATE	0x0040		/* populate (prefault) pagetables */
 #define MAP_NONBLOCK	0x0080		/* do not block on IO */
 #define MAP_GROWSDOWN	0x0100		/* stack-like segment */
+#define MAP_STACK	MAP_GROWSDOWN	/* provide convenience alias */
 #define MAP_LOCKED	0x0200		/* pages are locked */
 #define MAP_NORESERVE	0x0400		/* don't check for reservations */
 #define MAP_DENYWRITE	0x0800		/* ETXTBSY */
-- 
1.6.5.2

