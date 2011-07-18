Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab1GRQm0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 12:42:26 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:2855 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446Ab1GRQmY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 12:42:24 -0400
From: "Mingarelli, Thomas" <Thomas.Mingarelli@hp.com>
To: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Wim Van Sebroeck <wim@iguana.be>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Date: Mon, 18 Jul 2011 17:40:53 +0100
Subject: RE: [PATCH -next] watchdog: hpwdt depends on PCI
Thread-Topic: [PATCH -next] watchdog: hpwdt depends on PCI
Thread-Index: AcxD7izZSCsi4VuJTRG3erJZzXYArgBeudfw
Message-ID: <183C1D5A376DE343AA8F94FC2A1EC1497D7ADD1EF0@GVW1091EXB.americas.hpqcorp.net>
References: <20110717000815.c83755be9598d34ac8431908@canb.auug.org.au>
 <20110716122549.2406a0f9.rdunlap@xenotime.net>
In-Reply-To: <20110716122549.2406a0f9.rdunlap@xenotime.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ack'd by Tom Mingarelli.

-----Original Message-----
From: Randy Dunlap [mailto:rdunlap@xenotime.net] 
Sent: Saturday, July 16, 2011 2:26 PM
To: Stephen Rothwell; Wim Van Sebroeck
Cc: linux-next@vger.kernel.org; LKML; Mingarelli, Thomas; akpm
Subject: [PATCH -next] watchdog: hpwdt depends on PCI

From: Randy Dunlap <rdunlap@xenotime.net>

hpwdt is a PCI driver so it should depend on PCI.
Fixes these build errors:

drivers/watchdog/hpwdt.c:762: error: implicit declaration of function 'pci_iomap'
drivers/watchdog/hpwdt.c:762: warning: assignment makes pointer from integer without a cast
drivers/watchdog/hpwdt.c:797: error: implicit declaration of function 'pci_iounmap'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: Thomas Mingarelli <thomas.mingarelli@hp.com>
---
 drivers/watchdog/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20110716.orig/drivers/watchdog/Kconfig
+++ linux-next-20110716/drivers/watchdog/Kconfig
@@ -619,7 +619,7 @@ config IT87_WDT
 
 config HP_WATCHDOG
 	tristate "HP ProLiant iLO2+ Hardware Watchdog Timer"
-	depends on X86
+	depends on X86 && PCI
 	default m
 	help
 	  A software monitoring watchdog and NMI sourcing driver. This driver
