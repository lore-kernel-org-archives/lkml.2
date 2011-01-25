Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650Ab1AYIWh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 03:22:37 -0500
Received: from mail.windriver.com ([147.11.1.11]:40657 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab1AYIWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 03:22:35 -0500
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: nab@linux-iscsi.org, "David S. Miller" <davem@davemloft.net>,
        Kevin Hilman <khilman@deeprootsystems.com>
Subject: [PATCH] net: NETCONSOLE_DYNAMIC need CONFIGFS_FS=y
Date: Tue, 25 Jan 2011 16:22:28 +0800
Message-Id: <1295943748-9699-1-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 25 Jan 2011 08:22:30.0993 (UTC) FILETIME=[02832C10:01CBBC69]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With CONFIGFS_FS=m && NETCONSOLE_DYNAMIC=y, build error:

drivers/built-in.o: In function `netconsole_target_put':
build/drivers/net/netconsole.c:133: undefined reference to `config_item_put'
drivers/built-in.o: In function `netconsole_target_get':
build/drivers/net/netconsole.c:127: undefined reference to `config_item_get'
build/drivers/net/netconsole.c:127: undefined reference to `config_item_get'
drivers/built-in.o: In function `netconsole_target_put':
build/drivers/net/netconsole.c:133: undefined reference to `config_item_put'
drivers/built-in.o: In function `drop_netconsole_target':
build/drivers/net/netconsole.c:634: undefined reference to `config_item_put'
drivers/built-in.o: In function `make_netconsole_target':
build/drivers/net/netconsole.c:607: undefined reference to `config_item_init_type_name'
drivers/built-in.o: In function `dynamic_netconsole_init':
build/drivers/net/netconsole.c:109: undefined reference to `config_group_init'
build/drivers/net/netconsole.c:111: undefined reference to `configfs_register_subsystem'
drivers/built-in.o: In function `dynamic_netconsole_exit':
build/drivers/net/netconsole.c:116: undefined reference to `configfs_unregister_subsystem'

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Kevin Hilman <khilman@deeprootsystems.com>
---
 drivers/net/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 0382332..2b12c0d 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -3389,7 +3389,7 @@ config NETCONSOLE
 
 config NETCONSOLE_DYNAMIC
 	bool "Dynamic reconfiguration of logging targets"
-	depends on NETCONSOLE && SYSFS && CONFIGFS_FS
+	depends on NETCONSOLE && SYSFS && CONFIGFS_FS=y
 	help
 	  This option enables the ability to dynamically reconfigure target
 	  parameters (interface, IP addresses, port numbers, MAC addresses)
-- 
1.7.0.4

