Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061Ab2BEWf3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:35:29 -0500
Received: from 1wt.eu ([62.212.114.60]:62106 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754631Ab2BEW07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:26:59 -0500
Message-Id: <20120205220952.143885576@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:10:52 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Nick Piggin <npiggin@suse.de>,
        Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Robert Richter <robert.richter@amd.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 63/91] export __get_user_pages_fast() function
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

commit 45888a0c6edc305495b6bd72a30e66bc40b324c6 upstream.

Backport for stable kernel v2.6.32.y to v2.6.36.y.

Needed for next patch:

 oprofile, x86: Fix nmi-unsafe callgraph support

This function is used by KVM to pin process's page in the atomic context.

Define the 'weak' function to avoid other architecture not support it

Acked-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 mm/util.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

Index: longterm-2.6.27/mm/util.c
===================================================================
--- longterm-2.6.27.orig/mm/util.c	2012-02-05 22:34:33.070915063 +0100
+++ longterm-2.6.27/mm/util.c	2012-02-05 22:34:43.848914804 +0100
@@ -101,6 +101,19 @@
 }
 EXPORT_SYMBOL(__krealloc);
 
+/*
+ * Like get_user_pages_fast() except its IRQ-safe in that it won't fall
+ * back to the regular GUP.
+ * If the architecture not support this fucntion, simply return with no
+ * page pinned
+ */
+int __attribute__((weak)) __get_user_pages_fast(unsigned long start,
+				 int nr_pages, int write, struct page **pages)
+{
+	return 0;
+}
+EXPORT_SYMBOL_GPL(__get_user_pages_fast);
+
 /**
  * krealloc - reallocate memory. The contents will remain unchanged.
  * @p: object to reallocate memory for.


