Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775Ab0CXRF6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 13:05:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751512Ab0CXRF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 13:05:57 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FRV: Hide uncached_access() when pgprot_noncached is not
	#defined
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Wed, 24 Mar 2010 17:05:47 +0000
Message-ID: <20100324170547.10751.57449.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hide uncached_access() when pgprot_noncached is not #defined.  This prevents
the following warning:

	  CC      drivers/char/mem.o
	drivers/char/mem.c:229: warning: 'uncached_access' defined but not used

Signed-off-by: David Howells <dhowells@redhat.com>
---

 drivers/char/mem.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)


diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 1f3215a..0e16cd5 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -225,6 +225,7 @@ int __weak phys_mem_access_prot_allowed(struct file *file,
  * outside of main memory.
  *
  */
+#ifdef pgprot_noncached
 static int uncached_access(struct file *file, unsigned long addr)
 {
 #if defined(CONFIG_IA64)
@@ -251,6 +252,7 @@ static int uncached_access(struct file *file, unsigned long addr)
 	return addr >= __pa(high_memory);
 #endif
 }
+#endif
 
 static pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 				     unsigned long size, pgprot_t vma_prot)

