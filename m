Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128Ab0GASnT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:43:19 -0400
Received: from kroah.org ([198.145.64.141]:40464 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757648Ab0GASXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:23:25 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:32:12 2010
Message-Id: <20100701173212.041589897@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:31:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       David Howells <dhowells@redhat.com>,
       Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [patch 062/149] mn10300: set ARCH_KMALLOC_MINALIGN
In-Reply-To: <20100701175144.GA2116@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

commit 6cdafaae41d52e6ef9a5c5be23602ef083e4d0f9 upstream.

Architectures that handle DMA-non-coherent memory need to set
ARCH_KMALLOC_MINALIGN to make sure that kmalloc'ed buffer is DMA-safe: the
buffer doesn't share a cache with the others.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: David Howells <dhowells@redhat.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/mn10300/include/asm/cache.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/mn10300/include/asm/cache.h
+++ b/arch/mn10300/include/asm/cache.h
@@ -21,6 +21,8 @@
 #define L1_CACHE_DISPARITY	L1_CACHE_NENTRIES * L1_CACHE_BYTES
 #endif
 
+#define ARCH_KMALLOC_MINALIGN	L1_CACHE_BYTES
+
 /* data cache purge registers
  * - read from the register to unconditionally purge that cache line
  * - write address & 0xffffff00 to conditionally purge that cache line


