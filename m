Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab0IWGwu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 02:52:50 -0400
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:50666 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754247Ab0IWGwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 02:52:45 -0400
From: matt mooney <mfm@muteddisk.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: "John W. Linville" <linville@tuxdriver.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 20/20] net: change to new flag variable
Date: Wed, 22 Sep 2010 23:51:55 -0700
Message-Id: <1285224715-30137-1-git-send-email-mfm@muteddisk.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace EXTRA_CFLAGS with ccflags-y.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 net/caif/Makefile |    4 +---
 net/rds/Makefile  |    4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/caif/Makefile b/net/caif/Makefile
index f87481f..38581ba 100644
--- a/net/caif/Makefile
+++ b/net/caif/Makefile
@@ -1,6 +1,4 @@
-ifeq ($(CONFIG_CAIF_DEBUG),y)
-EXTRA_CFLAGS += -DDEBUG
-endif
+ccflags-$(CONFIG_CAIF_DEBUG) := -DDEBUG
 
 caif-objs := caif_dev.o \
 	cfcnfg.o cfmuxl.o cfctrl.o  \
diff --git a/net/rds/Makefile b/net/rds/Makefile
index b46eca1..f00fb19 100644
--- a/net/rds/Makefile
+++ b/net/rds/Makefile
@@ -15,7 +15,5 @@ obj-$(CONFIG_RDS_TCP) += rds_tcp.o
 rds_tcp-objs :=		tcp.o tcp_connect.o tcp_listen.o tcp_recv.o \
 			tcp_send.o tcp_stats.o
 
-ifeq ($(CONFIG_RDS_DEBUG), y)
-EXTRA_CFLAGS += -DDEBUG
-endif
+ccflags-$(CONFIG_RDS_DEBUG) := -DDEBUG
 
-- 
1.7.2.1

