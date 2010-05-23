Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660Ab0EWXdx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 19:33:53 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:39074 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755002Ab0EWXdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 19:33:51 -0400
Date: Sun, 23 May 2010 16:33:17 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       Lennart Poettering <mzxreary@0pointer.de>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org
Subject: [PATCH -next] platform/x86: msi-laptop depends on SERIO_I8042
Message-Id: <20100523163317.d1224414.randy.dunlap@oracle.com>
In-Reply-To: <20100522170459.4c89723d.sfr@canb.auug.org.au>
References: <20100522170459.4c89723d.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090204.4BF9BB51.002B:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

msi-laptop uses i8042_*() interfaces, so it should depend on
SERIO_I8042.  E.g., when SERIO_I8042=m and MSI_LAPTOP=y:

msi-laptop.c:(.text+0x18a7fe): undefined reference to `i8042_install_filter'
msi-laptop.c:(.init.text+0xd69d): undefined reference to `i8042_remove_filter'
msi-laptop.c:(.exit.text+0x19c3): undefined reference to `i8042_remove_filter'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Lennart Poettering <mzxreary@0pointer.de>
---
 drivers/platform/x86/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20100522.orig/drivers/platform/x86/Kconfig
+++ linux-next-20100522/drivers/platform/x86/Kconfig
@@ -151,6 +151,7 @@ config MSI_LAPTOP
 	depends on ACPI
 	depends on BACKLIGHT_CLASS_DEVICE
 	depends on RFKILL
+	depends on SERIO_I8042
 	---help---
 	  This is a driver for laptops built by MSI (MICRO-STAR
 	  INTERNATIONAL):
