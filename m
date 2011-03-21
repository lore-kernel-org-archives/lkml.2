Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575Ab1CUPwB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 11:52:01 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:34165 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab1CUPv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 11:51:58 -0400
Date: Mon, 21 Mar 2011 08:51:43 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de,
        driverdevel <devel@driverdev.osuosl.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] staging/rtl81*: build as loadable modules only
Message-Id: <20110321085143.8eccf9bb.randy.dunlap@oracle.com>
In-Reply-To: <20110321144038.830fa54b.sfr@canb.auug.org.au>
References: <20110321144038.830fa54b.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4D877415.0142,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

These 3 drivers contain much duplicated (triplicated) code, so
building them as built-in results in many errors like:

(.text+0x1b160): multiple definition of `ieee80211_sta_ps_sleep'

Prevent this configuration by making them all buildable only as
loadable modules (similar to the vt665[56] patch last week).

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/staging/rtl8187se/Kconfig |    1 +
 drivers/staging/rtl8192e/Kconfig  |    1 +
 drivers/staging/rtl8192u/Kconfig  |    1 +
 3 files changed, 3 insertions(+)

--- linux-next-20110321.orig/drivers/staging/rtl8187se/Kconfig
+++ linux-next-20110321/drivers/staging/rtl8187se/Kconfig
@@ -1,6 +1,7 @@
 config R8187SE
 	tristate "RealTek RTL8187SE Wireless LAN NIC driver"
 	depends on PCI && WLAN
+	depends on m
 	select WIRELESS_EXT
 	select WEXT_PRIV
 	select EEPROM_93CX6
--- linux-next-20110321.orig/drivers/staging/rtl8192e/Kconfig
+++ linux-next-20110321/drivers/staging/rtl8192e/Kconfig
@@ -1,6 +1,7 @@
 config RTL8192E
 	tristate "RealTek RTL8192E Wireless LAN NIC driver"
 	depends on PCI && WLAN
+	depends on m
 	select WIRELESS_EXT
 	select WEXT_PRIV
 	select CRYPTO
--- linux-next-20110321.orig/drivers/staging/rtl8192u/Kconfig
+++ linux-next-20110321/drivers/staging/rtl8192u/Kconfig
@@ -1,6 +1,7 @@
 config RTL8192U
 	tristate "RealTek RTL8192U Wireless LAN NIC driver"
 	depends on PCI && WLAN && USB
+	depends on m
 	select WIRELESS_EXT
 	select WEXT_PRIV
 	select CRYPTO
