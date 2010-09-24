Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757789Ab0IXTV6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 15:21:58 -0400
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:53125
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757774Ab0IXTVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 15:21:54 -0400
From: matt mooney <mfm@muteddisk.com>
To: kernel-janitors@vger.kernel.org
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 14/24] mmc: change to new flag variable
Date: Fri, 24 Sep 2010 12:17:24 -0700
Message-Id: <efe88633e146de3e173afea14f777c41c37e5db2.1285355033.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <c2f1ef5590660ae574e9bdaf7136213741081404.1285355033.git.mfm@muteddisk.com>
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
In-Reply-To: <e0bdab5d2e8c52041c003de68ba774c3e706716c.1285355033.git.mfm@muteddisk.com>
References: <e0bdab5d2e8c52041c003de68ba774c3e706716c.1285355033.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The EXTRA_CFLAGS assignment in mmc/Makefile was not accomplishing
anything because this flag only has effect on sources at the same level
as the makefile (i.e., per directory). Since card/, core/, and host/
rely on MMC_DEBUG, the subdir-ccflags-y variant seems to be the
appropriate choice.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/mmc/Makefile      |    4 +---
 drivers/mmc/card/Makefile |    4 ----
 drivers/mmc/core/Makefile |    4 ----
 drivers/mmc/host/Makefile |    4 ----
 4 files changed, 1 insertions(+), 15 deletions(-)

diff --git a/drivers/mmc/Makefile b/drivers/mmc/Makefile
index 9979f5e..12eef39 100644
--- a/drivers/mmc/Makefile
+++ b/drivers/mmc/Makefile
@@ -2,9 +2,7 @@
 # Makefile for the kernel mmc device drivers.
 #
 
-ifeq ($(CONFIG_MMC_DEBUG),y)
-	EXTRA_CFLAGS		+= -DDEBUG
-endif
+subdir-ccflags-$(CONFIG_MMC_DEBUG) := -DDEBUG
 
 obj-$(CONFIG_MMC)		+= core/
 obj-$(CONFIG_MMC)		+= card/
diff --git a/drivers/mmc/card/Makefile b/drivers/mmc/card/Makefile
index 0d40751..c73b406 100644
--- a/drivers/mmc/card/Makefile
+++ b/drivers/mmc/card/Makefile
@@ -2,10 +2,6 @@
 # Makefile for MMC/SD card drivers
 #
 
-ifeq ($(CONFIG_MMC_DEBUG),y)
-	EXTRA_CFLAGS		+= -DDEBUG
-endif
-
 obj-$(CONFIG_MMC_BLOCK)		+= mmc_block.o
 mmc_block-objs			:= block.o queue.o
 obj-$(CONFIG_MMC_TEST)		+= mmc_test.o
diff --git a/drivers/mmc/core/Makefile b/drivers/mmc/core/Makefile
index 889e5f8..86b4791 100644
--- a/drivers/mmc/core/Makefile
+++ b/drivers/mmc/core/Makefile
@@ -2,10 +2,6 @@
 # Makefile for the kernel mmc core.
 #
 
-ifeq ($(CONFIG_MMC_DEBUG),y)
-	EXTRA_CFLAGS		+= -DDEBUG
-endif
-
 obj-$(CONFIG_MMC)		+= mmc_core.o
 mmc_core-y			:= core.o bus.o host.o \
 				   mmc.o mmc_ops.o sd.o sd_ops.o \
diff --git a/drivers/mmc/host/Makefile b/drivers/mmc/host/Makefile
index 840bcb5..e35e778 100644
--- a/drivers/mmc/host/Makefile
+++ b/drivers/mmc/host/Makefile
@@ -2,10 +2,6 @@
 # Makefile for MMC/SD host controller drivers
 #
 
-ifeq ($(CONFIG_MMC_DEBUG),y)
-	EXTRA_CFLAGS		+= -DDEBUG
-endif
-
 obj-$(CONFIG_MMC_ARMMMCI)	+= mmci.o
 obj-$(CONFIG_MMC_PXA)		+= pxamci.o
 obj-$(CONFIG_MMC_IMX)		+= imxmmc.o
-- 
1.7.2.1

