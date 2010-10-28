Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933096Ab0J1MQf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 08:16:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:33201 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932988Ab0J1MQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 08:16:32 -0400
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=zKaw4EI_zqEA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=ujcgHWeCht_Hv3SW8zUA:9 a=idfR7dOjmNrh0CXizOQA:7 a=79PcQq05JtbH15GOgiAZgL70RAIA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: [PATCH] Fix missing dependency of PCH_GBE driver
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, Dan Carpenter <error27@gmail.com>,
        Masayuki Ohtake <masa-korg@dsn.okisemi.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 28 Oct 2010 08:16:29 -0400
Message-ID: <1288268189.18238.173.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While doing some randconfigs I stumbled across this build error:

ERROR: "mii_ethtool_gset" [drivers/net/pch_gbe/pch_gbe.ko] undefined!
ERROR: "generic_mii_ioctl" [drivers/net/pch_gbe/pch_gbe.ko] undefined!
ERROR: "mii_nway_restart" [drivers/net/pch_gbe/pch_gbe.ko] undefined!
ERROR: "mii_check_gmii_support" [drivers/net/pch_gbe/pch_gbe.ko] undefined!
ERROR: "mii_link_ok" [drivers/net/pch_gbe/pch_gbe.ko] undefined!
ERROR: "mii_ethtool_sset" [drivers/net/pch_gbe/pch_gbe.ko] undefined!

The config option PCH_GBE is missing the dependency of MII.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 9334539..cf9769c 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -2540,7 +2540,7 @@ source "drivers/net/stmmac/Kconfig"
 
 config PCH_GBE
 	tristate "PCH Gigabit Ethernet"
-	depends on PCI
+	depends on PCI && MII
 	---help---
 	  This is a gigabit ethernet driver for Topcliff PCH.
 	  Topcliff PCH is the platform controller hub that is used in Intel's


