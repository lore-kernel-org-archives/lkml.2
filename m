Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280Ab3AHNCA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 08:02:00 -0500
Received: from zmc.proxad.net ([212.27.53.206]:52134 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756242Ab3AHNB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 08:01:59 -0500
From: Florian Fainelli <florian@openwrt.org>
To: giometti@enneenne.com
Cc: linux-kernel@vger.kernel.org, Florian Fainelli <florian@openwrt.org>
Subject: [PATCH] pps: hide more configuration symbols behind CONFIG_PPS
Date: Tue,  8 Jan 2013 13:59:22 +0100
Message-Id: <1357649962-14664-1-git-send-email-florian@openwrt.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes CONFIG_PPS_DEBUG and CONFIG_NTP_PPS be hidden if
CONFIG_PPS is not selected, such that we are not prompted for these
configuration options if CONFIG_PPS is not set.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
 drivers/pps/Kconfig |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/pps/Kconfig b/drivers/pps/Kconfig
index 982d16b..dc19fb4 100644
--- a/drivers/pps/Kconfig
+++ b/drivers/pps/Kconfig
@@ -21,6 +21,8 @@ config PPS
 	  To compile this driver as a module, choose M here: the module
 	  will be called pps_core.ko.
 
+if PPS
+
 config PPS_DEBUG
 	bool "PPS debugging messages"
 	depends on PPS
@@ -38,6 +40,8 @@ config NTP_PPS
 
 	  It doesn't work on tickless systems at the moment.
 
+endif
+
 source drivers/pps/clients/Kconfig
 
 source drivers/pps/generators/Kconfig
-- 
1.7.10.4

