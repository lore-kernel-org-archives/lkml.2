Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863Ab1ANOVG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 09:21:06 -0500
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:50197 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757826Ab1ANOT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 09:19:29 -0500
X-Greylist: delayed 347 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Jan 2011 09:19:03 EST
From: matt mooney <mfm@muteddisk.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RESEND PATCH 19/27] memstick: change to new flag variable
Date: Fri, 14 Jan 2011 06:12:42 -0800
Message-Id: <6ce7d048ea0df01bc3e7e186a3a38d9c59126f09.1295006565.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <cover.1295006561.git.mfm@muteddisk.com>
References: <cover.1295006561.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The EXTRA_CFLAGS assignment in memstick/Makefile was not accomplishing
anything because this flag only has effect on sources at the same level
as the makefile (i.e., per directory). Since both core/ and host/ rely
on MEMSTICK_DEBUG, the subdir-ccflags-y variant seems to be the
appropriate choice.

Signed-off-by: matt mooney <mfm@muteddisk.com>
Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
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
1.7.3.4

