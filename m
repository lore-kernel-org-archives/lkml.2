Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940Ab0KIIqI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 03:46:08 -0500
Received: from mga01.intel.com ([192.55.52.88]:25013 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753862Ab0KIIl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 03:41:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,174,1288594800"; 
   d="scan'208";a="624917683"
From: xiaohui.xin@intel.com
To: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, mingo@elte.hu, davem@davemloft.net,
        herbert@gondor.hengli.com.au, jdike@linux.intel.com
Cc: Xin Xiaohui <xiaohui.xin@intel.com>
Subject: [PATCH v15 01/17] Add a new structure for skb buffer from external.
Date: Tue,  9 Nov 2010 17:03:06 +0800
Message-Id: <fc6e95d63a2c62aaf77f8ded22fc43ccefcdbbff.1289280885.git.xiaohui.xin@intel.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1289293402-4791-1-git-send-email-xiaohui.xin@intel.com>
References: <1289293402-4791-1-git-send-email-xiaohui.xin@intel.com>
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

