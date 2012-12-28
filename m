Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab2L1T1L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:27:11 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55645 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932425Ab2L1TTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:19:42 -0500
Message-Id: <20121228190337.265341459@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:04:05 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Will Deacon <will.deacon@arm.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [ 035/173] mm: highmem: export kmap_to_page for modules
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit f0263d2d222e9e25f2587e51a9dc58c6fb2a9352 upstream.

Some virtio device drivers (9p) need to translate high virtual addresses
to physical addresses, which are inserted into the virtqueue for
processing by userspace.

This patch exports the kmap_to_page symbol, so that the affected drivers
can be compiled as modules.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 mm/highmem.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/highmem.c b/mm/highmem.c
index d517cd1..2a07f97 100644
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -105,6 +105,7 @@ struct page *kmap_to_page(void *vaddr)
 
 	return virt_to_page(addr);
 }
+EXPORT_SYMBOL(kmap_to_page);
 
 static void flush_all_zero_pkmaps(void)
 {


