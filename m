Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757704Ab0IXTVb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 15:21:31 -0400
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:35300 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757673Ab0IXTV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 15:21:29 -0400
From: matt mooney <mfm@muteddisk.com>
To: kernel-janitors@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 11/24] memstick: change to new flag variable
Date: Fri, 24 Sep 2010 12:17:21 -0700
Message-Id: <8cea68a58c5ddba79fc96e93fa0b23681e6a7ffe.1285355033.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <ec9520aca140f253d8bad33cf35b8e668e7e9c9c.1285355033.git.mfm@muteddisk.com>
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
In-Reply-To: <e0bdab5d2e8c52041c003de68ba774c3e706716c.1285355033.git.mfm@muteddisk.com>
References: <e0bdab5d2e8c52041c003de68ba774c3e706716c.1285355033.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The EXTRA_CFLAGS assignment in memstick/Makefile was not accomplishing
anything because this flag only has effect on sources at the same level
as the makefile (i.e., per directory). Since both core/ and host/ rely
on MEMSTICK_DEBUG, the subdir-ccflags-y variant seems to be the
appropriate choice.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/memstick/Makefile      |    4 +---
 drivers/memstick/core/Makefile |    4 ----
 drivers/memstick/host/Makefile |    4 ----
 3 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/drivers/memstick/Makefile b/drivers/memstick/Makefile
index dc160fb..9862359 100644
--- a/drivers/memstick/Makefile
+++ b/drivers/memstick/Makefile
@@ -2,9 +2,7 @@
 # Makefile for the kernel MemoryStick device drivers.
 #
 
-ifeq ($(CONFIG_MEMSTICK_DEBUG),y)
-	EXTRA_CFLAGS		+= -DDEBUG
-endif
+subdir-ccflags-$(CONFIG_MEMSTICK_DEBUG) := -DDEBUG
 
 obj-$(CONFIG_MEMSTICK)		+= core/
 obj-$(CONFIG_MEMSTICK)		+= host/
diff --git a/drivers/memstick/core/Makefile b/drivers/memstick/core/Makefile
index 8b2b529..ecd0299 100644
--- a/drivers/memstick/core/Makefile
+++ b/drivers/memstick/core/Makefile
@@ -2,10 +2,6 @@
 # Makefile for the kernel MemoryStick core.
 #
 
-ifeq ($(CONFIG_MEMSTICK_DEBUG),y)
-	EXTRA_CFLAGS		+= -DDEBUG
-endif
-
 obj-$(CONFIG_MEMSTICK)		+= memstick.o
 
 obj-$(CONFIG_MSPRO_BLOCK)	+= mspro_block.o
diff --git a/drivers/memstick/host/Makefile b/drivers/memstick/host/Makefile
index 12530e4..a1815e9 100644
--- a/drivers/memstick/host/Makefile
+++ b/drivers/memstick/host/Makefile
@@ -2,9 +2,5 @@
 # Makefile for MemoryStick host controller drivers
 #
 
-ifeq ($(CONFIG_MEMSTICK_DEBUG),y)
-	EXTRA_CFLAGS			+= -DDEBUG
-endif
-
 obj-$(CONFIG_MEMSTICK_TIFM_MS)		+= tifm_ms.o
 obj-$(CONFIG_MEMSTICK_JMICRON_38X)	+= jmb38x_ms.o
-- 
1.7.2.1

