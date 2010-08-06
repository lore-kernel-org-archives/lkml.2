Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933507Ab0HFJJG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 05:09:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:28117 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759360Ab0HFJI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 05:08:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,327,1278313200"; 
   d="scan'208";a="593547759"
From: xiaohui.xin@intel.com
To: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, mingo@elte.hu, davem@davemloft.net,
        herbert@gondor.hengli.com.au, jdike@linux.intel.com
Cc: Xin Xiaohui <xiaohui.xin@intel.com>
Subject: [RFC PATCH v9 01/16] Add a new structure for skb buffer from external.
Date: Fri,  6 Aug 2010 17:23:29 +0800
Message-Id: <1281086624-5765-2-git-send-email-xiaohui.xin@intel.com>
X-Mailer: git-send-email 1.5.4.4
In-Reply-To: <1281086624-5765-1-git-send-email-xiaohui.xin@intel.com>
References: <1281086624-5765-1-git-send-email-xiaohui.xin@intel.com>
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
index 124f90c..74af06c 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -203,6 +203,15 @@ struct skb_shared_info {
 	void *		destructor_arg;
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
1.5.4.4

