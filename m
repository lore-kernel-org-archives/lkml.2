Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932913Ab2ISR7N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 13:59:13 -0400
Received: from oproxy11-pub.bluehost.com ([173.254.64.10]:38237 "HELO
	oproxy11-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932823Ab2ISR7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 13:59:09 -0400
Message-ID: <505A07C4.7080601@xenotime.net>
Date: Wed, 19 Sep 2012 10:58:28 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH -next] staging: fix silicom dependencies and build errors
References: <20120919162643.907ddda75e198f060e4e83fe@canb.auug.org.au>
In-Reply-To: <20120919162643.907ddda75e198f060e4e83fe@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix kconfig dependencies in silicom.  Fixes these build errors:

ERROR: "init_net" [drivers/staging/silicom/bypasslib/bypass.ko] undefined!
ERROR: "register_netdevice_notifier" [drivers/staging/silicom/bpctl_mod.ko] undefined!
ERROR: "unregister_netdevice_notifier" [drivers/staging/silicom/bpctl_mod.ko] undefined!
ERROR: "init_net" [drivers/staging/silicom/bpctl_mod.ko] undefined!
ERROR: "netdev_info" [drivers/net/mii.ko] undefined!
ERROR: "netif_carrier_on" [drivers/net/mii.ko] undefined!
ERROR: "netif_carrier_off" [drivers/net/mii.ko] undefined!

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/staging/silicom/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20120919.orig/drivers/staging/silicom/Kconfig
+++ linux-next-20120919/drivers/staging/silicom/Kconfig
@@ -19,7 +19,7 @@ if NET_VENDOR_SILICOM
 
 config SBYPASS
 	tristate "Silicom BypassCTL library support"
-	depends on PCI
+	depends on PCI && NET
 	depends on m
 	---help---
 	  If you have a network (Ethernet) controller of this type, say Y
@@ -29,7 +29,7 @@ config SBYPASS
 
 config BPCTL
 	tristate "Silicom BypassCTL net support"
-	depends on PCI
+	depends on PCI && NET
 	depends on m
 	select SBYPASS
 	select NET_CORE
