Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757015Ab0G2LEO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 07:04:14 -0400
Received: from mga11.intel.com ([192.55.52.93]:58755 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756953Ab0G2LBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 07:01:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,279,1278313200"; 
   d="scan'208";a="590877579"
From: xiaohui.xin@intel.com
To: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, mingo@elte.hu, davem@davemloft.net,
        herbert@gondor.hengli.com.au, jdike@linux.intel.com
Cc: Xin Xiaohui <xiaohui.xin@intel.com>
Subject: [RFC PATCH v8 11/16] Add header file for mp device.
Date: Thu, 29 Jul 2010 19:14:43 +0800
Message-Id: <1280402088-5849-12-git-send-email-xiaohui.xin@intel.com>
X-Mailer: git-send-email 1.5.4.4
In-Reply-To: <1280402088-5849-11-git-send-email-xiaohui.xin@intel.com>
References: <1280402088-5849-1-git-send-email-xiaohui.xin@intel.com>
 <1280402088-5849-2-git-send-email-xiaohui.xin@intel.com>
 <1280402088-5849-3-git-send-email-xiaohui.xin@intel.com>
 <1280402088-5849-4-git-send-email-xiaohui.xin@intel.com>
 <1280402088-5849-5-git-send-email-xiaohui.xin@intel.com>
 <1280402088-5849-6-git-send-email-xiaohui.xin@intel.com>
 <1280402088-5849-7-git-send-email-xiaohui.xin@intel.com>
 <1280402088-5849-8-git-send-email-xiaohui.xin@intel.com>
 <1280402088-5849-9-git-send-email-xiaohui.xin@intel.com>
 <1280402088-5849-10-git-send-email-xiaohui.xin@intel.com>
 <1280402088-5849-11-git-send-email-xiaohui.xin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xin Xiaohui <xiaohui.xin@intel.com>

Signed-off-by: Xin Xiaohui <xiaohui.xin@intel.com>
Signed-off-by: Zhao Yu <yzhao81new@gmail.com>
Reviewed-by: Jeff Dike <jdike@linux.intel.com>
---
 include/linux/mpassthru.h |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/mpassthru.h

diff --git a/include/linux/mpassthru.h b/include/linux/mpassthru.h
new file mode 100644
index 0000000..ba8f320
--- /dev/null
+++ b/include/linux/mpassthru.h
@@ -0,0 +1,25 @@
+#ifndef __MPASSTHRU_H
+#define __MPASSTHRU_H
+
+#include <linux/types.h>
+#include <linux/if_ether.h>
+
+/* ioctl defines */
+#define MPASSTHRU_BINDDEV      _IOW('M', 213, int)
+#define MPASSTHRU_UNBINDDEV    _IO('M', 214)
+
+#ifdef __KERNEL__
+#if defined(CONFIG_MEDIATE_PASSTHRU) || defined(CONFIG_MEDIATE_PASSTHRU_MODULE)
+struct socket *mp_get_socket(struct file *);
+#else
+#include <linux/err.h>
+#include <linux/errno.h>
+struct file;
+struct socket;
+static inline struct socket *mp_get_socket(struct file *f)
+{
+	return ERR_PTR(-EINVAL);
+}
+#endif /* CONFIG_MEDIATE_PASSTHRU */
+#endif /* __KERNEL__ */
+#endif /* __MPASSTHRU_H */
-- 
1.5.4.4

