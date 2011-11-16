Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932832Ab1KPBGD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 20:06:03 -0500
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:38578 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757655Ab1KPBGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 20:06:00 -0500
Message-ID: <4EC30C0C.9020409@xenotime.net>
Date: Tue, 15 Nov 2011 17:04:12 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>, Mark Einon <mark.einon@gmail.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: [PATCH -next] staging: fix more ET131X build errors
References: <20111115131742.f9ebaf818fd152ef779f4d19@canb.auug.org.au>
In-Reply-To: <20111115131742.f9ebaf818fd152ef779f4d19@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

ET131X is a network device, so it should depend on
NETDEVICES.  (This part won't be needed when the driver
moves to drivers/net/.)  It also uses PHYLIB interfaces,
so it should select PHYLIB.  Fixes these build errors:

ERROR: "phy_connect" [drivers/staging/et131x/et131x.ko] undefined!
ERROR: "phy_find_first" [drivers/staging/et131x/et131x.ko] undefined!
ERROR: "mdiobus_register" [drivers/staging/et131x/et131x.ko] undefined!
ERROR: "mdiobus_alloc" [drivers/staging/et131x/et131x.ko] undefined!
ERROR: "phy_stop" [drivers/staging/et131x/et131x.ko] undefined!
ERROR: "phy_start" [drivers/staging/et131x/et131x.ko] undefined!
ERROR: "mdiobus_free" [drivers/staging/et131x/et131x.ko] undefined!
ERROR: "mdiobus_unregister" [drivers/staging/et131x/et131x.ko] undefined!
ERROR: "phy_print_status" [drivers/staging/et131x/et131x.ko] undefined!
ERROR: "phy_ethtool_gset" [drivers/staging/et131x/et131x.ko] undefined!
ERROR: "phy_ethtool_sset" [drivers/staging/et131x/et131x.ko] undefined!
ERROR: "phy_mii_ioctl" [drivers/staging/et131x/et131x.ko] undefined!

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Apply after "depends on NET" patch.
--- next-2011-1115.orig/drivers/staging/et131x/Kconfig
+++ next-2011-1115/drivers/staging/et131x/Kconfig
@@ -1,6 +1,7 @@
 config ET131X
 	tristate "Agere ET-1310 Gigabit Ethernet support"
-	depends on PCI && NET
+	depends on PCI && NET && NETDEVICES
+	select PHYLIB
 	default n
 	---help---
 	  This driver supports Agere ET-1310 ethernet adapters.
