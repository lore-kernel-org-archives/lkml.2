Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579Ab0EGSYs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 14:24:48 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:30570 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757196Ab0EGSYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 14:24:46 -0400
Date: Fri, 7 May 2010 11:24:11 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Matthew Garrett <mjg@redhat.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       platform-driver-x86@vger.kernel.org
Subject: [PATCH -next] eeepc-wmi: depends on BACKLIGHT_CLASS_DEVICE
Message-Id: <20100507112411.0212242d.randy.dunlap@oracle.com>
In-Reply-To: <20100507155520.75026a8b.sfr@canb.auug.org.au>
References: <20100507155520.75026a8b.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090208.4BE45AE0.017A:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

eeepc-wmi uses backlight*() interfaces so it should depend on
BACKLIGHT_CLASS_DEVICE.

eeepc-wmi.c:(.text+0x2d7f54): undefined reference to `backlight_force_update'
eeepc-wmi.c:(.text+0x2d8012): undefined reference to `backlight_device_register'
eeepc-wmi.c:(.devinit.text+0x1c31c): undefined reference to `backlight_device_unregister'
eeepc-wmi.c:(.devexit.text+0x2f8b): undefined reference to `backlight_device_unregister'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/platform/x86/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20100507.orig/drivers/platform/x86/Kconfig
+++ linux-next-20100507/drivers/platform/x86/Kconfig
@@ -390,6 +390,7 @@ config EEEPC_WMI
 	depends on ACPI_WMI
 	depends on INPUT
 	depends on EXPERIMENTAL
+	depends on BACKLIGHT_CLASS_DEVICE
 	select INPUT_SPARSEKMAP
 	---help---
 	  Say Y here if you want to support WMI-based hotkeys on Eee PC laptops.
