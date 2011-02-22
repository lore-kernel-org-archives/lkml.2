Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764Ab1BVVtb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 16:49:31 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:56695 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab1BVVt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 16:49:29 -0500
Date: Tue, 22 Feb 2011 13:47:35 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Corentin Chary <corentincj@iksaif.net>,
        Matthew Garrett <mjg@redhat.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH -next] eeepc-wmi: kconfig changes to fix build errors
Message-Id: <20110222134735.0bfbec8b.randy.dunlap@oracle.com>
In-Reply-To: <20110222183437.ec2807bf.sfr@canb.auug.org.au>
References: <20110222183437.ec2807bf.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4D642F55.0028:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix eeepc-wmi build when CONFIG_HOTPLUG_PCI is not enabled:

eeepc-wmi.c:(.text+0x3bc5e9): undefined reference to `pci_hp_deregister'
eeepc-wmi.c:(.text+0x3bcca4): undefined reference to `__pci_hp_register'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/platform/x86/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20110222.orig/drivers/platform/x86/Kconfig
+++ linux-next-20110222/drivers/platform/x86/Kconfig
@@ -447,6 +447,7 @@ config EEEPC_WMI
 	depends on EXPERIMENTAL
 	depends on BACKLIGHT_CLASS_DEVICE
 	depends on RFKILL || RFKILL = n
+	depends on HOTPLUG_PCI
 	select INPUT_SPARSEKMAP
 	select LEDS_CLASS
 	select NEW_LEDS
