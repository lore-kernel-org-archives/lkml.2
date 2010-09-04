Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913Ab0IDBCg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 21:02:36 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:36076 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212Ab0IDBCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 21:02:34 -0400
Date: Fri, 3 Sep 2010 18:01:56 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        sreedhara.ds@intel.com
Subject: [PATCH -next] staging: mrst touchscreen depends on SPI
Message-Id: <20100903180156.af17d4a8.randy.dunlap@oracle.com>
In-Reply-To: <20100903135206.d9bc2093.sfr@canb.auug.org.au>
References: <20100903135206.d9bc2093.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Moorestown touchscreen driver should depend on SPI.
Fixes these build errors:

intel-mid-touch.c:(.init.text+0xdd34): undefined reference to `spi_register_driver'
drivers/built-in.o:(.data+0x21778): undefined reference to `spi_bus_type'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: sreedhara.ds@intel.com
---
 drivers/staging/mrst-touchscreen/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20100903.orig/drivers/staging/mrst-touchscreen/Kconfig
+++ linux-next-20100903/drivers/staging/mrst-touchscreen/Kconfig
@@ -1,6 +1,6 @@
 config TOUCHSCREEN_INTEL_MID
 	tristate "Intel MID platform resistive touchscreen"
-	depends on INTEL_SCU_IPC
+	depends on INTEL_SCU_IPC && SPI
 	default y
 	help
 	  Say Y here if you have a Intel MID based touchscreen
