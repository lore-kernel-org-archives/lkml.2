Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760783Ab1LPUyt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 15:54:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48975 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964936Ab1LPUvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 15:51:49 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Dec 16 12:50:43 2011
Message-Id: <20111216205043.392878849@clark.kroah.org>
User-Agent: quilt/0.50-24.1
Date: Fri, 16 Dec 2011 12:49:45 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Greg KH <greg@kroah.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        Nick Piggin <npiggin@suse.de>,
        Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Robert Richter <robert.richter@amd.com>
Subject: [12/16] export __get_user_pages_fast() function
In-Reply-To: <20111216205049.GA28030@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------


From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

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
 1 file changed, 13 insertions(+)

--- a/mm/util.c
+++ b/mm/util.c
@@ -233,6 +233,19 @@ void arch_pick_mmap_layout(struct mm_str
 }
 #endif
 
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
  * get_user_pages_fast() - pin user pages in memory
  * @start:	starting user address


