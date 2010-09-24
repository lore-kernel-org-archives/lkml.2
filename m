Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757848Ab0IXTWN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 15:22:13 -0400
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:38701 "EHLO
	qmta04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757804Ab0IXTWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 15:22:08 -0400
From: matt mooney <mfm@muteddisk.com>
To: kernel-janitors@vger.kernel.org
Cc: Matt Porter <mporter@kernel.crashing.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 19/24] rapidio: change to new flag variable
Date: Fri, 24 Sep 2010 12:17:29 -0700
Message-Id: <30c1ad7f4200136e00723fd76da1e58200e6e5b0.1285355033.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <75da5e0e0a547b4acbc7cfbdf35c29a24512ca37.1285355033.git.mfm@muteddisk.com>
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
 <facbf79cadc81f9043e89160b7b3b8a90926aba1.1285355033.git.mfm@muteddisk.com>
 <f8ffc630c8a56ebd5da0aa2227d63fecc21d4ee7.1285355033.git.mfm@muteddisk.com>
 <0472f95473283ce75285e458b22b86ff791d7a42.1285355033.git.mfm@muteddisk.com>
 <75da5e0e0a547b4acbc7cfbdf35c29a24512ca37.1285355033.git.mfm@muteddisk.com>
In-Reply-To: <e0bdab5d2e8c52041c003de68ba774c3e706716c.1285355033.git.mfm@muteddisk.com>
References: <e0bdab5d2e8c52041c003de68ba774c3e706716c.1285355033.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

switches/ depends on RAPIDIO_DEBUG so the subdir-ccflags-y variant
seems to be appropriate here.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/rapidio/Makefile          |    4 +---
 drivers/rapidio/switches/Makefile |    4 ----
 2 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/rapidio/Makefile b/drivers/rapidio/Makefile
index b6139fe..89b8eca 100644
--- a/drivers/rapidio/Makefile
+++ b/drivers/rapidio/Makefile
@@ -5,6 +5,4 @@ obj-y += rio.o rio-access.o rio-driver.o rio-scan.o rio-sysfs.o
 
 obj-$(CONFIG_RAPIDIO)		+= switches/
 
-ifeq ($(CONFIG_RAPIDIO_DEBUG),y)
-EXTRA_CFLAGS += -DDEBUG
-endif
+subdir-ccflags-$(CONFIG_RAPIDIO_DEBUG) := -DDEBUG
diff --git a/drivers/rapidio/switches/Makefile b/drivers/rapidio/switches/Makefile
index fe4adc3..0fece0e 100644
--- a/drivers/rapidio/switches/Makefile
+++ b/drivers/rapidio/switches/Makefile
@@ -6,7 +6,3 @@ obj-$(CONFIG_RAPIDIO_TSI57X)	+= tsi57x.o
 obj-$(CONFIG_RAPIDIO_CPS_XX)	+= idtcps.o
 obj-$(CONFIG_RAPIDIO_TSI568)	+= tsi568.o
 obj-$(CONFIG_RAPIDIO_TSI500)	+= tsi500.o
-
-ifeq ($(CONFIG_RAPIDIO_DEBUG),y)
-EXTRA_CFLAGS += -DDEBUG
-endif
-- 
1.7.2.1

