Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab2BTXUN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 18:20:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38706 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698Ab2BTXUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 18:20:12 -0500
Date: Mon, 20 Feb 2012 15:19:23 -0800
From: tip-bot for David Howells <dhowells@redhat.com>
Message-ID: <tip-e0891a9816316b5e05fd5b0453ffe9fd6a56f489@git.kernel.org>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, dhowells@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        arnd@arndb.de, dhowells@redhat.com, tglx@linutronix.de
In-Reply-To: <20120220223917.16199.9416.stgit@warthog.procyon.org.uk>
References: <20120220223917.16199.9416.stgit@warthog.procyon.org.uk>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] bitops: Adjust the comment on get_order()
  to describe the size==0 case
Git-Commit-ID: e0891a9816316b5e05fd5b0453ffe9fd6a56f489
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 20 Feb 2012 15:19:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e0891a9816316b5e05fd5b0453ffe9fd6a56f489
Gitweb:     http://git.kernel.org/tip/e0891a9816316b5e05fd5b0453ffe9fd6a56f489
Author:     David Howells <dhowells@redhat.com>
AuthorDate: Mon, 20 Feb 2012 22:39:18 +0000
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 20 Feb 2012 14:46:55 -0800

bitops: Adjust the comment on get_order() to describe the size==0 case

Adjust the comment on get_order() to note that the result of passing a size of
0 results in an undefined value.

Signed-off-by: David Howells <dhowells@redhat.com>
Link: http://lkml.kernel.org/r/20120220223917.16199.9416.stgit@warthog.procyon.org.uk
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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
