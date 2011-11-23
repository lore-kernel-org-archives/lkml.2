Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758667Ab1KWIno (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 03:43:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18119 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752907Ab1KWInn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 03:43:43 -0500
Date: Wed, 23 Nov 2011 16:45:43 +0800
From: Dave Young <dyoung@redhat.com>
To: tj@kernel.org, xiyou.wangcong@gmail.com, kexec@lists.infradead.org,
        tim@edgecast.com, linux-kernel@vger.kernel.org
Subject: [PATCH] percpu: add comment to per_cpu_ptr_to_phys
Message-ID: <20111123084543.GA2923@darkstar.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add comments about current per_cpu_ptr_to_phys implementation
to explain why the logic is more complicated than necessary.

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 mm/percpu.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- linux-2.6.orig/mm/percpu.c	2011-11-22 10:18:46.000000000 +0800
+++ linux-2.6/mm/percpu.c	2011-11-23 16:27:01.667562973 +0800
@@ -988,6 +988,19 @@ phys_addr_t per_cpu_ptr_to_phys(void *ad
 	unsigned int cpu;
 
 	/*
+	 * percpu allocator has special setup for the first chunk,
+	 * which currently supports either embedding in linear address space
+	 * or vmalloc mapping, and, from the second one, the backing
+	 * allocator (currently either vm or km) provides translation.
+	 *
+	 * The addr can be tranlated simply without checking if it falls
+	 * into the first chunk. But the current code reflects better
+	 * how percpu allocator actually works, and the verification can
+	 * discover both bugs in percpu allocator itself and
+	 * per_cpu_ptr_to_phys() callers. So we keep current code.
+	 */
+
+	/*
 	 * The following test on first_start/end isn't strictly
 	 * necessary but will speed up lookups of addresses which
 	 * aren't in the first chunk.
