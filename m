Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460Ab1ANOOG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 09:14:06 -0500
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:59551 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757584Ab1ANONn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 09:13:43 -0500
From: matt mooney <mfm@muteddisk.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RESEND PATCH 22/27] net: change to new flag variable
Date: Fri, 14 Jan 2011 06:12:45 -0800
Message-Id: <825b254ea0c551d2a7c0d914d37dcfd16af164b2.1295006565.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <cover.1295006561.git.mfm@muteddisk.com>
References: <cover.1295006561.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace EXTRA_CFLAGS with ccflags-y.

Signed-off-by: matt mooney <mfm@muteddisk.com>
Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
Acked-by: Sjur Braendeland <sjur.brandeland@stericsson.com>
Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/caif/Makefile                   |    4 +---
 drivers/net/skfp/Makefile                   |    2 +-
 drivers/net/wan/lmc/Makefile                |    2 +-
 drivers/net/wireless/hostap/hostap_config.h |    4 ++--
 drivers/net/wireless/zd1211rw/Makefile      |    4 +---
 5 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/net/caif/Makefile b/drivers/net/caif/Makefile
index b38d987..9560b9d 100644
--- a/drivers/net/caif/Makefile
+++ b/drivers/net/caif/Makefile
@@ -1,6 +1,4 @@
-ifeq ($(CONFIG_CAIF_DEBUG),y)
-EXTRA_CFLAGS += -DDEBUG
-endif
+ccflags-$(CONFIG_CAIF_DEBUG) := -DDEBUG
 
 # Serial interface
 obj-$(CONFIG_CAIF_TTY) += caif_serial.o
diff --git a/drivers/net/skfp/Makefile b/drivers/net/skfp/Makefile
index cb23580..b0be023 100644
--- a/drivers/net/skfp/Makefile
+++ b/drivers/net/skfp/Makefile
@@ -17,4 +17,4 @@ skfp-objs :=  skfddi.o    hwmtm.o    fplustm.o  smt.o      cfm.o     \
 #   projects. To keep the source common for all those drivers (and
 #   thus simplify fixes to it), please do not clean it up!
 
-EXTRA_CFLAGS += -Idrivers/net/skfp -DPCI -DMEM_MAPPED_IO -Wno-strict-prototypes 
+ccflags-y := -Idrivers/net/skfp -DPCI -DMEM_MAPPED_IO -Wno-strict-prototypes
diff --git a/drivers/net/wan/lmc/Makefile b/drivers/net/wan/lmc/Makefile
index dabdcfe..609710d 100644
--- a/drivers/net/wan/lmc/Makefile
+++ b/drivers/net/wan/lmc/Makefile
@@ -14,4 +14,4 @@ lmc-objs := lmc_debug.o lmc_media.o lmc_main.o lmc_proto.o
 # -DDEBUG \
 # -DLMC_PACKET_LOG
 
-EXTRA_CFLAGS += -I. $(DBGDEF)
+ccflags-y := -I. $(DBGDEF)
diff --git a/drivers/net/wireless/hostap/hostap_config.h b/drivers/net/wireless/hostap/hostap_config.h
index 30acd39..2c8f71f 100644
--- a/drivers/net/wireless/hostap/hostap_config.h
+++ b/drivers/net/wireless/hostap/hostap_config.h
@@ -30,9 +30,9 @@
 
 /* Following defines can be used to remove unneeded parts of the driver, e.g.,
  * to limit the size of the kernel module. Definitions can be added here in
- * hostap_config.h or they can be added to make command with EXTRA_CFLAGS,
+ * hostap_config.h or they can be added to make command with ccflags-y,
  * e.g.,
- * 'make pccard EXTRA_CFLAGS="-DPRISM2_NO_DEBUG -DPRISM2_NO_PROCFS_DEBUG"'
+ * 'make pccard ccflags-y="-DPRISM2_NO_DEBUG -DPRISM2_NO_PROCFS_DEBUG"'
  */
 
 /* Do not include debug messages into the driver */
diff --git a/drivers/net/wireless/zd1211rw/Makefile b/drivers/net/wireless/zd1211rw/Makefile
index 1907eaf..5728a91 100644
--- a/drivers/net/wireless/zd1211rw/Makefile
+++ b/drivers/net/wireless/zd1211rw/Makefile
@@ -5,7 +5,5 @@ zd1211rw-objs := zd_chip.o zd_mac.o \
 		zd_rf_al7230b.o zd_rf_uw2453.o \
 		zd_rf.o zd_usb.o
 
-ifeq ($(CONFIG_ZD1211RW_DEBUG),y)
-EXTRA_CFLAGS += -DDEBUG
-endif
+ccflags-$(CONFIG_ZD1211RW_DEBUG) := -DDEBUG
 
-- 
1.7.3.4

