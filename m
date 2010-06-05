Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932795Ab0FEKGz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 06:06:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:64909 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932711Ab0FEKGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 06:06:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,366,1272870000"; 
   d="scan'208";a="804988009"
From: xiaohui.xin@intel.com
To: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       mst@redhat.com, mingo@elte.hu, davem@davemloft.net,
       herbert@gondor.hengli.com.au, jdike@linux.intel.com
Cc: Xin Xiaohui <xiaohui.xin@intel.com>
Subject: [RFC PATCH v7 01/19] Add a new structure for skb buffer from external.
Date: Sat,  5 Jun 2010 18:14:40 +0800
Message-Id: <1275732899-5423-1-git-send-email-xiaohui.xin@intel.com>
X-Mailer: git-send-email 1.5.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xin Xiaohui <xiaohui.xin@intel.com>

Signed-off-by: Xin Xiaohui <xiaohui.xin@intel.com>
Signed-off-by: Zhao Yu <yzhao81new@gmail.com>
Reviewed-by: Jeff Dike <jdike@linux.intel.com>
---
 include/linux/skbuff.h |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 124f90c..cf309c9 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -203,6 +203,18 @@ struct skb_shared_info {
 	void *		destructor_arg;
 };
 
+/* The structure is for a skb which skb->data may point to
+ * an external buffer, which is not allocated from kernel space.
+ * Since the buffer is external, then the shinfo or frags are
+ * also extern too. It also contains a destructor for itself.
+ */
+struct skb_external_page {
+	u8              *start;
+	int             size;
+	struct skb_frag_struct *frags;
+	struct skb_shared_info *ushinfo;
+	void		(*dtor)(struct skb_external_page *);
+};
 /* We divide dataref into two halves.  The higher 16 bits hold references
  * to the payload part of skb->data.  The lower 16 bits hold references to
  * the entire skb->data.  A clone of a headerless skb holds the length of
-- 
1.5.4.4

