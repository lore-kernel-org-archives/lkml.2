Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549Ab0EUJY3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 05:24:29 -0400
Received: from mga01.intel.com ([192.55.52.88]:28660 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757470Ab0EUJYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 05:24:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,277,1272870000"; 
   d="scan'208";a="569306439"
From: xiaohui.xin@intel.com
To: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       mst@redhat.com, mingo@elte.hu, davem@davemloft.net,
       jdike@linux.intel.com
Cc: Xin Xiaohui <xiaohui.xin@intel.com>
Subject: [RFC][PATCH v6 18/19] Add a kconfig entry and make entry for mp device.
Date: Fri, 21 May 2010 17:30:34 +0800
Message-Id: <1274434235-5929-19-git-send-email-xiaohui.xin@intel.com>
X-Mailer: git-send-email 1.5.4.4
In-Reply-To: <1274434235-5929-18-git-send-email-xiaohui.xin@intel.com>
References: <1274434235-5929-1-git-send-email-xiaohui.xin@intel.com>
 <1274434235-5929-2-git-send-email-xiaohui.xin@intel.com>
 <1274434235-5929-3-git-send-email-xiaohui.xin@intel.com>
 <1274434235-5929-4-git-send-email-xiaohui.xin@intel.com>
 <1274434235-5929-5-git-send-email-xiaohui.xin@intel.com>
 <1274434235-5929-6-git-send-email-xiaohui.xin@intel.com>
 <1274434235-5929-7-git-send-email-xiaohui.xin@intel.com>
 <1274434235-5929-8-git-send-email-xiaohui.xin@intel.com>
 <1274434235-5929-9-git-send-email-xiaohui.xin@intel.com>
 <1274434235-5929-10-git-send-email-xiaohui.xin@intel.com>
 <1274434235-5929-11-git-send-email-xiaohui.xin@intel.com>
 <1274434235-5929-12-git-send-email-xiaohui.xin@intel.com>
 <1274434235-5929-13-git-send-email-xiaohui.xin@intel.com>
 <1274434235-5929-14-git-send-email-xiaohui.xin@intel.com>
 <1274434235-5929-15-git-send-email-xiaohui.xin@intel.com>
 <1274434235-5929-16-git-send-email-xiaohui.xin@intel.com>
 <1274434235-5929-17-git-send-email-xiaohui.xin@intel.com>
 <1274434235-5929-18-git-send-email-xiaohui.xin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xin Xiaohui <xiaohui.xin@intel.com>

Signed-off-by: Xin Xiaohui <xiaohui.xin@intel.com>
Reviewed-by: Jeff Dike <jdike@linux.intel.com>
---
 drivers/vhost/Kconfig  |   10 ++++++++++
 drivers/vhost/Makefile |    2 ++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
index e4e2fd1..a6b8cbf 100644
--- a/drivers/vhost/Kconfig
+++ b/drivers/vhost/Kconfig
@@ -9,3 +9,13 @@ config VHOST_NET
 	  To compile this driver as a module, choose M here: the module will
 	  be called vhost_net.
 
+config MEDIATE_PASSTHRU
+	tristate "mediate passthru network driver (EXPERIMENTAL)"
+	depends on VHOST_NET
+	---help---
+	  zerocopy network I/O support, we call it as mediate passthru to
+	  be distiguish with hardare passthru.
+
+	  To compile this driver as a module, choose M here: the module will
+	  be called mpassthru.
+
diff --git a/drivers/vhost/Makefile b/drivers/vhost/Makefile
index 72dd020..c18b9fc 100644
--- a/drivers/vhost/Makefile
+++ b/drivers/vhost/Makefile
@@ -1,2 +1,4 @@
 obj-$(CONFIG_VHOST_NET) += vhost_net.o
 vhost_net-y := vhost.o net.o
+
+obj-$(CONFIG_MEDIATE_PASSTHRU) += mpassthru.o
-- 
1.5.4.4

