Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333Ab0I3NrN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 09:47:13 -0400
Received: from mga03.intel.com ([143.182.124.21]:30013 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756278Ab0I3NrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 09:47:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,259,1283756400"; 
   d="scan'208";a="330506244"
From: xiaohui.xin@intel.com
To: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, mingo@elte.hu, davem@davemloft.net,
        herbert@gondor.hengli.com.au, jdike@linux.intel.com
Cc: Xin Xiaohui <xiaohui.xin@intel.com>
Subject: [PATCH v12 11/17] Add header file for mp device.
Date: Thu, 30 Sep 2010 22:04:28 +0800
Message-Id: <e3154d3c650ca5e8a33df346cc28a122544b596c.1285853725.git.xiaohui.xin@intel.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1285855474-12110-1-git-send-email-xiaohui.xin@intel.com>
References: <1285855474-12110-1-git-send-email-xiaohui.xin@intel.com>
In-Reply-To: <59d8a50047ee01e26658fd676d26c0162b79e5fd.1285853725.git.xiaohui.xin@intel.com>
References: <59d8a50047ee01e26658fd676d26c0162b79e5fd.1285853725.git.xiaohui.xin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xin Xiaohui <xiaohui.xin@intel.com>

Signed-off-by: Xin Xiaohui <xiaohui.xin@intel.com>
Signed-off-by: Zhao Yu <yzhao81new@gmail.com>
Reviewed-by: Jeff Dike <jdike@linux.intel.com>
---
 include/linux/mpassthru.h |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/mpassthru.h

diff --git a/include/linux/mpassthru.h b/include/linux/mpassthru.h
new file mode 100644
index 0000000..c0973b6
--- /dev/null
+++ b/include/linux/mpassthru.h
@@ -0,0 +1,26 @@
+#ifndef __MPASSTHRU_H
+#define __MPASSTHRU_H
+
+#include <linux/types.h>
+#include <linux/if_ether.h>
+#include <linux/ioctl.h>
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
1.7.3

