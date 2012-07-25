Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106Ab2GYHqb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 03:46:31 -0400
Received: from mga03.intel.com ([143.182.124.21]:35226 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754857Ab2GYHq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 03:46:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="126639344"
Date: Wed, 25 Jul 2012 15:46:21 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Dave Airlie <airlied@redhat.com>
Cc: dri-devel@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>
Subject: [PATCH] fix nouveau build error on !CONFIG_MXM_WMI
Message-ID: <20120725074621.GA17467@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix build error on IA64:

ERROR: "mxm_wmi_supported" [drivers/gpu/drm/nouveau/nouveau.ko] undefined!

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 include/linux/mxm-wmi.h |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/mxm-wmi.h b/include/linux/mxm-wmi.h
index 617a295..f6a6214 100644
--- a/include/linux/mxm-wmi.h
+++ b/include/linux/mxm-wmi.h
@@ -28,6 +28,14 @@
 #define MXM_MXDS_ADAPTER_IGD 0x10
 int mxm_wmi_call_mxds(int adapter);
 int mxm_wmi_call_mxmx(int adapter);
+
+#if IS_ENABLED(CONFIG_MXM_WMI)
 bool mxm_wmi_supported(void);
+#else
+static inline bool mxm_wmi_supported(void)
+{
+	return false;
+}
+#endif
 
 #endif
-- 
1.7.10

