Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757776Ab1ANOOy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 09:14:54 -0500
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:59650 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757525Ab1ANONd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 09:13:33 -0500
From: matt mooney <mfm@muteddisk.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RESEND PATCH 14/27] dma: change to new flag variable
Date: Fri, 14 Jan 2011 06:12:37 -0800
Message-Id: <93e344b0355b9f89daf740bfc63a9ce7478f544a.1295006565.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <cover.1295006561.git.mfm@muteddisk.com>
References: <cover.1295006561.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace EXTRA_CFLAGS with ccflags-y.

Signed-off-by: matt mooney <mfm@muteddisk.com>
Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
---
 drivers/dma/Makefile |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/Makefile b/drivers/dma/Makefile
index 64b21f5..1be065a 100644
--- a/drivers/dma/Makefile
+++ b/drivers/dma/Makefile
@@ -1,9 +1,5 @@
-ifeq ($(CONFIG_DMADEVICES_DEBUG),y)
-	ccflags-y	+= -DDEBUG
-endif
-ifeq ($(CONFIG_DMADEVICES_VDEBUG),y)
-	ccflags-y	+= -DVERBOSE_DEBUG
-endif
+ccflags-$(CONFIG_DMADEVICES_DEBUG)  := -DDEBUG
+ccflags-$(CONFIG_DMADEVICES_VDEBUG) += -DVERBOSE_DEBUG
 
 obj-$(CONFIG_DMA_ENGINE) += dmaengine.o
 obj-$(CONFIG_NET_DMA) += iovlock.o
-- 
1.7.3.4

