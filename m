Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847Ab0IYENi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 00:13:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:27792 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016Ab0IYEKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 00:10:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,233,1283756400"; 
   d="scan'208";a="557826797"
From: xiaohui.xin@intel.com
To: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, davem@davemloft.net, herbert@gondor.hengli.com.au,
        jdike@linux.intel.com
Cc: Xin Xiaohui <xiaohui.xin@intel.com>
Subject: [PATCH v11 09/17] Don't do skb recycle, if device use external buffer.
Date: Sat, 25 Sep 2010 12:27:27 +0800
Message-Id: <e9cc68e33662baf825a1a8c4dbd8404e2dd8c989.1285385607.git.xiaohui.xin@intel.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1285388855-27410-1-git-send-email-xiaohui.xin@intel.com>
References: <1285388855-27410-1-git-send-email-xiaohui.xin@intel.com>
In-Reply-To: <59d8a50047ee01e26658fd676d26c0162b79e5fd.1285385607.git.xiaohui.xin@intel.com>
References: <59d8a50047ee01e26658fd676d26c0162b79e5fd.1285385607.git.xiaohui.xin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xin Xiaohui <xiaohui.xin@intel.com>

Signed-off-by: Xin Xiaohui <xiaohui.xin@intel.com>
Signed-off-by: Zhao Yu <yzhao81new@gmail.com>
Reviewed-by: Jeff Dike <jdike@linux.intel.com>

---
 net/core/skbuff.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index bbf4707..9b156bb 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -565,6 +565,12 @@ int skb_recycle_check(struct sk_buff *skb, int skb_size)
 	if (skb_shared(skb) || skb_cloned(skb))
 		return 0;
 
+	/* if the device wants to do mediate passthru, the skb may
+	 * get external buffer, so don't recycle
+	 */
+	if (dev_is_mpassthru(skb->dev))
+		return 0;
+
 	skb_release_head_state(skb);
 	shinfo = skb_shinfo(skb);
 	atomic_set(&shinfo->dataref, 1);
-- 
1.7.3

