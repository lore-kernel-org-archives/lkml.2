Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773Ab0IRQBw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 12:01:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:41901 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754837Ab0IRQBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 12:01:04 -0400
Message-Id: <20100918155652.809148647@chello.nl>
User-Agent: quilt/0.47-1
Date: Sat, 18 Sep 2010 17:53:30 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <rmk@arm.linux.org.uk>,
        David Howells <dhowells@redhat.com>,
        Ralf Baechle <ralf@linux-mips.org>, David Miller <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>, Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-arch@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 4/5] perf, x86: Fix up kmap_atomic type
References: <20100918155326.478277313@chello.nl>
Content-Disposition: inline; filename=kmap-x86-perf.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the KM_type stuff is history, clean up the compiler warning.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/x86/kernel/cpu/perf_event.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -49,7 +49,6 @@ static unsigned long
 copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
 {
 	unsigned long offset, addr = (unsigned long)from;
-	int type = in_nmi() ? KM_NMI : KM_IRQ0;
 	unsigned long size, len = 0;
 	struct page *page;
 	void *map;
@@ -63,9 +62,9 @@ copy_from_user_nmi(void *to, const void 
 		offset = addr & (PAGE_SIZE - 1);
 		size = min(PAGE_SIZE - offset, n - len);
 
-		map = kmap_atomic(page, type);
+		map = kmap_atomic(page);
 		memcpy(to, map+offset, size);
-		kunmap_atomic(map, type);
+		kunmap_atomic(map);
 		put_page(page);
 
 		len  += size;


