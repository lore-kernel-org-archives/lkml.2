Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759186Ab0GAVm7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:42:59 -0400
Received: from kroah.org ([198.145.64.141]:32902 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759122Ab0GAVOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:14:25 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:56 2010
Message-Id: <20100701174256.472164764@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:43:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [119/200] SLUB: Allow full duplication of kmalloc array for 390
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Lameter <cl@linux-foundation.org>

commit 0f1f694260e0d35b5ce7d471f6e679c3dd4d7d94 upstream.

Commit 756dee75872a2a764b478e18076360b8a4ec9045 ("SLUB: Get rid of dynamic DMA
kmalloc cache allocation") makes S390 run out of kmalloc caches.  Increase the
number of kmalloc caches to a safe size.

Reported-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Tested-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/slub_def.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -132,7 +132,7 @@ struct kmem_cache {
 #ifdef CONFIG_ZONE_DMA
 #define SLUB_DMA __GFP_DMA
 /* Reserve extra caches for potential DMA use */
-#define KMALLOC_CACHES (2 * SLUB_PAGE_SHIFT - 6)
+#define KMALLOC_CACHES (2 * SLUB_PAGE_SHIFT)
 #else
 /* Disable DMA functionality */
 #define SLUB_DMA (__force gfp_t)0


