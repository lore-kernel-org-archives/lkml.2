Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757770Ab0IXTVx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 15:21:53 -0400
Received: from qmta15.emeryville.ca.mail.comcast.net ([76.96.27.228]:36585
	"EHLO qmta15.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757757Ab0IXTVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 15:21:51 -0400
From: matt mooney <mfm@muteddisk.com>
To: kernel-janitors@vger.kernel.org
Cc: =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 13/24] misc: change to new flag variable
Date: Fri, 24 Sep 2010 12:17:23 -0700
Message-Id: <c2f1ef5590660ae574e9bdaf7136213741081404.1285355033.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <e93a3f1af26d2b0fc798b4c15401b3422ae6e2bd.1285355033.git.mfm@muteddisk.com>
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
In-Reply-To: <e0bdab5d2e8c52041c003de68ba774c3e706716c.1285355033.git.mfm@muteddisk.com>
References: <e0bdab5d2e8c52041c003de68ba774c3e706716c.1285355033.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace EXTRA_CFLAGS with ccflags-y.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/misc/cb710/Makefile   |    4 +---
 drivers/misc/sgi-gru/Makefile |    4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/misc/cb710/Makefile b/drivers/misc/cb710/Makefile
index 7b80cbf..467c8e9 100644
--- a/drivers/misc/cb710/Makefile
+++ b/drivers/misc/cb710/Makefile
@@ -1,6 +1,4 @@
-ifeq ($(CONFIG_CB710_DEBUG),y)
-	EXTRA_CFLAGS		+= -DDEBUG
-endif
+ccflags-$(CONFIG_CB710_DEBUG)	:= -DDEBUG
 
 obj-$(CONFIG_CB710_CORE)	+= cb710.o
 
diff --git a/drivers/misc/sgi-gru/Makefile b/drivers/misc/sgi-gru/Makefile
index 7c4c306..0003a1d 100644
--- a/drivers/misc/sgi-gru/Makefile
+++ b/drivers/misc/sgi-gru/Makefile
@@ -1,6 +1,4 @@
-ifdef CONFIG_SGI_GRU_DEBUG
-  EXTRA_CFLAGS	+= -DDEBUG
-endif
+ccflags-$(CONFIG_SGI_GRU_DEBUG)	:= -DDEBUG
 
 obj-$(CONFIG_SGI_GRU) := gru.o
 gru-y := grufile.o grumain.o grufault.o grutlbpurge.o gruprocfs.o grukservices.o gruhandles.o grukdump.o
-- 
1.7.2.1

