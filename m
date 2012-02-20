Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab2BTWja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 17:39:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754287Ab2BTWj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 17:39:29 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/2] Adjust the comment on get_order() to describe the size==0
 case
To: hpa@zytor.com
Cc: x86@kernel.org, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>, Arnd Bergmann <arnd@arndb.de>
Date: Mon, 20 Feb 2012 22:39:18 +0000
Message-ID: <20120220223917.16199.9416.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adjust the comment on get_order() to note that the result of passing a size of
0 results in an undefined value.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---

 include/asm-generic/getorder.h |   23 ++++++++++++++++++++++-
 1 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/getorder.h b/include/asm-generic/getorder.h
index 67e7245..76e9687 100644
--- a/include/asm-generic/getorder.h
+++ b/include/asm-generic/getorder.h
@@ -5,7 +5,28 @@
 
 #include <linux/compiler.h>
 
-/* Pure 2^n version of get_order */
+/**
+ * get_order - Determine the allocation order of a memory size
+ * @size: The size for which to get the order
+ *
+ * Determine the allocation order of a particular sized block of memory.  This
+ * is on a logarithmic scale, where:
+ *
+ *	0 -> 2^0 * PAGE_SIZE and below
+ *	1 -> 2^1 * PAGE_SIZE to 2^0 * PAGE_SIZE + 1
+ *	2 -> 2^2 * PAGE_SIZE to 2^1 * PAGE_SIZE + 1
+ *	3 -> 2^3 * PAGE_SIZE to 2^2 * PAGE_SIZE + 1
+ *	4 -> 2^4 * PAGE_SIZE to 2^3 * PAGE_SIZE + 1
+ *	...
+ *
+ * The order returned is used to find the smallest allocation granule required
+ * to hold an object of the specified size.
+ *
+ * The result is undefined if the size is 0.
+ *
+ * This function may be used to initialise variables with compile time
+ * evaluations of constants.
+ */
 static inline __attribute_const__ int get_order(unsigned long size)
 {
 	int order;

