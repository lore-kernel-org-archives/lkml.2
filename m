Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757794Ab0IXTWH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 15:22:07 -0400
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:41643 "EHLO
	qmta05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757797Ab0IXTWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 15:22:02 -0400
From: matt mooney <mfm@muteddisk.com>
To: kernel-janitors@vger.kernel.org
Cc: Sjur Braendeland <sjur.brandeland@stericsson.com>, Jouni Malinen <j@w1.fi>,
        "John W. Linville" <linville@tuxdriver.com>,
        Daniel Drake <dsd@gentoo.org>, Ulrich Kunitz <kune@deine-taler.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH 15/24] net: change to new flag variable
Date: Fri, 24 Sep 2010 12:17:25 -0700
Message-Id: <facbf79cadc81f9043e89160b7b3b8a90926aba1.1285355033.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <efe88633e146de3e173afea14f777c41c37e5db2.1285355033.git.mfm@muteddisk.com>
References: <e0bdab5d2e8c52041c003de68ba774c3e706716c.1285355033.git.mfm@muteddisk.com>
 <9968d4260be8850200cc9c7dfe08addf611468b4.1285355033.git.mfm@muteddisk.com>
 <036514b5dd23c5af14303519d79d60d79adccbee.1285355033.git.mfm@muteddisk.com>
 <ffbd189ef2d414ea7c87ffe2b40fce87877dc014.1285355033.git.mfm@muteddisk.com>
 <b3e2061e1e6703f7b84c0484030e07de6000546a.1285355033.git.mfm@muteddisk.com>
 <70fe6b462b3ee22922698a12d62d650cf029033a.1285355033.git.mfm@muteddisk.com>
 <40a2d76d013ad025d08a411992af10f6bbef0a13.1285355033.git.mfm@muteddisk.com>
 <b484ccf548e1700e09ac7f731289503bf3e7b3bf.1285355033.git.mfm@muteddisk.com>
 <2c0fbcaafb18007c5c83823cb33e35120fe15091.1285355033.git.mfm@muteddisk.com>
 <ec9520aca140f253d8bad33cf35b8e668e7e9c9c.1285355033.git.mfm@muteddisk.com>
 <8cea68a58c5ddba79fc96e93fa0b23681e6a7ffe.1285355033.git.mfm@muteddisk.com>
 <e93a3f1af26d2b0fc798b4c15401b3422ae6e2bd.1285355033.git.mfm@muteddisk.com>
 <c2f1ef5590660ae574e9bdaf7136213741081404.1285355033.git.mfm@muteddisk.com>
 <efe88633e146de3e173afea14f777c41c37e5db2.1285355033.git.mfm@muteddisk.com>
In-Reply-To: <e0bdab5d2e8c52041c003de68ba774c3e706716c.1285355033.git.mfm@muteddisk.com>
References: <e0bdab5d2e8c52041c003de68ba774c3e706716c.1285355033.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace EXTRA_CFLAGS with ccflags-y.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/net/caif/Makefile                   |    4 +---
 drivers/net/skfp/Makefile                   |    2 +-
 drivers/net/wan/lmc/Makefile                |    2 +-
 drivers/net/wireless/hostap/hostap_config.h |    4 ++--
 drivers/net/wireless/zd1211rw/Makefile      |    4 +---
 5 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/net/caif/Makefile b/drivers/net/caif/Makefile
index 3a11d61..b5dc44c 100644
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
index cb23580..045d815 100644
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
1.7.2.1

