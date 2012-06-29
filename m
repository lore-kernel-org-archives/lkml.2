Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932589Ab2F2Qtp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 12:49:45 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:42790 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756036Ab2F2Qq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 12:46:29 -0400
From: Vincent Sanders <vincent.sanders@collabora.co.uk>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Vincent Sanders <vincent.sanders@collabora.co.uk>
Subject: [PATCH net-next 10/15] net: bus: Add the AF_BUS socket address family to KBuild
Date: Fri, 29 Jun 2012 17:45:49 +0100
Message-Id: <1340988354-26981-11-git-send-email-vincent.sanders@collabora.co.uk>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1340988354-26981-1-git-send-email-vincent.sanders@collabora.co.uk>
References: <1340988354-26981-1-git-send-email-vincent.sanders@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>

This patch adds the AF_BUS code to the Linux Kernel build system.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Signed-off-by: Vincent Sanders <vincent.sanders@collabora.co.uk>
---
 net/Kconfig      |    1 +
 net/Makefile     |    1 +
 net/bus/Kconfig  |   15 +++++++++++++++
 net/bus/Makefile |    7 +++++++
 4 files changed, 24 insertions(+)
 create mode 100644 net/bus/Kconfig
 create mode 100644 net/bus/Makefile

diff --git a/net/Kconfig b/net/Kconfig
index 245831b..339a630 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -47,6 +47,7 @@ menu "Networking options"
 
 source "net/packet/Kconfig"
 source "net/unix/Kconfig"
+source "net/bus/Kconfig"
 source "net/xfrm/Kconfig"
 source "net/iucv/Kconfig"
 
diff --git a/net/Makefile b/net/Makefile
index 4f4ee08..ad0e900 100644
--- a/net/Makefile
+++ b/net/Makefile
@@ -19,6 +19,7 @@ obj-$(CONFIG_NETFILTER)		+= netfilter/
 obj-$(CONFIG_INET)		+= ipv4/
 obj-$(CONFIG_XFRM)		+= xfrm/
 obj-$(CONFIG_UNIX)		+= unix/
+obj-$(CONFIG_AF_BUS)		+= bus/
 obj-$(CONFIG_NET)		+= ipv6/
 obj-$(CONFIG_PACKET)		+= packet/
 obj-$(CONFIG_NET_KEY)		+= key/
diff --git a/net/bus/Kconfig b/net/bus/Kconfig
new file mode 100644
index 0000000..5f01410
--- /dev/null
+++ b/net/bus/Kconfig
@@ -0,0 +1,15 @@
+#
+# Bus Domain Sockets
+#
+
+config AF_BUS
+	tristate "Bus domain sockets (EXPERIMENTAL)"
+	depends on EXPERIMENTAL
+	---help---
+	  If you say Y here, you will include support for Bus domain sockets.
+	  These sockets are used to create communication buses for IPC.
+
+	  To compile this driver as a module, choose M here: the module will be
+	  called bus.
+
+	  Say N unless you know what you are doing.
diff --git a/net/bus/Makefile b/net/bus/Makefile
new file mode 100644
index 0000000..8c1fea2
--- /dev/null
+++ b/net/bus/Makefile
@@ -0,0 +1,7 @@
+#
+# Makefile for the Linux bus domain socket layer.
+#
+
+obj-$(CONFIG_AF_BUS)	+= af-bus.o
+
+af-bus-y		:= af_bus.o garbage.o
-- 
1.7.10

