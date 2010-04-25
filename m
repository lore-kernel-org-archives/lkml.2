Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab0DYJR6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 05:17:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:15637 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817Ab0DYJRR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 05:17:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,269,1270450800"; 
   d="scan'208";a="561295890"
From: xiaohui.xin@intel.com
To: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       mst@redhat.com, mingo@elte.hu, davem@davemloft.net,
       jdike@linux.intel.com
Cc: Xin Xiaohui <xiaohui.xin@intel.com>
Subject: [RFC][PATCH v4 13/18] Add header file for mp device.
Date: Sun, 25 Apr 2010 17:20:00 +0800
Message-Id: <1272187206-18534-13-git-send-email-xiaohui.xin@intel.com>
X-Mailer: git-send-email 1.5.4.4
In-Reply-To: <1272187206-18534-12-git-send-email-xiaohui.xin@intel.com>
References: <1272187206-18534-1-git-send-email-xiaohui.xin@intel.com>
 <1272187206-18534-2-git-send-email-xiaohui.xin@intel.com>
 <1272187206-18534-3-git-send-email-xiaohui.xin@intel.com>
 <1272187206-18534-4-git-send-email-xiaohui.xin@intel.com>
 <1272187206-18534-5-git-send-email-xiaohui.xin@intel.com>
 <1272187206-18534-6-git-send-email-xiaohui.xin@intel.com>
 <1272187206-18534-7-git-send-email-xiaohui.xin@intel.com>
 <1272187206-18534-8-git-send-email-xiaohui.xin@intel.com>
 <1272187206-18534-9-git-send-email-xiaohui.xin@intel.com>
 <1272187206-18534-10-git-send-email-xiaohui.xin@intel.com>
 <1272187206-18534-11-git-send-email-xiaohui.xin@intel.com>
 <1272187206-18534-12-git-send-email-xiaohui.xin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xin Xiaohui <xiaohui.xin@intel.com>

Signed-off-by: Xin Xiaohui <xiaohui.xin@intel.com>
Signed-off-by: Zhao Yu <yzhao81@gmail.com>
Reviewed-by: Jeff Dike <jdike@linux.intel.com>
---

 include/linux/mpassthru.h |   29 +++++++++++++++++++++++++++++
 1 files changed, 29 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/mpassthru.h

diff --git a/include/linux/mpassthru.h b/include/linux/mpassthru.h
new file mode 100644
index 0000000..e3983d3
--- /dev/null
+++ b/include/linux/mpassthru.h
@@ -0,0 +1,29 @@
+#ifndef __MPASSTHRU_H
+#define __MPASSTHRU_H
+
+#include <linux/types.h>
+#include <linux/if_ether.h>
+
+/* ioctl defines */
+#define MPASSTHRU_BINDDEV      _IOW('M', 213, int)
+#define MPASSTHRU_UNBINDDEV    _IOW('M', 214, int)
+
+/* MPASSTHRU ifc flags */
+#define IFF_MPASSTHRU		0x0001
+#define IFF_MPASSTHRU_EXCL	0x0002
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

