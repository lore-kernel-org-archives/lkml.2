Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757825Ab1ANOT7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 09:19:59 -0500
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:54781 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757829Ab1ANOTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 09:19:30 -0500
From: matt mooney <mfm@muteddisk.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RESEND PATCH 24/27] rapidio: change to new flag variable
Date: Fri, 14 Jan 2011 06:12:47 -0800
Message-Id: <6665ba07ced175b6d1fbc22ca03b5363bd78ed5b.1295006565.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <cover.1295006561.git.mfm@muteddisk.com>
References: <cover.1295006561.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

switches/ depends on RAPIDIO_DEBUG so the subdir-ccflags-y variant
seems to be appropriate here.

Signed-off-by: matt mooney <mfm@muteddisk.com>
Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
---
 drivers/rapidio/Makefile          |    4 +---
 drivers/rapidio/switches/Makefile |    4 -----
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
index 48d67a6..c4d3acc 100644
--- a/drivers/rapidio/switches/Makefile
+++ b/drivers/rapidio/switches/Makefile
@@ -7,7 +7,3 @@ obj-$(CONFIG_RAPIDIO_CPS_XX)	+= idtcps.o
 obj-$(CONFIG_RAPIDIO_TSI568)	+= tsi568.o
 obj-$(CONFIG_RAPIDIO_TSI500)	+= tsi500.o
 obj-$(CONFIG_RAPIDIO_CPS_GEN2)	+= idt_gen2.o
-
-ifeq ($(CONFIG_RAPIDIO_DEBUG),y)
-EXTRA_CFLAGS += -DDEBUG
-endif
-- 
1.7.3.4

