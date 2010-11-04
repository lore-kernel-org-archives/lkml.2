Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab0KDItC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 04:49:02 -0400
Received: from mga02.intel.com ([134.134.136.20]:34881 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752266Ab0KDIn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 04:43:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,294,1286175600"; 
   d="scan'208";a="570251140"
From: xiaohui.xin@intel.com
To: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, mingo@elte.hu, davem@davemloft.net,
        herbert@gondor.hengli.com.au, jdike@linux.intel.com
Cc: Xin Xiaohui <xiaohui.xin@intel.com>
Subject: [PATCH v14 01/17] Add a new structure for skb buffer from external.
Date: Thu,  4 Nov 2010 17:04:57 +0800
Message-Id: <fc6e95d63a2c62aaf77f8ded22fc43ccefcdbbff.1288860477.git.xiaohui.xin@intel.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1288861513-5707-1-git-send-email-xiaohui.xin@intel.com>
References: <1288861513-5707-1-git-send-email-xiaohui.xin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xin Xiaohui <xiaohui.xin@intel.com>

Signed-off-by: Xin Xiaohui <xiaohui.xin@intel.com>
Signed-off-by: Zhao Yu <yzhao81new@gmail.com>
Reviewed-by: Jeff Dike <jdike@linux.intel.com>
---
 include/linux/skbuff.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 77eb60d..696e690 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -211,6 +211,15 @@ struct skb_shared_info {
 	skb_frag_t	frags[MAX_SKB_FRAGS];
 };
 
+/* The structure is for a skb which pages may point to
+ * an external buffer, which is not allocated from kernel space.
+ * It also contains a destructor for itself.
+ */
+struct skb_ext_page {
+	struct		page *page;
+	void		(*dtor)(struct skb_ext_page *);
+};
+
 /* We divide dataref into two halves.  The higher 16 bits hold references
  * to the payload part of skb->data.  The lower 16 bits hold references to
  * the entire skb->data.  A clone of a headerless skb holds the length of
-- 
1.7.3

