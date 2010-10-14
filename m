Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab0JNEE1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 00:04:27 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:48684 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632Ab0JNEEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 00:04:25 -0400
Date: Wed, 13 Oct 2010 18:07:29 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Chris Ball <cjb@laptop.org>, Alex Dubov <oakad@yahoo.com>,
        akpm <akpm@linux-foundation.org>
Subject: [PATCH -next] tifm: fix kconfig dependencies
Message-Id: <20101013180729.766f2b3b.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kconfig dependency warning to satisfy dependencies:

warning: (MMC_TIFM_SD && MMC && EXPERIMENTAL && PCI || MEMSTICK_TIFM_MS && MEMSTICK && EXPERIMENTAL && PCI) selects TIFM_CORE which has unmet direct dependencies (MISC_DEVICES && EXPERIMENTAL && PCI)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/memstick/host/Kconfig |    1 +
 drivers/mmc/host/Kconfig      |    1 +
 2 files changed, 2 insertions(+)

--- linux-next-20101013.orig/drivers/memstick/host/Kconfig
+++ linux-next-20101013/drivers/memstick/host/Kconfig
@@ -7,6 +7,7 @@ comment "MemoryStick Host Controller Dri
 config MEMSTICK_TIFM_MS
 	tristate "TI Flash Media MemoryStick Interface support  (EXPERIMENTAL)"
 	depends on EXPERIMENTAL && PCI
+	select MISC_DEVICES
 	select TIFM_CORE
 	help
 	  Say Y here if you want to be able to access MemoryStick cards with
--- linux-next-20101013.orig/drivers/mmc/host/Kconfig
+++ linux-next-20101013/drivers/mmc/host/Kconfig
@@ -277,6 +277,7 @@ config MMC_MXC
 config MMC_TIFM_SD
 	tristate "TI Flash Media MMC/SD Interface support  (EXPERIMENTAL)"
 	depends on EXPERIMENTAL && PCI
+	select MISC_DEVICES
 	select TIFM_CORE
 	help
 	  Say Y here if you want to be able to access MMC/SD cards with
