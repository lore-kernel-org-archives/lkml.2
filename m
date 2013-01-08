Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757054Ab3AHXjN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:39:13 -0500
Received: from mail.windriver.com ([147.11.1.11]:63723 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756935Ab3AHXif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:38:35 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 55/77] export __get_user_pages_fast() function
Date: Tue, 8 Jan 2013 18:35:34 -0500
Message-ID: <1357688156-25387-56-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
References: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 45888a0c6edc305495b6bd72a30e66bc40b324c6 upstream.

This function is used by KVM to pin process's page in the atomic context.

Define the 'weak' function to avoid other architecture not support it

Acked-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 mm/util.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/mm/util.c b/mm/util.c
index f5712e8..4f0d32b 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -250,6 +250,19 @@ void arch_pick_mmap_layout(struct mm_struct *mm)
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
-- 
1.7.12.1

