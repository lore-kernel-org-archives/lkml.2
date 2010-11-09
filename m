Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441Ab0KIIly (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 03:41:54 -0500
Received: from mga11.intel.com ([192.55.52.93]:40047 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754269Ab0KIIlu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 03:41:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,174,1288594800"; 
   d="scan'208";a="624917788"
From: xiaohui.xin@intel.com
To: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, mingo@elte.hu, davem@davemloft.net,
        herbert@gondor.hengli.com.au, jdike@linux.intel.com
Cc: Xin Xiaohui <xiaohui.xin@intel.com>
Subject: [PATCH v15 14/17]Add a kconfig entry and make entry for mp device.
Date: Tue,  9 Nov 2010 17:03:19 +0800
Message-Id: <73e3ccd4677860309c309fbbacc58ca7d74ab008.1289280886.git.xiaohui.xin@intel.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1289293402-4791-1-git-send-email-xiaohui.xin@intel.com>
References: <1289293402-4791-1-git-send-email-xiaohui.xin@intel.com>
In-Reply-To: <fc6e95d63a2c62aaf77f8ded22fc43ccefcdbbff.1289280885.git.xiaohui.xin@intel.com>
References: <fc6e95d63a2c62aaf77f8ded22fc43ccefcdbbff.1289280885.git.xiaohui.xin@intel.com>
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
1.7.3

