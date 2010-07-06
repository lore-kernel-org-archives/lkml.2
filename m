Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab0GFKuv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 06:50:51 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60483 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753014Ab0GFKuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 06:50:50 -0400
Message-ID: <4C3309A0.6030005@cn.fujitsu.com>
Date: Tue, 06 Jul 2010 18:46:56 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Nick Piggin <npiggin@suse.de>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: [PATCH v5 3/9] export __get_user_pages_fast() function
References: <4C330918.6040709@cn.fujitsu.com> <4C330948.1070305@cn.fujitsu.com>
In-Reply-To: <4C330948.1070305@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function is used by KVM to pin process's page in the atomic context.

Define the 'weak' function to avoid other architecture not support it

Acked-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 mm/util.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

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
1.6.1.2


