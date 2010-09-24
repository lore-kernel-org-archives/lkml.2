Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691Ab0IXTVX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 15:21:23 -0400
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:50172
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757677Ab0IXTVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 15:21:20 -0400
From: matt mooney <mfm@muteddisk.com>
To: kernel-janitors@vger.kernel.org
Cc: Tom Tucker <tom@opengridcomputing.com>,
        Steve Wise <swise@opengridcomputing.com>,
        Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Ralph Campbell <infinipath@qlogic.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 08/24] infiniband: change to new flag variable
Date: Fri, 24 Sep 2010 12:17:18 -0700
Message-Id: <b484ccf548e1700e09ac7f731289503bf3e7b3bf.1285355033.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <40a2d76d013ad025d08a411992af10f6bbef0a13.1285355033.git.mfm@muteddisk.com>
References: <e0bdab5d2e8c52041c003de68ba774c3e706716c.1285355033.git.mfm@muteddisk.com>
 <9968d4260be8850200cc9c7dfe08addf611468b4.1285355033.git.mfm@muteddisk.com>
 <036514b5dd23c5af14303519d79d60d79adccbee.1285355033.git.mfm@muteddisk.com>
 <ffbd189ef2d414ea7c87ffe2b40fce87877dc014.1285355033.git.mfm@muteddisk.com>
 <b3e2061e1e6703f7b84c0484030e07de6000546a.1285355033.git.mfm@muteddisk.com>
 <70fe6b462b3ee22922698a12d62d650cf029033a.1285355033.git.mfm@muteddisk.com>
 <40a2d76d013ad025d08a411992af10f6bbef0a13.1285355033.git.mfm@muteddisk.com>
In-Reply-To: <e0bdab5d2e8c52041c003de68ba774c3e706716c.1285355033.git.mfm@muteddisk.com>
References: <e0bdab5d2e8c52041c003de68ba774c3e706716c.1285355033.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace EXTRA_CFLAGS with ccflags-y.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/infiniband/hw/amso1100/Kbuild |    4 +---
 drivers/infiniband/hw/cxgb3/Makefile  |    6 ++----
 drivers/infiniband/hw/cxgb4/Makefile  |    2 +-
 drivers/infiniband/hw/ipath/Makefile  |    2 +-
 4 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/amso1100/Kbuild b/drivers/infiniband/hw/amso1100/Kbuild
index 06964c4..950dfab 100644
--- a/drivers/infiniband/hw/amso1100/Kbuild
+++ b/drivers/infiniband/hw/amso1100/Kbuild
@@ -1,6 +1,4 @@
-ifdef CONFIG_INFINIBAND_AMSO1100_DEBUG
-EXTRA_CFLAGS += -DDEBUG
-endif
+ccflags-$(CONFIG_INFINIBAND_AMSO1100_DEBUG) := -DDEBUG
 
 obj-$(CONFIG_INFINIBAND_AMSO1100) += iw_c2.o
 
diff --git a/drivers/infiniband/hw/cxgb3/Makefile b/drivers/infiniband/hw/cxgb3/Makefile
index 7e7b5a6..621619c 100644
--- a/drivers/infiniband/hw/cxgb3/Makefile
+++ b/drivers/infiniband/hw/cxgb3/Makefile
@@ -1,10 +1,8 @@
-EXTRA_CFLAGS += -Idrivers/net/cxgb3
+ccflags-y := -Idrivers/net/cxgb3
 
 obj-$(CONFIG_INFINIBAND_CXGB3) += iw_cxgb3.o
 
 iw_cxgb3-y :=  iwch_cm.o iwch_ev.o iwch_cq.o iwch_qp.o iwch_mem.o \
 	       iwch_provider.o iwch.o cxio_hal.o cxio_resource.o
 
-ifdef CONFIG_INFINIBAND_CXGB3_DEBUG
-EXTRA_CFLAGS += -DDEBUG
-endif
+ccflags-$(CONFIG_INFINIBAND_CXGB3_DEBUG) += -DDEBUG
diff --git a/drivers/infiniband/hw/cxgb4/Makefile b/drivers/infiniband/hw/cxgb4/Makefile
index e31a499..cd20b13 100644
--- a/drivers/infiniband/hw/cxgb4/Makefile
+++ b/drivers/infiniband/hw/cxgb4/Makefile
@@ -1,4 +1,4 @@
-EXTRA_CFLAGS += -Idrivers/net/cxgb4
+ccflags-y := -Idrivers/net/cxgb4
 
 obj-$(CONFIG_INFINIBAND_CXGB4) += iw_cxgb4.o
 
diff --git a/drivers/infiniband/hw/ipath/Makefile b/drivers/infiniband/hw/ipath/Makefile
index fa3df82..4496f28 100644
--- a/drivers/infiniband/hw/ipath/Makefile
+++ b/drivers/infiniband/hw/ipath/Makefile
@@ -1,4 +1,4 @@
-EXTRA_CFLAGS += -DIPATH_IDSTR='"QLogic kernel.org driver"' \
+ccflags-y := -DIPATH_IDSTR='"QLogic kernel.org driver"' \
 	-DIPATH_KERN_TYPE=0
 
 obj-$(CONFIG_INFINIBAND_IPATH) += ib_ipath.o
-- 
1.7.2.1

